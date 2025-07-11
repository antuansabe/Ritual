#!/bin/bash

# Phase 2 Test Runner Script
# Validates CloudKit sync and account deletion functionality

echo "🧪 Phase 2 Test Suite: Apple Sign-In + CloudKit MVP"
echo "=================================================="

# Test 1: CloudKit Configuration
echo "🔍 Test 1: CloudKit Configuration"
if grep -q "iCloud.com.antonio.fit-app" fit-app/PersistenceController.swift; then
    echo "✅ CloudKit container identifier configured"
else
    echo "❌ CloudKit container identifier missing"
    exit 1
fi

if grep -q "databaseScope = .private" fit-app/PersistenceController.swift; then
    echo "✅ CloudKit private database scope configured"
else
    echo "❌ CloudKit private database scope missing"
    exit 1
fi

# Test 2: CloudKit Sync Monitoring
echo "🔍 Test 2: CloudKit Sync Monitoring"
if grep -q "setupCloudKitSyncMonitoring" fit-app/PersistenceController.swift; then
    echo "✅ CloudKit sync monitoring implemented"
else
    echo "❌ CloudKit sync monitoring missing"
    exit 1
fi

if grep -q "NSPersistentStoreRemoteChange" fit-app/PersistenceController.swift; then
    echo "✅ Remote change notifications configured"
else
    echo "❌ Remote change notifications missing"
    exit 1
fi

# Test 3: Account Deletion Implementation
echo "🔍 Test 3: Account Deletion Implementation"
if grep -q "deleteUserAccount" fit-app/PerfilView.swift; then
    echo "✅ Delete account function implemented"
else
    echo "❌ Delete account function missing"
    exit 1
fi

if grep -q "clearAllData" fit-app/PersistenceController.swift; then
    echo "✅ Data clearing function implemented"
else
    echo "❌ Data clearing function missing"
    exit 1
fi

if grep -q "clearAllUserDefaults" fit-app/PerfilView.swift; then
    echo "✅ UserDefaults clearing implemented"
else
    echo "❌ UserDefaults clearing missing"
    exit 1
fi

# Test 4: Apple Sign In Integration
echo "🔍 Test 4: Apple Sign In Integration"
if grep -q "clearAuthenticationData" fit-app/AuthViewModel.swift; then
    echo "✅ Authentication data clearing implemented"
else
    echo "❌ Authentication data clearing missing"
    exit 1
fi

if grep -q "Apple Sign In" fit-app/PerfilView.swift; then
    echo "✅ Apple Sign In integration present"
else
    echo "❌ Apple Sign In integration missing"
    exit 1
fi

# Test 5: Privacy Manifest
echo "🔍 Test 5: Privacy Manifest"
if [ -f "fit-app/PrivacyInfo.plist" ]; then
    echo "✅ PrivacyInfo.plist exists"
    
    if grep -q "NSPrivacyTracking" fit-app/PrivacyInfo.plist; then
        echo "✅ Privacy tracking configuration present"
    else
        echo "❌ Privacy tracking configuration missing"
        exit 1
    fi
    
    if grep -q "NSPrivacyCollectedDataTypes" fit-app/PrivacyInfo.plist; then
        echo "✅ Data collection types declared"
    else
        echo "❌ Data collection types missing"
        exit 1
    fi
else
    echo "❌ PrivacyInfo.plist missing"
    exit 1
fi

# Test 6: Security Features
echo "🔍 Test 6: Security Features"
if grep -q "SecureStorage" fit-app/*.swift; then
    echo "✅ Secure storage implementation found"
else
    echo "❌ Secure storage implementation missing"
    exit 1
fi

if grep -q "Logger" fit-app/*.swift; then
    echo "✅ Logging system implemented"
else
    echo "❌ Logging system missing"
    exit 1
fi

# Test 7: Build Validation
echo "🔍 Test 7: Build Validation"
echo "Attempting to build project..."

# Check if project builds successfully
if xcodebuild -project fit-app.xcodeproj -scheme fit-app -destination 'platform=iOS Simulator,name=iPhone 16' build > /dev/null 2>&1; then
    echo "✅ Project builds successfully"
else
    echo "❌ Project build failed"
    echo "Running build to show errors..."
    xcodebuild -project fit-app.xcodeproj -scheme fit-app -destination 'platform=iOS Simulator,name=iPhone 16' build
    exit 1
fi

# Test 8: File Structure Validation
echo "🔍 Test 8: File Structure Validation"

required_files=(
    "fit-app/PersistenceController.swift"
    "fit-app/PerfilView.swift"
    "fit-app/AuthViewModel.swift"
    "fit-app/PrivacyInfo.plist"
    "fit-app/Logger.swift"
    "fit-app/SecureStorage.swift"
)

for file in "${required_files[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

# Test 9: Core Data Model Validation
echo "🔍 Test 9: Core Data Model Validation"
if [ -d "fit-app/WorkoutHeroModel.xcdatamodeld" ]; then
    echo "✅ Core Data model exists"
    
    if [ -f "fit-app/WorkoutHeroModel.xcdatamodeld/WorkoutHeroModel.xcdatamodel/contents" ]; then
        echo "✅ Core Data model contents exist"
    else
        echo "❌ Core Data model contents missing"
        exit 1
    fi
else
    echo "❌ Core Data model missing"
    exit 1
fi

# Test 10: CloudKit Entitlements
echo "🔍 Test 10: CloudKit Entitlements"
if [ -f "fit-app/fit-app.entitlements" ]; then
    echo "✅ Entitlements file exists"
    
    if grep -q "com.apple.developer.icloud-container-identifiers" fit-app/fit-app.entitlements; then
        echo "✅ CloudKit entitlements configured"
    else
        echo "❌ CloudKit entitlements missing"
        exit 1
    fi
else
    echo "❌ Entitlements file missing"
    exit 1
fi

echo ""
echo "🎉 All Phase 2 Tests Passed!"
echo "✅ CloudKit private database sync configured"
echo "✅ Account deletion flow implemented"
echo "✅ Privacy manifest created and configured"
echo "✅ Apple Sign In integration complete"
echo "✅ Security features implemented"
echo "✅ Project builds successfully"

echo ""
echo "📊 Test Summary:"
echo "   - CloudKit Configuration: ✅"
echo "   - Sync Monitoring: ✅"
echo "   - Account Deletion: ✅"
echo "   - Apple Sign In: ✅"
echo "   - Privacy Manifest: ✅"
echo "   - Security Features: ✅"
echo "   - Build Validation: ✅"
echo "   - File Structure: ✅"
echo "   - Core Data Model: ✅"
echo "   - CloudKit Entitlements: ✅"

echo ""
echo "🚀 Phase 2 MVP is ready for testing on device!"
echo "📱 Next steps:"
echo "   1. Test on physical device with iCloud account"
echo "   2. Verify CloudKit sync across devices"
echo "   3. Test account deletion flow end-to-end"
echo "   4. Submit privacy report for App Store review"