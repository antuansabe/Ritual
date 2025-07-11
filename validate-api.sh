#!/bin/bash

# API Contract Validation Script
# Validates the OpenAPI specification without external dependencies

set -e

API_SPEC="backend/openapi.yaml"

echo "🔍 Validating OpenAPI specification..."

# Check if file exists
if [ ! -f "$API_SPEC" ]; then
    echo "❌ OpenAPI specification file not found at: $API_SPEC"
    exit 1
fi

echo "✅ OpenAPI specification file found"

# Basic checks using grep and standard tools
echo "🔍 Checking required fields..."

# Check OpenAPI version
if grep -q "^openapi: 3\." "$API_SPEC"; then
    echo "✅ Valid OpenAPI 3.x version found"
else
    echo "❌ OpenAPI 3.x version not found"
    exit 1
fi

# Check for required sections
REQUIRED_SECTIONS=("info:" "paths:" "components:")
for section in "${REQUIRED_SECTIONS[@]}"; do
    if grep -q "^$section" "$API_SPEC"; then
        echo "✅ Required section found: $section"
    else
        echo "❌ Missing required section: $section"
        exit 1
    fi
done

# Check for required authentication endpoints
REQUIRED_ENDPOINTS=("/auth/login:" "/auth/refresh:" "/auth/logout:" "/users/")
for endpoint in "${REQUIRED_ENDPOINTS[@]}"; do
    if grep -q "$endpoint" "$API_SPEC"; then
        echo "✅ Required endpoint found: $endpoint"
    else
        echo "❌ Missing required endpoint: $endpoint"
        exit 1
    fi
done

# Check for security schemes
if grep -q "BearerAuth:" "$API_SPEC"; then
    echo "✅ BearerAuth security scheme found"
else
    echo "❌ BearerAuth security scheme not found"
    exit 1
fi

# Check for required info fields
if grep -q "title:" "$API_SPEC" && grep -q "version:" "$API_SPEC"; then
    echo "✅ Required info fields found"
else
    echo "❌ Missing required info fields (title or version)"
    exit 1
fi

# Check for servers section
if grep -q "servers:" "$API_SPEC"; then
    echo "✅ Servers section found"
else
    echo "⚠️  Servers section not found (optional but recommended)"
fi

# Validate basic YAML structure by checking indentation
echo "🔍 Checking YAML structure..."

# Check for consistent indentation (basic check)
if awk '
/^[^ ]/ { root++ } 
/^  [^ ]/ { level2++ } 
/^    [^ ]/ { level4++ }
END { 
    if (root > 0 && level2 > 0) 
        print "✅ YAML structure appears valid" 
    else { 
        print "❌ YAML structure appears invalid"
        exit 1
    }
}' "$API_SPEC"; then
    echo "Structure validation passed"
else
    echo "Structure validation failed"
    exit 1
fi

# File size check (should not be empty or too small)
FILE_SIZE=$(wc -c < "$API_SPEC")
if [ "$FILE_SIZE" -gt 1000 ]; then
    echo "✅ API specification has reasonable size ($FILE_SIZE bytes)"
else
    echo "❌ API specification seems too small ($FILE_SIZE bytes)"
    exit 1
fi

# Check for common OpenAPI patterns
echo "🔍 Checking OpenAPI patterns..."

# Check for HTTP methods
HTTP_METHODS=("post:" "get:" "put:" "delete:")
METHOD_FOUND=false
for method in "${HTTP_METHODS[@]}"; do
    if grep -q "$method" "$API_SPEC"; then
        METHOD_FOUND=true
        break
    fi
done

if [ "$METHOD_FOUND" = true ]; then
    echo "✅ HTTP methods found in specification"
else
    echo "❌ No HTTP methods found in specification"
    exit 1
fi

# Check for response codes
if grep -q "'200':" "$API_SPEC" || grep -q '"200":' "$API_SPEC"; then
    echo "✅ Success response codes found"
else
    echo "❌ No success response codes found"
    exit 1
fi

# Check for error responses
if grep -q "'400':" "$API_SPEC" || grep -q '"400":' "$API_SPEC" || \
   grep -q "'401':" "$API_SPEC" || grep -q '"401":' "$API_SPEC"; then
    echo "✅ Error response codes found"
else
    echo "❌ No error response codes found"
    exit 1
fi

echo ""
echo "🎉 OpenAPI specification validation completed successfully!"
echo ""
echo "Summary:"
echo "- ✅ File exists and has valid size"
echo "- ✅ OpenAPI 3.x format"
echo "- ✅ Required sections present"
echo "- ✅ Authentication endpoints defined"
echo "- ✅ Security schemes configured"
echo "- ✅ HTTP methods and response codes present"
echo ""
echo "The API contract is ready for implementation!"