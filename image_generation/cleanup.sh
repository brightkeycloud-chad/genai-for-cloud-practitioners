#!/bin/bash

echo "🧹 Cleaning up Foundation Model Demo..."

# Destroy Terraform resources (handles partial deployments)
if [ -f "terraform.tfstate" ] || [ -f ".terraform/terraform.tfstate" ]; then
    echo "🗑️ Destroying Terraform resources..."
    terraform destroy -auto-approve || echo "⚠️ Some resources may need manual cleanup"
fi

# Remove deployment artifacts
echo "📦 Removing artifacts..."
rm -f chat_function.zip
rm -rf venv/
rm -rf .terraform/
rm -f terraform.tfstate*
rm -f .terraform.lock.hcl

# Check for orphaned Lambda functions
echo "🔍 Checking for orphaned resources..."
aws lambda list-functions --query "Functions[?contains(FunctionName, 'llm-foundation-demo')].FunctionName" --output text 2>/dev/null | while read func; do
    if [ ! -z "$func" ]; then
        echo "⚠️ Found orphaned Lambda: $func"
        aws lambda delete-function --function-name "$func" 2>/dev/null || true
    fi
done

# Check for orphaned API Gateways
aws apigateway get-rest-apis --query "items[?contains(name, 'llm-foundation-demo')].id" --output text 2>/dev/null | while read api; do
    if [ ! -z "$api" ]; then
        echo "⚠️ Found orphaned API Gateway: $api"
        aws apigateway delete-rest-api --rest-api-id "$api" 2>/dev/null || true
    fi
done

echo "✅ Cleanup complete!"
