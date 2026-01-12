#!/bin/bash

# Flutter Localization Generation Script
# This script regenerates the localization files after ARB changes

echo "🌍 Flutter Localization Generator"
echo "================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if Flutter is available
if ! command -v flutter &>/dev/null; then
  echo -e "${RED}❌ Flutter not found in PATH${NC}"
  echo "Please ensure Flutter is installed and added to your PATH"
  echo ""
  echo "To install Flutter:"
  echo "1. Download from https://flutter.dev/docs/get-started/install"
  echo "2. Add Flutter to your PATH"
  echo "3. Run 'flutter doctor' to verify installation"
  exit 1
fi

echo -e "${GREEN}✅ Flutter found: $(flutter --version | head -n 1)${NC}"
echo ""

# Navigate to project root
cd "$(dirname "$0")/../.."

echo -e "${BLUE}📁 Current directory: $(pwd)${NC}"
echo ""

# Pre-generation validation
echo -e "${YELLOW}🔍 Running pre-generation validation...${NC}"
if [ -f "scripts/l10n/validate_translations.sh" ]; then
  if sh scripts/l10n/validate_translations.sh; then
    echo -e "${GREEN}✅ Translation validation passed${NC}"
  else
    echo -e "${RED}❌ Translation validation failed${NC}"
    echo "Please fix translation issues before generating localizations"
    exit 1
  fi
else
  echo -e "${YELLOW}⚠️  Validation script not found, skipping validation${NC}"
fi
echo ""

# Check required files
echo -e "${YELLOW}📋 Checking required files...${NC}"
if [ ! -f "l10n.yaml" ]; then
  echo -e "${RED}❌ l10n.yaml not found${NC}"
  exit 1
fi

if [ ! -d "lib/l10n" ]; then
  echo -e "${RED}❌ lib/l10n directory not found${NC}"
  exit 1
fi

ARB_COUNT=$(find lib/l10n -name "*.arb" | wc -l)
if [ "$ARB_COUNT" -eq 0 ]; then
  echo -e "${RED}❌ No ARB files found in lib/l10n${NC}"
  exit 1
fi

# Validate l10n.yaml configuration
echo -e "${YELLOW}🔧 Validating l10n.yaml configuration...${NC}"
TEMPLATE_ARB=$(python3 -c "
import yaml
with open('l10n.yaml', 'r') as f:
    config = yaml.safe_load(f)
print(config.get('template-arb-file', 'intl_en.arb'))
" 2>/dev/null || echo "intl_en.arb")

ARB_DIR=$(python3 -c "
import yaml
with open('l10n.yaml', 'r') as f:
    config = yaml.safe_load(f)
print(config.get('arb-dir', 'lib/l10n'))
" 2>/dev/null || echo "lib/l10n")

if [ ! -f "$ARB_DIR/$TEMPLATE_ARB" ]; then
  echo -e "${RED}❌ Template ARB file not found: $ARB_DIR/$TEMPLATE_ARB${NC}"
  echo "Please check your l10n.yaml configuration"
  exit 1
fi

echo -e "${GREEN}✅ Found $ARB_COUNT ARB files${NC}"
echo -e "${GREEN}✅ l10n.yaml configuration validated${NC}"
echo -e "${GREEN}✅ Template file: $TEMPLATE_ARB${NC}"
echo ""

# Backup existing generated files (optional)
BACKUP_DIR="lib/l10n/backup_$(date +%Y%m%d_%H%M%S)"
if ls lib/l10n/generated/app_localizations*.dart 1>/dev/null 2>&1; then
  echo -e "${YELLOW}💾 Backing up existing generated files...${NC}"
  mkdir -p "$BACKUP_DIR"
  cp lib/l10n/generated/app_localizations*.dart "$BACKUP_DIR/" 2>/dev/null
  echo -e "${GREEN}✅ Backup created: $BACKUP_DIR${NC}"
  echo ""
fi

# Clean previous builds
echo -e "${YELLOW}🧹 Cleaning previous builds...${NC}"
if flutter clean; then
  echo -e "${GREEN}✅ Clean completed${NC}"
else
  echo -e "${RED}❌ Clean failed${NC}"
  exit 1
fi
echo ""

# Get dependencies
echo -e "${YELLOW}📦 Getting dependencies...${NC}"
if flutter pub get; then
  echo -e "${GREEN}✅ Dependencies updated${NC}"
else
  echo -e "${RED}❌ Failed to get dependencies${NC}"
  echo "Please check your internet connection and pubspec.yaml"
  exit 1
fi
echo ""

# Generate localizations
echo -e "${YELLOW}🌐 Generating localizations...${NC}"
if flutter gen-l10n; then
  echo -e "${GREEN}✅ Localization generation completed successfully!${NC}"
else
  echo -e "${RED}❌ Localization generation failed!${NC}"
  echo "Please check the ARB file syntax and l10n.yaml configuration"

  # Restore backup if available
  if [ -d "$BACKUP_DIR" ]; then
    echo -e "${YELLOW}🔄 Restoring backup files...${NC}"
    mkdir -p lib/l10n/generated
    cp "$BACKUP_DIR"/*.dart lib/l10n/generated/ 2>/dev/null
    echo -e "${GREEN}✅ Backup restored${NC}"
  fi
  exit 1
fi
echo ""

# Verify generated files
echo -e "${YELLOW}🔍 Verifying generated files...${NC}"
GENERATED_FILES=(lib/l10n/generated/app_localizations*.dart)
if [ ${#GENERATED_FILES[@]} -gt 0 ] && [ -f "${GENERATED_FILES[0]}" ]; then
  echo -e "${GREEN}✅ Generated files verified:${NC}"
  for file in "${GENERATED_FILES[@]}"; do
    if [ -f "$file" ]; then
      echo "  - $(basename "$file") ($(wc -l <"$file") lines)"
    fi
  done

  # Clean up backup if generation was successful
  if [ -d "$BACKUP_DIR" ]; then
    rm -rf "$BACKUP_DIR"
    echo -e "${BLUE}🗑️  Backup cleaned up${NC}"
  fi
else
  echo -e "${RED}❌ No generated files found!${NC}"
  echo "Generation may have failed silently"
  exit 1
fi
echo ""

echo "=============================="
echo -e "${GREEN}🎉 Localization generation completed successfully!${NC}"
echo ""
echo -e "${BLUE}📋 Next steps:${NC}"
echo "1. Test the app with different locales"
echo "2. Verify all translations are working correctly"
echo "3. Update translation platforms if needed"
echo "4. Commit the generated files to version control"
echo ""
echo -e "${BLUE}📊 Summary:${NC}"
echo "  - ARB files processed: $ARB_COUNT"
echo "  - Generated files: ${#GENERATED_FILES[@]}"
echo "  - Status: ✅ SUCCESS"
