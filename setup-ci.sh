#!/bin/bash

# CI/CD Setup Script for FitApp
# Sets up the development environment with required tools

set -e

echo "🚀 Setting up FitApp CI/CD environment..."

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check and install Node.js dependencies
if command_exists npm; then
    echo "✅ npm found, installing API validation tools..."
    npm install
    
    # Install global tools if needed
    if ! command_exists redoc-cli; then
        echo "📦 Installing redoc-cli globally..."
        npm install -g redoc-cli
    fi
    
    if ! command_exists openapi-lint; then
        echo "📦 Installing openapi-lint-cli globally..."
        npm install -g openapi-lint-cli || echo "⚠️  openapi-lint-cli installation failed, continuing..."
    fi
else
    echo "⚠️  npm not found. Please install Node.js first."
fi

# Check and install Ruby dependencies (Fastlane)
if command_exists gem; then
    echo "✅ gem found, checking for Fastlane..."
    
    if ! command_exists fastlane; then
        echo "📦 Installing Fastlane..."
        gem install fastlane
    else
        echo "✅ Fastlane already installed"
    fi
else
    echo "⚠️  gem not found. Please install Ruby first."
fi

# Make scripts executable
chmod +x validate-api.sh
chmod +x security_scan.sh 2>/dev/null || echo "ℹ️  security_scan.sh not found"

# Test API validation
echo "🧪 Testing API validation..."
./validate-api.sh

# Test Fastlane if available
if command_exists fastlane; then
    echo "🧪 Testing Fastlane API lint..."
    cd fastlane
    fastlane ios api_lint
    cd ..
else
    echo "⚠️  Skipping Fastlane test (not installed)"
fi

echo ""
echo "🎉 CI/CD setup completed!"
echo ""
echo "Available commands:"
echo "  ./validate-api.sh                 - Validate OpenAPI specification"
echo "  fastlane ios api_lint            - Run API validation via Fastlane"
echo "  fastlane ios beta                - Build and deploy beta"
echo "  fastlane ios release             - Build and deploy release"
echo "  npm run api-lint                 - Generate API documentation"
echo ""
echo "For GitHub Actions, the workflow will run automatically on:"
echo "  - Push to main/develop branches"
echo "  - Pull requests to main"
echo "  - Changes to backend/openapi.yaml"