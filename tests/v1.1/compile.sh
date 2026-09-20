#!/bin/bash
#========================================
# MatinBook — Test Compiler
#========================================
# Compiles all .tex files in the current directory,
# runs two passes for cross-references,
# and cleans up auxiliary files on success.
#========================================

# Get project root (two levels up from tests/v1.1)
PROJECT_ROOT="$(cd ../.. && pwd)"

# Set TEXINPUTS: project root + all subdirectories
export TEXINPUTS="${PROJECT_ROOT}:${PROJECT_ROOT}//:"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Auxiliary file extensions to clean
AUX_EXTENSIONS="aux log out toc lof lot idx ind ilg bbl bcf blg run.xml fls fdb_latexmk nav snm vrb xdv synctex.gz"

# Track results
PASSED=0
FAILED=0
FAILED_TESTS=()

# Find all .tex files in current directory (not recursive)
TEX_FILES=$(ls *.tex 2>/dev/null)

if [ -z "$TEX_FILES" ]; then
    echo -e "${RED}No .tex files found in $(pwd)${NC}"
    exit 1
fi

echo "════════════════════════════════════════"
echo "  MatinBook Test Compiler"
echo "════════════════════════════════════════"
echo "  Directory: $(pwd)"
echo "  Files found: $(echo "$TEX_FILES" | wc -l)"
echo "════════════════════════════════════════"
echo ""

for FILE in $TEX_FILES; do
    BASENAME="${FILE%.tex}"
    
    echo -e "${YELLOW}▶ Compiling: $FILE${NC}"
    
    # Pass 1
    xelatex -shell-escape -interaction=nonstopmode "$FILE" > /dev/null 2>&1
    PASS1_CODE=$?
    
    # Pass 2 (for cross-references)
    xelatex -shell-escape -interaction=nonstopmode "$FILE" > /dev/null 2>&1
    PASS2_CODE=$?
    
    # Check for errors in log
    HAS_ERRORS=0
    if [ -f "${BASENAME}.log" ]; then
        if grep -q "^!" "${BASENAME}.log"; then
            HAS_ERRORS=1
        fi
    fi
    
    # Check for PDF
    if [ -f "${BASENAME}.pdf" ] && [ "$HAS_ERRORS" -eq 0 ]; then
        # Success!
        PDF_SIZE=$(du -h "${BASENAME}.pdf" | cut -f1)
        echo -e "${GREEN}  ✅ PASS${NC} (${PDF_SIZE})"
        PASSED=$((PASSED + 1))
        
        # Clean auxiliary files
        for EXT in $AUX_EXTENSIONS; do
            rm -f "${BASENAME}.${EXT}" 2>/dev/null
        done
        
    else
        # Failure
        echo -e "${RED}  ❌ FAIL${NC}"
        FAILED=$((FAILED + 1))
        FAILED_TESTS+=("$FILE")
        
        # Show first 3 errors
        if [ -f "${BASENAME}.log" ]; then
            echo -e "${RED}  Errors:${NC}"
            grep "^!" "${BASENAME}.log" | head -3 | sed 's/^/    /'
        fi
    fi
    
    echo ""
done

# Summary
echo "════════════════════════════════════════"
echo "  SUMMARY"
echo "════════════════════════════════════════"
echo -e "  ${GREEN}Passed: $PASSED${NC}"
echo -e "  ${RED}Failed: $FAILED${NC}"

if [ "$FAILED" -gt 0 ]; then
    echo ""
    echo -e "${RED}  Failed tests:${NC}"
    for t in "${FAILED_TESTS[@]}"; do
        echo "    - $t"
    done
fi

echo "════════════════════════════════════════"

# Exit with failure if any test failed
if [ "$FAILED" -gt 0 ]; then
    exit 1
fi

exit 0
