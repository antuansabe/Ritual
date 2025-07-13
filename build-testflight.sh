#!/bin/bash

# Build and Upload to TestFlight Script
# This script builds the app for Release and uploads to TestFlight

set -e  # Exit on any error

echo "🚀 Starting TestFlight Build Process"
echo "===================================="

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_NAME="fit-app"
SCHEME="fit-app"
CONFIGURATION="Release"
ARCHIVE_PATH="./build/${PROJECT_NAME}.xcarchive"
EXPORT_PATH="./build"

# Create build directory
mkdir -p build

echo -e "${BLUE}📱 Building for iOS Release...${NC}"

# Clean and build archive
xcodebuild clean \
    -project "${PROJECT_NAME}.xcodeproj" \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}"

echo -e "${BLUE}📦 Creating archive...${NC}"

# Create archive with automatic signing
xcodebuild archive \
    -project "${PROJECT_NAME}.xcodeproj" \
    -scheme "${SCHEME}" \
    -configuration "${CONFIGURATION}" \
    -archivePath "${ARCHIVE_PATH}" \
    CODE_SIGN_STYLE=Automatic \
    DEVELOPMENT_TEAM="WP54892UWX" \
    -allowProvisioningUpdates \
    -destination "generic/platform=iOS"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Archive created successfully${NC}"
else
    echo -e "${RED}❌ Archive failed${NC}"
    exit 1
fi

echo -e "${BLUE}📤 Exporting for App Store...${NC}"

# Export for App Store
xcodebuild -exportArchive \
    -archivePath "${ARCHIVE_PATH}" \
    -exportPath "${EXPORT_PATH}" \
    -exportOptionsPlist "ExportOptions.plist" \
    -allowProvisioningUpdates

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Export completed successfully${NC}"
    echo -e "${BLUE}📁 IPA file location: ${EXPORT_PATH}/${PROJECT_NAME}.ipa${NC}"
else
    echo -e "${RED}❌ Export failed${NC}"
    exit 1
fi

# Check if IPA exists
IPA_FILE="${EXPORT_PATH}/${PROJECT_NAME}.ipa"
if [ -f "$IPA_FILE" ]; then
    echo -e "${GREEN}✅ IPA file created: $IPA_FILE${NC}"
    
    # Get file size
    IPA_SIZE=$(du -h "$IPA_FILE" | cut -f1)
    echo -e "${BLUE}📊 IPA size: $IPA_SIZE${NC}"
    
    echo -e "${BLUE}🚀 Ready for TestFlight upload!${NC}"
    echo ""
    echo "To upload to TestFlight, you can:"
    echo "1. Use Xcode Organizer to upload the archive"
    echo "2. Use Transporter app to upload the IPA"
    echo "3. Use altool command line:"
    echo "   xcrun altool --upload-app -f \"$IPA_FILE\" -t ios -u [YOUR_APPLE_ID] -p [APP_SPECIFIC_PASSWORD]"
    
else
    echo -e "${RED}❌ IPA file not found${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}🎉 Build process completed successfully!${NC}"
echo -e "${BLUE}📋 Summary:${NC}"
echo "   • Archive: $ARCHIVE_PATH"
echo "   • IPA: $IPA_FILE"
echo "   • Size: $IPA_SIZE"
echo "   • Configuration: $CONFIGURATION"
echo "   • Build ready for TestFlight upload"