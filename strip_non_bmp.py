import pathlib, re, sys

def clean_text(text):
    # Sustituye emojis comunes por tags breves
    mapping = {
        "🔑": "[KEY]", "🗝": "[KEY]", "🔒": "[LOCK]", "🛡": "[SHIELD]",
        "✅": "[OK]", "❌": "[ERR]", "⚠": "[WARN]", "🔄": "[SYNC]"
    }
    for k,v in mapping.items():
        text = text.replace(k, v)
    
    # Sustituye cualquier código fuera BMP o surrogate suelto
    # Preserve essential whitespace characters
    return ''.join(
        ch if (0x09 <= ord(ch) <= 0x0D) or (0x20 <= ord(ch) < 0xD800) or (0xE000 <= ord(ch) <= 0xFFFD)
        else '[U+%04X]'%ord(ch)
        for ch in text
    )

root = pathlib.Path('.')
changed_files = []

for path in root.rglob('*.[sm]*[iftw]'):  # *.swift, *.plist, *.md etc.
    if path.is_file():
        try:
            txt = path.read_text(errors='ignore')
            new = clean_text(txt)
            if txt != new:
                path.write_text(new)
                changed_files.append(str(path))
                print(f"Cleaned: {path}")
        except Exception as e:
            print(f"Error processing {path}: {e}")

print(f"Unicode sanitation completed. Modified {len(changed_files)} files.")
if changed_files:
    print("Changed files:")
    for f in changed_files:
        print(f"  {f}")