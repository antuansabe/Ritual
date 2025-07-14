#!/bin/bash

# export_privacy_report.sh
# Exports the iOS Privacy Report for the fit-app

set -e

echo "🔐 Exporting Privacy Report..."

# Create Docs directory if it doesn't exist
mkdir -p ./Docs

# Export privacy manifest
xcodebuild -exportPrivacyManifest \
           -scheme "fit-app" \
           -destination "generic/platform=iOS" \
           -exportPath "./Docs"

# Check if the export was successful
if [ -f "./Docs/PrivacyReport.pdf" ]; then
    # Get file size
    FILE_SIZE=$(ls -lh ./Docs/PrivacyReport.pdf | awk '{print $5}')
    echo "✅ Privacy Report exported successfully!"
    echo "📄 Location: ./Docs/PrivacyReport.pdf"
    echo "📏 Size: $FILE_SIZE"
    
    # Verify file size is reasonable (less than 5MB)
    FILE_SIZE_BYTES=$(stat -f%z "./Docs/PrivacyReport.pdf" 2>/dev/null || stat -c%s "./Docs/PrivacyReport.pdf" 2>/dev/null)
    if [ "$FILE_SIZE_BYTES" -gt 5242880 ]; then
        echo "⚠️  Warning: Privacy Report is larger than 5MB"
    fi
else
    echo "❌ Failed to export Privacy Report"
    exit 1
fi