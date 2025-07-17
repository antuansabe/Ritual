#!/bin/zsh
set -e
echo "🔧 Lint"
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

echo "🧪 Tests"; xcodebuild test -scheme fit-app -quiet
echo "📱 Build matrix"
for d in "iPhone 16" "iPhone SE (3rd generation)" "iPad (10th generation)"; do
  xcodebuild build -scheme fit-app -destination "platform=iOS Simulator,name=$d" -quiet
done
echo "✅ All green"