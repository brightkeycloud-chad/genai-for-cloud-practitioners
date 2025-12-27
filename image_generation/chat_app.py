#!/usr/bin/env python3
"""
Chat application demonstrating Foundation Model -> LLM -> Application flow
"""
import requests
import json
import sys

class ChatApp:
    def __init__(self, api_endpoint):
        self.api_endpoint = api_endpoint
    
    def ask_question(self, question):
        """Send question to the Foundation Model via API"""
        try:
            response = requests.post(
                self.api_endpoint,
                json={'question': question},
                headers={'Content-Type': 'application/json'}
            )
            
            if response.status_code == 200:
                return response.json()
            else:
                return {'error': f'API error: {response.status_code}'}
                
        except Exception as e:
            return {'error': f'Connection error: {str(e)}'}
    
    def run(self):
        """Interactive chat loop"""
        print("🤖 Foundation Model Chat Demo")
        print("Type 'quit' to exit\n")
        
        while True:
            question = input("You: ").strip()
            
            if question.lower() in ['quit', 'exit']:
                print("Goodbye!")
                break
            
            if not question:
                continue
            
            print("🔄 Processing with Foundation Model...")
            result = self.ask_question(question)
            
            if 'error' in result:
                print(f"❌ Error: {result['error']}")
            else:
                print(f"🤖 Bot: {result['answer']}")
                print(f"📊 Model: {result['model_used']}\n")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python chat_app.py <api_endpoint>")
        sys.exit(1)
    
    app = ChatApp(sys.argv[1])
    app.run()
