#!/usr/bin/env python3
"""
Script to restore Unicode placeholders [U+XXXXX] back to actual emojis in Swift files.
This fixes the display issue where Unicode characters show as text instead of emojis.
"""

import pathlib, re, sys

def restore_unicode(text):
    """Convert [U+XXXXX] format back to actual Unicode characters"""
    def unicode_replacer(match):
        unicode_str = match.group(1)
        try:
            # Convert hex string to int, then to Unicode character
            unicode_int = int(unicode_str, 16)
            return chr(unicode_int)
        except (ValueError, OverflowError):
            # If conversion fails, return original
            return match.group(0)
    
    # Pattern to match [U+XXXXX] format
    pattern = r'\[U\+([0-9A-Fa-f]{4,5})\]'
    return re.sub(pattern, unicode_replacer, text)

root = pathlib.Path('.')
changed_files = []

for path in root.rglob('*.swift'):  # Only process Swift files
    if path.is_file():
        try:
            txt = path.read_text(encoding='utf-8', errors='ignore')
            new = restore_unicode(txt)
            if txt != new:
                path.write_text(new, encoding='utf-8')
                changed_files.append(str(path))
                
                # Count how many replacements were made
                matches = re.findall(r'\[U\+([0-9A-Fa-f]{4,5})\]', txt)
                print(f"✅ {path}: Restored {len(matches)} Unicode placeholders to emojis")
        except Exception as e:
            print(f"❌ Error processing {path}: {e}")

print(f"\n📊 Unicode restoration completed. Modified {len(changed_files)} files.")
if changed_files:
    print("Changed files:")
    for f in changed_files:
        print(f"  {f}")