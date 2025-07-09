#!/bin/bash

# Script to replace print/NSLog statements with Logger calls in Swift files

# Files to process (excluding already processed ones)
FILES=(
    "fit-app/AuthViewModel.swift"
    "fit-app/RegistroView.swift"
    "fit-app/PerfilView.swift"
    "fit-app/GoodbyeView.swift"
    "fit-app/UserProfileManager.swift"
    "fit-app/DataEncryptionHelper.swift"
    "fit-app/SecureAuthService.swift"
    "fit-app/WelcomeView.swift"
    "fit-app/InicioView.swift"
    "fit-app/AppleSignInButtonView.swift"
    "fit-app/UnifiedSyncMonitor.swift"
    "fit-app/TimerView.swift"
    "fit-app/OfflineManager.swift"
    "fit-app/EntrenamientoViewModel.swift"
    "fit-app/CloudKitSyncMonitor.swift"
    "fit-app/CloudKitConflictView.swift"
    "fit-app/CloudKitConflictMonitor.swift"
)

# Add os.log import to files that don't have it
add_import() {
    local file="$1"
    if ! grep -q "import os.log" "$file"; then
        # Find the last import line and add os.log import after it
        sed -i '' '/^import /a\
import os.log
' "$file"
    fi
}

# Replace print statements with Logger calls
replace_prints() {
    local file="$1"
    local category="$2"
    
    # Replace print statements with Logger calls wrapped in #if DEBUG
    sed -i '' 's/print(\(.*\))/#if DEBUG\
        Logger.'"$category"'.debug(\1)\
        #endif/g' "$file"
    
    # Fix any existing #if DEBUG blocks that might be duplicated
    sed -i '' '/^        #if DEBUG$/,/^        #endif$/{
        /^        #if DEBUG$/d
        /^        #endif$/d
        s/^        Logger\./        #if DEBUG\
        Logger./
        s/$/\
        #endif/
    }' "$file"
}

# Determine category based on filename
get_category() {
    local filename="$1"
    case "$filename" in
        *Auth* | *AppleSignIn*) echo "auth" ;;
        *CloudKit* | *Network*) echo "cloudkit" ;;
        *Storage* | *Encryption*) echo "storage" ;;
        *Validator*) echo "validation" ;;
        *Workout* | *Registro* | *Entrenamiento*) echo "workout" ;;
        *Perfil* | *Profile*) echo "profile" ;;
        *Timer* | *Welcome* | *Goodbye* | *Inicio*) echo "ui" ;;
        *) echo "general" ;;
    esac
}

# Process each file
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "Processing $file..."
        category=$(get_category "$file")
        add_import "$file"
        replace_prints "$file" "$category"
        echo "  -> Updated with Logger.$category"
    else
        echo "File not found: $file"
    fi
done

echo "All files processed!"