#!/usr/bin/env python3
"""
Script para generar HTML limpio desde archivos MD
PROMPT 4.6-Legal C - Estrategia Replace-Legacy-HTML
"""

import os

def convert_markdown_to_html(markdown_content):
    """Convert Markdown to HTML with proper styling"""
    html = markdown_content
    
    # Headers
    html = html.replace('# ', '<h1>').replace('\n', '</h1>\n', 1)  # First occurrence only
    
    # Handle remaining headers
    lines = html.split('\n')
    processed_lines = []
    for line in lines:
        if line.startswith('## '):
            line = line.replace('## ', '<h2>') + '</h2>'
        elif line.startswith('### '):
            line = line.replace('### ', '<h3>') + '</h3>'
        processed_lines.append(line)
    
    html = '\n'.join(processed_lines)
    
    # Bold text
    import re
    html = re.sub(r'\*\*([^*]+)\*\*', r'<strong>\1</strong>', html)
    
    # Lists
    html = re.sub(r'^- (.+)$', r'<li>\1</li>', html, flags=re.MULTILINE)
    html = re.sub(r'(<li>.*?</li>)', r'<ul>\1</ul>', html, flags=re.DOTALL)
    
    # Tables (basic support)
    lines = html.split('\n')
    in_table = False
    table_html = []
    processed_lines = []
    
    for line in lines:
        if '|' in line and not line.strip().startswith('<'):
            if not in_table:
                in_table = True
                table_html = ['<table>']
            
            # Skip separator line
            if '---|' in line:
                continue
                
            cells = [cell.strip() for cell in line.split('|')[1:-1]]  # Remove empty first/last
            if table_html == ['<table>']:  # First row is header
                table_html.append('<tr>' + ''.join(f'<th>{cell}</th>' for cell in cells) + '</tr>')
            else:
                table_html.append('<tr>' + ''.join(f'<td>{cell}</td>' for cell in cells) + '</tr>')
        else:
            if in_table:
                table_html.append('</table>')
                processed_lines.extend(table_html)
                table_html = []
                in_table = False
            if line.strip():  # Skip empty lines in table processing
                processed_lines.append(line)
    
    if in_table:  # Close table if still open
        table_html.append('</table>')
        processed_lines.extend(table_html)
    
    html = '\n'.join(processed_lines)
    
    # Paragraphs
    html = html.replace('\n\n', '</p>\n<p>')
    html = '<p>' + html + '</p>'
    
    # Clean up
    html = html.replace('<p></p>', '')
    html = html.replace('<p><h', '<h')
    html = html.replace('</h1></p>', '</h1>')
    html = html.replace('</h2></p>', '</h2>')
    html = html.replace('</h3></p>', '</h3>')
    html = html.replace('<p><ul>', '<ul>')
    html = html.replace('</ul></p>', '</ul>')
    html = html.replace('<p><table>', '<table>')
    html = html.replace('</table></p>', '</table>')
    
    # Add CSS styling
    styled_html = f"""<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Documento Legal - Ritmia</title>
    <style>
        body {{
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            line-height: 1.6;
            color: #333;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
        }}
        h1 {{
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
            margin-top: 30px;
        }}
        h2 {{
            color: #34495e;
            margin-top: 25px;
            margin-bottom: 15px;
        }}
        h3 {{
            color: #34495e;
            margin-top: 20px;
            margin-bottom: 10px;
        }}
        p {{
            margin-bottom: 15px;
            text-align: justify;
        }}
        ul {{
            margin-bottom: 15px;
            padding-left: 20px;
        }}
        li {{
            margin-bottom: 8px;
        }}
        strong {{
            color: #2c3e50;
        }}
        table {{
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }}
        th, td {{
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }}
        th {{
            background-color: #f8f9fa;
            font-weight: 600;
        }}
    </style>
</head>
<body>
    {html}
</body>
</html>"""
    
    return styled_html

def main():
    # Read Privacy Policy
    with open('Docs/PrivacyPolicy.md', 'r', encoding='utf-8') as f:
        privacy_md = f.read()
    
    # Read Terms of Service
    with open('Docs/TermsOfService.md', 'r', encoding='utf-8') as f:
        terms_md = f.read()
    
    # Convert to HTML
    privacy_html = convert_markdown_to_html(privacy_md)
    terms_html = convert_markdown_to_html(terms_md)
    
    # Write HTML files to Legal directory
    with open('fit-app/Legal/PrivacyPolicy.html', 'w', encoding='utf-8') as f:
        f.write(privacy_html)
    
    with open('fit-app/Legal/TermsOfService.html', 'w', encoding='utf-8') as f:
        f.write(terms_html)
    
    print("✅ HTML files generated successfully:")
    print("   - fit-app/Legal/PrivacyPolicy.html")
    print("   - fit-app/Legal/TermsOfService.html")
    print("✅ No more lorem ipsum!")

if __name__ == "__main__":
    main()