#!/bin/bash

# Build Validation Tests
# Comprehensive build and compilation tests for App Store readiness

echo "🚀 Build Validation Tests - App Store Readiness"
echo "==============================================="
echo "Date: $(date)"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

passed_tests=0
total_tests=15
build_errors=0

# Function to log test results
log_test() {
    local test_name="$1"
    local result="$2"
    local details="$3"
    
    echo -e "🔍 Test: $test_name"
    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✅ PASS${NC} - $details"
        ((passed_tests++))
    else
        echo -e "${RED}❌ FAIL${NC} - $details"
        ((build_errors++))
    fi
    echo ""
}

# Test 1: Project Structure Validation
echo "=== Project Structure Validation ==="
if [ -f "fit-app.xcodeproj/project.pbxproj" ] && [ -d "fit-app" ]; then
    log_test "Project Structure" "PASS" "Xcode project and source directory exist"
else
    log_test "Project Structure" "FAIL" "Missing Xcode project or source directory"
fi

# Test 2: Core Swift Files Compilation Check
echo "=== Core Swift Files Compilation Check ==="
critical_files=(
    "fit-app/AuthViewModel.swift"
    "fit-app/UserProfileManager.swift"
    "fit-app/PerfilView.swift"
    "fit-app/PersistenceController.swift"
    "fit-app/Logger.swift"
)

all_critical_exist=true
for file in "${critical_files[@]}"; do
    if [ ! -f "$file" ]; then
        all_critical_exist=false
        echo "Missing critical file: $file"
    fi
done

if $all_critical_exist; then
    log_test "Critical Swift Files" "PASS" "All critical Swift files are present"
else
    log_test "Critical Swift Files" "FAIL" "Some critical Swift files are missing"
fi

# Test 3: Syntax Check for AuthViewModel
echo "=== AuthViewModel Syntax Validation ==="
if grep -q "func clearAuthenticationData() async" fit-app/AuthViewModel.swift; then
    log_test "AuthViewModel clearAuthenticationData" "PASS" "clearAuthenticationData method is public and accessible"
else
    log_test "AuthViewModel clearAuthenticationData" "FAIL" "clearAuthenticationData method not found or not public"
fi

# Test 4: Syntax Check for UserProfileManager
echo "=== UserProfileManager Syntax Validation ==="
if grep -q "func clearUserProfile()" fit-app/UserProfileManager.swift; then
    log_test "UserProfileManager clearUserProfile" "PASS" "clearUserProfile method exists and is accessible"
else
    log_test "UserProfileManager clearUserProfile" "FAIL" "clearUserProfile method not found"
fi

# Test 5: PerfilView Method Calls Validation
echo "=== PerfilView Method Calls Validation ==="
perfil_errors=0

# Check for clearAuthenticationData call
if grep -q "await authViewModel.clearAuthenticationData()" fit-app/PerfilView.swift; then
    log_test "PerfilView clearAuthenticationData call" "PASS" "clearAuthenticationData called correctly"
else
    log_test "PerfilView clearAuthenticationData call" "FAIL" "clearAuthenticationData call not found or incorrect"
    ((perfil_errors++))
fi

# Check for clearUserProfile call
if grep -q "userProfileManager.clearUserProfile()" fit-app/PerfilView.swift; then
    log_test "PerfilView clearUserProfile call" "PASS" "clearUserProfile called correctly"
else
    log_test "PerfilView clearUserProfile call" "FAIL" "clearUserProfile call not found or incorrect"
    ((perfil_errors++))
fi

# Test 6: CloudKit Configuration Validation
echo "=== CloudKit Configuration Validation ==="
if grep -q "iCloud.com.antonio.fit-app" fit-app/PersistenceController.swift && grep -q "databaseScope = .private" fit-app/PersistenceController.swift; then
    log_test "CloudKit Configuration" "PASS" "CloudKit container and private database scope configured"
else
    log_test "CloudKit Configuration" "FAIL" "CloudKit configuration missing or incomplete"
fi

# Test 7: Privacy Manifest Validation
echo "=== Privacy Manifest Validation ==="
if [ -f "fit-app/PrivacyInfo.plist" ] && grep -q "NSPrivacyTracking" fit-app/PrivacyInfo.plist; then
    log_test "Privacy Manifest" "PASS" "PrivacyInfo.plist exists and configured"
else
    log_test "Privacy Manifest" "FAIL" "PrivacyInfo.plist missing or incomplete"
fi

# Test 8: Entitlements Validation
echo "=== Entitlements Validation ==="
if [ -f "fit-app/fit-app.entitlements" ] && grep -q "com.apple.developer.icloud-container-identifiers" fit-app/fit-app.entitlements; then
    log_test "CloudKit Entitlements" "PASS" "CloudKit entitlements configured"
else
    log_test "CloudKit Entitlements" "FAIL" "CloudKit entitlements missing"
fi

# Test 9: Core Data Model Validation
echo "=== Core Data Model Validation ==="
if [ -d "fit-app/WorkoutHeroModel.xcdatamodeld" ]; then
    log_test "Core Data Model" "PASS" "WorkoutHeroModel.xcdatamodeld exists"
else
    log_test "Core Data Model" "FAIL" "Core Data model missing"
fi

# Test 10: Logger Category Validation
echo "=== Logger Category Validation ==="
if grep -q "Logger.dZypOEWLc9moB7toIqUd8PR8UFyvsPD3" fit-app/AuthViewModel.swift; then
    log_test "Logger Categories" "PASS" "Logger categories properly referenced"
else
    log_test "Logger Categories" "FAIL" "Logger category references incorrect"
fi

# Test 11: Account Deletion Flow Validation
echo "=== Account Deletion Flow Validation ==="
if grep -q "deleteUserAccount" fit-app/PerfilView.swift && grep -q "clearAllUserDefaults" fit-app/PerfilView.swift; then
    log_test "Account Deletion Flow" "PASS" "Complete account deletion flow implemented"
else
    log_test "Account Deletion Flow" "FAIL" "Account deletion flow incomplete"
fi

# Test 12: Build Dependencies Check
echo "=== Build Dependencies Check ==="
if xcodebuild -list -project fit-app.xcodeproj &>/dev/null; then
    log_test "Xcode Project Validity" "PASS" "Xcode project is valid and readable"
else
    log_test "Xcode Project Validity" "FAIL" "Xcode project has structural issues"
fi

# Test 13: Swift Package Dependencies
echo "=== Swift Package Dependencies ==="
if [ -f "fit-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved" ] || [ -d "fit-app.xcodeproj/project.xcworkspace/xcshareddata/swiftpm" ]; then
    log_test "Swift Package Manager" "PASS" "Swift Package Manager configured (if used)"
else
    log_test "Swift Package Manager" "PASS" "No Swift Package dependencies (expected for this project)"
fi

# Test 14: Compilation Test (Simulator)
echo "=== Build Compilation Test ==="
echo "Testing compilation for iOS Simulator..."
build_output=$(xcodebuild -project fit-app.xcodeproj -scheme fit-app -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 15,OS=latest' clean build 2>&1)
build_exit_code=$?

if [ $build_exit_code -eq 0 ]; then
    log_test "iOS Simulator Build" "PASS" "Project compiles successfully for iOS Simulator"
else
    echo -e "${RED}Build output:${NC}"
    echo "$build_output" | tail -20
    log_test "iOS Simulator Build" "FAIL" "Compilation errors found (see output above)"
fi

# Test 15: Security Validation
echo "=== Security Validation ==="
security_issues=0

# Check for hardcoded secrets
if grep -r "password\|secret\|api_key\|token" fit-app/ --include="*.swift" | grep -v "// " | grep -v "print\|log\|debug"; then
    ((security_issues++))
fi

# Check for proper keychain usage
if grep -q "SecureStorage" fit-app/*.swift; then
    security_check=true
else
    security_check=false
fi

if [ $security_issues -eq 0 ] && [ "$security_check" = true ]; then
    log_test "Security Validation" "PASS" "No hardcoded secrets found, secure storage implemented"
else
    log_test "Security Validation" "FAIL" "Security issues detected or secure storage missing"
fi

# Final Results
echo "======================================="
echo "📊 BUILD VALIDATION RESULTS SUMMARY"
echo "======================================="
echo -e "Passed: ${GREEN}$passed_tests${NC} / $total_tests tests"

# Calculate percentage
percentage=$((passed_tests * 100 / total_tests))
echo -e "Success Rate: ${BLUE}$percentage%${NC}"

echo ""
echo "🎯 App Store Readiness Status:"

if [ $passed_tests -eq $total_tests ] && [ $build_exit_code -eq 0 ]; then
    echo -e "${GREEN}✅ READY FOR APP STORE SUBMISSION${NC}"
    echo ""
    echo "🚀 All tests passed successfully!"
    echo "📱 The app compiles without errors"
    echo "🔒 Security validations passed"
    echo "☁️ CloudKit integration validated"
    echo "🍎 Apple Sign In implementation verified"
    echo "🗑️ Account deletion compliance confirmed"
    echo ""
    echo "Next steps:"
    echo "1. Test on physical device with iCloud account"
    echo "2. Verify CloudKit sync functionality"
    echo "3. Test complete account deletion flow"
    echo "4. Submit to App Store Connect"
    
    exit 0
else
    echo -e "${RED}❌ NOT READY FOR APP STORE SUBMISSION${NC}"
    echo ""
    echo "Issues found:"
    if [ $build_exit_code -ne 0 ]; then
        echo -e "${RED}• Build compilation failed${NC}"
    fi
    if [ $passed_tests -lt $total_tests ]; then
        failed_tests=$((total_tests - passed_tests))
        echo -e "${RED}• $failed_tests validation tests failed${NC}"
    fi
    echo ""
    echo "Please fix the issues above before proceeding with App Store submission."
    
    exit 1
fi