#!/bin/bash

# Translation Validation Script
# Validates ARB files for consistency and completeness

echo "🔍 Translation Validation Tool"
echo "=============================="

# Navigate to project root
cd "$(dirname "$0")/../.."

echo "📁 Validating translations in: $(pwd)/lib/l10n/"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if ARB files exist
if [ ! -d "lib/l10n" ]; then
    echo -e "${RED}❌ lib/l10n directory not found!${NC}"
    exit 1
fi

# Find all ARB files
ARB_FILES=(lib/l10n/*.arb)
if [ ${#ARB_FILES[@]} -eq 0 ]; then
    echo -e "${RED}❌ No ARB files found in lib/l10n/${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Found ARB files:${NC}"
for file in "${ARB_FILES[@]}"; do
    echo "  - $(basename "$file")"
done
echo ""

# Template file (base English)
TEMPLATE_FILE="lib/l10n/intl_en.arb"

if [ ! -f "$TEMPLATE_FILE" ]; then
    echo -e "${RED}❌ Template file not found: $TEMPLATE_FILE${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Using template: $(basename "$TEMPLATE_FILE")${NC}"
echo ""

# Extract keys from template (only actual translation keys, not metadata)
echo "🔑 Extracting translation keys from template..."
TEMPLATE_KEYS=$(python3 -c "
import json
import sys
with open('$TEMPLATE_FILE', 'r') as f:
    data = json.load(f)
keys = [k for k in data.keys() if not k.startswith('@')]
for key in sorted(keys):
    print(key)
" 2>/dev/null)
TEMPLATE_KEY_COUNT=$(echo "$TEMPLATE_KEYS" | wc -l)

echo -e "${BLUE}📊 Template contains $TEMPLATE_KEY_COUNT translation keys${NC}"
echo ""

# Validation results
VALIDATION_PASSED=true

# Check each ARB file
for arb_file in "${ARB_FILES[@]}"; do
    if [ "$arb_file" == "$TEMPLATE_FILE" ]; then
        continue # Skip template file
    fi
    
    filename=$(basename "$arb_file")
    echo -e "${YELLOW}🔍 Validating: $filename${NC}"
    
    # Check if file is valid JSON
    if ! python3 -m json.tool "$arb_file" > /dev/null 2>&1; then
        echo -e "${RED}  ❌ Invalid JSON syntax${NC}"
        VALIDATION_PASSED=false
        continue
    fi
    
    # Extract keys from current file (only actual translation keys, not metadata)
    CURRENT_KEYS=$(python3 -c "
import json
import sys
with open('$arb_file', 'r') as f:
    data = json.load(f)
keys = [k for k in data.keys() if not k.startswith('@')]
for key in sorted(keys):
    print(key)
" 2>/dev/null)
    CURRENT_KEY_COUNT=$(echo "$CURRENT_KEYS" | wc -l)
    
    # Find missing keys using temporary files for compatibility
    TEMP_TEMPLATE=$(mktemp)
    TEMP_CURRENT=$(mktemp)
    echo "$TEMPLATE_KEYS" > "$TEMP_TEMPLATE"
    echo "$CURRENT_KEYS" > "$TEMP_CURRENT"
    
    MISSING_KEYS=$(comm -23 "$TEMP_TEMPLATE" "$TEMP_CURRENT")
    if [ -z "$MISSING_KEYS" ]; then
        MISSING_COUNT=0
    else
        MISSING_COUNT=$(echo "$MISSING_KEYS" | grep -c .)
    fi
    
    # Find extra keys
    EXTRA_KEYS=$(comm -13 "$TEMP_TEMPLATE" "$TEMP_CURRENT")
    if [ -z "$EXTRA_KEYS" ]; then
        EXTRA_COUNT=0
    else
        EXTRA_COUNT=$(echo "$EXTRA_KEYS" | grep -c .)
    fi
    
    # Clean up temporary files
    rm "$TEMP_TEMPLATE" "$TEMP_CURRENT"
    
    echo "  📊 Keys: $CURRENT_KEY_COUNT/$TEMPLATE_KEY_COUNT"
    
    if [ "$MISSING_COUNT" -gt 0 ]; then
        echo -e "${RED}  ❌ Missing $MISSING_COUNT keys:${NC}"
        echo "$MISSING_KEYS" | sed 's/^/    - /'
        VALIDATION_PASSED=false
    fi
    
    if [ "$EXTRA_COUNT" -gt 0 ]; then
        echo -e "${YELLOW}  ⚠️  Extra $EXTRA_COUNT keys:${NC}"
        echo "$EXTRA_KEYS" | sed 's/^/    - /'
    fi
    
    if [ "$MISSING_COUNT" -eq 0 ] && [ "$EXTRA_COUNT" -eq 0 ]; then
        echo -e "${GREEN}  ✅ All keys present${NC}"
    fi
    
    echo ""
done

# Final validation result
echo "=============================="
if [ "$VALIDATION_PASSED" = true ]; then
    echo -e "${GREEN}🎉 All translations validated successfully!${NC}"
    echo ""
    echo "📋 Summary:"
    echo "  - Template keys: $TEMPLATE_KEY_COUNT"
    echo "  - ARB files: ${#ARB_FILES[@]}"
    echo "  - Status: ✅ PASSED"
    exit 0
else
    echo -e "${RED}❌ Translation validation failed!${NC}"
    echo ""
    echo "🔧 To fix issues:"
    echo "  1. Add missing translation keys to ARB files"
    echo "  2. Fix JSON syntax errors"
    echo "  3. Run validation again"
    echo ""
    echo "📋 Summary:"
    echo "  - Template keys: $TEMPLATE_KEY_COUNT"
    echo "  - ARB files: ${#ARB_FILES[@]}"
    echo "  - Status: ❌ FAILED"
    exit 1
fi
