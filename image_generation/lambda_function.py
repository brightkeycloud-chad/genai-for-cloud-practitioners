import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

bedrock = boto3.client('bedrock-runtime')

def lambda_handler(event, context):
    """
    Lambda function demonstrating Foundation Model -> LLM -> Application flow
    """
    try:
        # Parse request
        body = json.loads(event['body'])
        user_question = body.get('question', '')
        
        if not user_question:
            return {
                'statusCode': 400,
                'headers': {'Content-Type': 'application/json'},
                'body': json.dumps({'error': 'Question is required'})
            }
        
        logger.info(f"Processing question: {user_question}")
        
        # Invoke Foundation Model (Claude 3 Haiku) via Bedrock
        response = bedrock.invoke_model(
            modelId='anthropic.claude-3-haiku-20240307-v1:0',
            body=json.dumps({
                'anthropic_version': 'bedrock-2023-05-31',
                'max_tokens': 1000,
                'messages': [
                    {
                        'role': 'user',
                        'content': user_question
                    }
                ]
            })
        )
        
        # Parse model response
        response_body = json.loads(response['body'].read())
        answer = response_body['content'][0]['text']
        
        logger.info("Successfully generated response")
        
        return {
            'statusCode': 200,
            'headers': {
                'Content-Type': 'application/json',
                'Access-Control-Allow-Origin': '*'
            },
            'body': json.dumps({
                'question': user_question,
                'answer': answer,
                'model_used': 'anthropic.claude-3-haiku-20240307-v1:0'
            })
        }
        
    except Exception as e:
        logger.error(f"Error processing request: {str(e)}")
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'error': 'Internal server error'})
        }
