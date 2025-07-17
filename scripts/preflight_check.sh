#!/bin/zsh
set -e

echo "🔍 Lint & format"
swiftformat . && swiftlint

echo "🧪 Unit tests"
xcodebuild test -scheme fit-app \
    -destination 'platform=iOS Simulator,name=iPhone 15' \
    -quiet

echo "🛠️  Build Release"
xcodebuild build -scheme fit-app -configuration Release -quiet

echo "📱 Device matrix compile check"
for device in "iPhone SE (3rd generation)" "iPhone 11" "iPad (10th generation)"; do
  xcodebuild build -scheme fit-app \
    -destination "platform=iOS Simulator,name=${device}" -quiet
done

echo "✅ Preflight passed"