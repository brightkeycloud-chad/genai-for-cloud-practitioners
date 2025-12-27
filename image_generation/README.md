# Foundation Model to LLM Demo

This application demonstrates the visualization flow: Foundation Model → Fine-tuning → Specific LLM → Your Application.

## Architecture

- **Foundation Model**: AWS Bedrock Claude 3 Haiku (pre-trained)
- **LLM**: Accessed via Bedrock API (fine-tuned for chat)
- **Application**: Python chat interface + Lambda API

## Quick Deploy

```bash
./deploy.sh
```

## Manual Steps

1. **Setup Environment**:
   ```bash
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   ```

2. **Deploy Infrastructure**:
   ```bash
   terraform init
   terraform apply
   ```

3. **Test Application**:
   ```bash
   python chat_app.py $(terraform output -raw api_endpoint)
   ```

## Cleanup

```bash
terraform destroy -auto-approve
rm -rf venv chat_function.zip
```

## Cost Estimate

- Lambda: ~$0.20 per 1M requests
- API Gateway: ~$3.50 per 1M requests  
- Bedrock Claude 3 Haiku: ~$0.25 per 1M input tokens

Total: ~$4 per 1M chat interactions
