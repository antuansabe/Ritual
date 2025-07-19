#!/bin/bash

echo "🧪 Quick QA Test - Checking build and basic functionality"
echo "========================================================"
echo ""

# Create report directory
REPORT_DIR="Docs/QA/2025-$(date +%m-%d)"
mkdir -p "$REPORT_DIR"

# Initialize report
cat > "$REPORT_DIR/QA_Final_Report.md" << EOF
# QA Final Report

Date: $(date)
Device: iOS Simulator
Test Type: Quick Validation

## Test Results

| Scenario | Result | Details |
|----------|--------|---------|
EOF

# Test A: Build Success
echo "🔨 Test A: Build Success..."
if xcodebuild build -scheme fit-app -destination 'platform=iOS Simulator,name=iPhone 15' -quiet 2>&1; then
    echo "| A. Build Success | ✅ PASS | App builds without errors |" >> "$REPORT_DIR/QA_Final_Report.md"
    BUILD_PASS=true
else
    echo "| A. Build Success | ❌ FAIL | Build errors detected |" >> "$REPORT_DIR/QA_Final_Report.md"
    BUILD_PASS=false
fi

# Test B: Launch Test
echo "🚀 Test B: Launch Test..."
# Simple launch test using xcrun simctl
if $BUILD_PASS; then
    echo "| B. Launch Test | ⏭️ SKIP | Requires full UI test suite |" >> "$REPORT_DIR/QA_Final_Report.md"
else
    echo "| B. Launch Test | ❌ FAIL | Build failed |" >> "$REPORT_DIR/QA_Final_Report.md"
fi

# Memory check placeholder
echo "| C. Memory Check | ⏭️ SKIP | Requires Instruments |" >> "$REPORT_DIR/QA_Final_Report.md"
echo "| D. CPU Check | ⏭️ SKIP | Requires Instruments |" >> "$REPORT_DIR/QA_Final_Report.md"
echo "| E. Navigation | ⏭️ SKIP | Requires UI tests |" >> "$REPORT_DIR/QA_Final_Report.md"

# Summary
echo "" >> "$REPORT_DIR/QA_Final_Report.md"
echo "## Summary" >> "$REPORT_DIR/QA_Final_Report.md"
echo "" >> "$REPORT_DIR/QA_Final_Report.md"

if $BUILD_PASS; then
    echo "🏁 QA FINAL RESULT: PARTIAL PASS (Build successful, full tests pending)" >> "$REPORT_DIR/QA_Final_Report.md"
    FINAL_RESULT="PARTIAL PASS"
else
    echo "🏁 QA FINAL RESULT: FAIL (Build errors)" >> "$REPORT_DIR/QA_Final_Report.md"
    FINAL_RESULT="FAIL"
fi

echo "" >> "$REPORT_DIR/QA_Final_Report.md"
echo "Note: This is a quick validation test. Run full UI test suite for complete QA." >> "$REPORT_DIR/QA_Final_Report.md"

# Display report
echo ""
echo "📊 Report Summary:"
echo "=================="
cat "$REPORT_DIR/QA_Final_Report.md"

echo ""
echo "🏁 QA FINAL RESULT: $FINAL_RESULT"
echo "📁 Full report saved to: $REPORT_DIR/QA_Final_Report.md"