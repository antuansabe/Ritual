#!/bin/zsh
set -e

echo "🔍 Lint & format"
if command -v swiftformat >/dev/null 2>&1; then
    swiftformat .
else
    echo "⚠️  swiftformat not found, skipping formatting"
fi

if command -v swiftlint >/dev/null 2>&1; then
    swiftlint
else
    echo "⚠️  swiftlint not found, skipping linting"
fi

echo "🧪 Unit tests"
xcodebuild test -scheme fit-app \
    -destination 'platform=iOS Simulator,name=iPhone 16' \
    -quiet

echo "🛠️  Build Release"
xcodebuild build -scheme fit-app -configuration Release -destination 'platform=iOS Simulator,name=iPhone 16' -quiet

echo "📱 Device matrix compile check"
for device in "iPhone SE (3rd generation)" "iPhone 16" "iPad (10th generation)"; do
  echo "Building for ${device}..."
  xcodebuild build -scheme fit-app -configuration Debug \
    -destination "platform=iOS Simulator,name=${device}" -quiet
done

echo "✅ Preflight passed"