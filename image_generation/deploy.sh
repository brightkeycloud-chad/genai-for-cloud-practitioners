#!/bin/bash
set -e

echo "🚀 Deploying Foundation Model Demo..."

# Create Python virtual environment
if [ ! -d "venv" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies
echo "📥 Installing dependencies..."
pip install -r requirements.txt

# Create Lambda deployment package
echo "📦 Creating Lambda package..."
cd venv/lib/python*/site-packages
zip -r ../../../../chat_function.zip .
cd ../../../../
zip -g chat_function.zip lambda_function.py

# Format Terraform code
echo "🔧 Formatting Terraform..."
terraform fmt

# Initialize and deploy infrastructure
echo "🏗️ Deploying infrastructure..."
terraform init
terraform plan
terraform apply -auto-approve

# Get API endpoint
API_ENDPOINT=$(terraform output -raw api_endpoint)
echo "✅ Deployment complete!"
echo "🌐 API Endpoint: $API_ENDPOINT"
echo ""
echo "🧪 Test with: python chat_app.py $API_ENDPOINT"
