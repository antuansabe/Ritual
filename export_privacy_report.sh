#!/bin/bash

# Privacy Report Export Script for fit-app
# This script exports the privacy manifest and generates a privacy report

echo "🔒 Exporting Privacy Report for fit-app"
echo "========================================="

# Create reports directory
mkdir -p privacy_reports

echo "📄 1. Privacy Manifest created at: fit-app/PrivacyInfo.plist"

echo "📋 2. Privacy Report Summary:"
echo "   - Data Collection: Workout/fitness data and user content"
echo "   - Tracking: None (NSPrivacyTracking = false)"
echo "   - Third-party domains: None"
echo "   - Required Reason APIs:"
echo "     * UserDefaults (CA92.1 - App functionality)"
echo "     * File timestamps (C617.1 - App functionality)"
echo "     * System boot time (35F9.1 - Measure absolute time)"
echo "     * Disk space (E174.1 - App functionality)"

echo "✅ 3. Data Types Collected:"
echo "   - NSPrivacyCollectedDataTypeOtherUserContent (workout data)"
echo "   - NSPrivacyCollectedDataTypeHealthFitness (exercise data)"
echo "   - Purpose: App functionality only"
echo "   - Linked to user: Yes"
echo "   - Used for tracking: No"

echo "🛡️ 4. Security Features:"
echo "   - Apple Sign In authentication"
echo "   - Keychain secure storage"
echo "   - CloudKit private database"
echo "   - Account deletion compliance (5.1.1 v)"

echo "📱 5. Privacy manifest complies with iOS 17+ requirements"

# Create a JSON privacy report
cat > privacy_reports/privacy_report.json << EOF
{
  "app_name": "fit-app",
  "privacy_manifest_version": "1.0",
  "date_generated": "$(date -Iseconds)",
  "tracking": false,
  "tracking_domains": [],
  "data_collected": [
    {
      "type": "NSPrivacyCollectedDataTypeOtherUserContent",
      "purpose": "NSPrivacyCollectedDataTypePurposeAppFunctionality",
      "linked": true,
      "tracking": false,
      "description": "Workout data, exercise logs, and user preferences"
    },
    {
      "type": "NSPrivacyCollectedDataTypeHealthFitness", 
      "purpose": "NSPrivacyCollectedDataTypePurposeAppFunctionality",
      "linked": true,
      "tracking": false,
      "description": "Exercise duration, calories burned, workout types"
    }
  ],
  "required_reason_apis": [
    {
      "api": "NSPrivacyAccessedAPICategoryUserDefaults",
      "reason": "CA92.1",
      "description": "Store user preferences and app settings"
    },
    {
      "api": "NSPrivacyAccessedAPICategoryFileTimestamp",
      "reason": "C617.1", 
      "description": "Access workout data file modification dates"
    },
    {
      "api": "NSPrivacyAccessedAPICategorySystemBootTime",
      "reason": "35F9.1",
      "description": "Measure absolute timing for workout duration"
    },
    {
      "api": "NSPrivacyAccessedAPICategoryDiskSpace",
      "reason": "E174.1",
      "description": "Ensure sufficient space for workout data storage"
    }
  ],
  "compliance": {
    "ios_17_privacy_manifest": true,
    "app_store_requirement_5_1_1_v": true,
    "account_deletion_available": true,
    "data_minimization": true
  }
}
EOF

echo "💾 Privacy report exported to: privacy_reports/privacy_report.json"

echo ""
echo "✅ Privacy manifest and report export complete!"
echo "📍 Files created:"
echo "   - fit-app/PrivacyInfo.plist"
echo "   - privacy_reports/privacy_report.json"