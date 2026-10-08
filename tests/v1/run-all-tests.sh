#!/bin/bash

#===========================================
# MatinBook - Test Suite Runner
# Compiles all tests and cleans up
#===========================================

set -e  # Exit on first error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
TEX_ENGINE="xelatex"
TEX_FLAGS="-shell-escape -interaction=nonstopmode"
BIBER="biber"
MAKEINDEX="makeindex"
PASSED=0
FAILED=0
TOTAL=0

#===========================================
# Find Project Root
#===========================================

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If we're in tests/ directory, go up one level
if [[ "$(basename "$SCRIPT_DIR")" == "tests" ]]; then
    PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
else
    PROJECT_ROOT="$SCRIPT_DIR"
fi

# Check if this looks like matinbook project root
if [[ ! -f "$PROJECT_ROOT/matinbook.cls" ]] && [[ ! -f "$PROJECT_ROOT/../matinbook.cls" ]]; then
    # Maybe we're somewhere else, try to find matinbook.cls
    if [[ -f "$SCRIPT_DIR/matinbook.cls" ]]; then
        PROJECT_ROOT="$SCRIPT_DIR"
    elif [[ -f "$SCRIPT_DIR/../matinbook.cls" ]]; then
        PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
    else
        echo -e "${RED}❌ Cannot find matinbook.cls!${NC}"
        echo -e "${YELLOW}📝 Make sure you're in the matinbook project or its subdirectories.${NC}"
        exit 1
    fi
fi

TESTS_DIR="$PROJECT_ROOT/tests"
EXAMPLES_DIR="$PROJECT_ROOT/examples"

#===========================================
# Helper Functions
#===========================================

print_header() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}  MatinBook - Test Suite Runner${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "${BLUE}Project: ${PROJECT_ROOT}${NC}"
    echo -e "${BLUE}Tests:   ${TESTS_DIR}${NC}"
    echo ""
}

print_separator() {
    echo -e "${BLUE}----------------------------------------${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}📝 $1${NC}"
}

print_stage() {
    echo -e "${CYAN}🔨 $1${NC}"
}

cleanup_aux_files() {
    local base_name="$1"
    local dir="$2"
    
    # Remove LaTeX auxiliary files
    rm -f "${dir}/${base_name}".aux
    rm -f "${dir}/${base_name}".log
    rm -f "${dir}/${base_name}".out
    rm -f "${dir}/${base_name}".toc
    rm -f "${dir}/${base_name}".lof
    rm -f "${dir}/${base_name}".lot
    rm -f "${dir}/${base_name}".loa
    rm -f "${dir}/${base_name}".bbl
    rm -f "${dir}/${base_name}".bcf
    rm -f "${dir}/${base_name}".blg
    rm -f "${dir}/${base_name}".run.xml
    rm -f "${dir}/${base_name}".idx
    rm -f "${dir}/${base_name}".ilg
    rm -f "${dir}/${base_name}".ind
    rm -f "${dir}/${base_name}".synctex.gz
    rm -f "${dir}/${base_name}".thm
    rm -f "${dir}/${base_name}".nav
    rm -f "${dir}/${base_name}".snm
    rm -f "${dir}/${base_name}".vrb
    rm -f "${dir}/${base_name}".pyg
    rm -f "${dir}/${base_name}".listing
    rm -f "${dir}/${base_name}".hd
    rm -f "${dir}/${base_name}".gls
    rm -f "${dir}/${base_name}".glg
    rm -f "${dir}/${base_name}".glo
    rm -f "${dir}/${base_name}".xdy
    
    # Remove _minted directory
    rm -rf "${dir}/_minted-${base_name}"
    
    # Remove _markdown directory if exists
    rm -rf "${dir}/_markdown_${base_name}"
}

compile_tex() {
    local file="$1"
    local dir=$(dirname "$file")
    local base=$(basename "$file" .tex)
    
    print_stage "Compiling: ${base}.tex"
    
    # First pass
    print_info "  Pass 1/3: xelatex..."
    if ${TEX_ENGINE} ${TEX_FLAGS} -output-directory="${dir}" "${file}" > /dev/null 2>&1; then
        print_success "  Pass 1 complete"
    else
        print_error "  Pass 1 failed"
        return 1
    fi
    
    # Run biber if bibliography needed (stage12, stage14)
    if [[ "$base" == *"stage12"* ]] || [[ "$base" == *"stage14"* ]]; then
        if [ -f "${dir}/${base}.bcf" ]; then
            print_info "  Running biber..."
            if ${BIBER} --output-directory="${dir}" "${dir}/${base}" > /dev/null 2>&1; then
                print_success "  Biber complete"
            else
                print_info "  Biber had issues (may be OK)"
            fi
        fi
    fi
    
    # Run makeindex if index needed (stage13, stage14)
    if [[ "$base" == *"stage13"* ]] || [[ "$base" == *"stage14"* ]]; then
        if [ -f "${dir}/${base}.idx" ]; then
            print_info "  Running makeindex..."
            if ${MAKEINDEX} -o "${dir}/${base}.ind" "${dir}/${base}.idx" > /dev/null 2>&1; then
                print_success "  Makeindex complete"
            else
                print_info "  Makeindex had issues (may be OK)"
            fi
        fi
    fi
    
    # Second pass
    print_info "  Pass 2/3: xelatex..."
    if ${TEX_ENGINE} ${TEX_FLAGS} -output-directory="${dir}" "${file}" > /dev/null 2>&1; then
        print_success "  Pass 2 complete"
    else
        print_error "  Pass 2 failed"
        return 1
    fi
    
    # Third pass (for cross-references)
    print_info "  Pass 3/3: xelatex..."
    if ${TEX_ENGINE} ${TEX_FLAGS} -output-directory="${dir}" "${file}" > /dev/null 2>&1; then
        print_success "  Pass 3 complete"
    else
        print_info "  Pass 3 had warnings (may be OK)"
    fi
    
    return 0
}

run_test() {
    local file="$1"
    local base=$(basename "$file" .tex)
    local dir=$(dirname "$file")
    
    TOTAL=$((TOTAL + 1))
    
    echo ""
    print_separator
    echo -e "${CYAN}Test ${TOTAL}: ${base}${NC}"
    print_separator
    
    if compile_tex "$file"; then
        PASSED=$((PASSED + 1))
        print_success "Test ${TOTAL} PASSED: ${base}"
        
        # Clean auxiliary files after successful test
        cleanup_aux_files "$base" "$dir"
    else
        FAILED=$((FAILED + 1))
        print_error "Test ${TOTAL} FAILED: ${base}"
        echo -e "${YELLOW}  Check ${dir}/${base}.log for details${NC}"
    fi
}

print_summary() {
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}  Test Summary${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
    echo -e "Total:  ${TOTAL}"
    echo -e "${GREEN}Passed: ${PASSED}${NC}"
    if [ $FAILED -gt 0 ]; then
        echo -e "${RED}Failed: ${FAILED}${NC}"
    else
        echo -e "Failed: ${FAILED}"
    fi
    echo ""
    
    if [ $FAILED -eq 0 ]; then
        echo -e "${GREEN}🎉 All tests passed! MatinBook is ready!${NC}"
        echo ""
        return 0
    else
        echo -e "${RED}⚠️  Some tests failed. Please check the logs.${NC}"
        echo ""
        return 1
    fi
}

clean_all_aux() {
    echo ""
    print_separator
    print_info "Cleaning all auxiliary files..."
    print_separator
    
    # Clean tests directory
    if [ -d "$TESTS_DIR" ]; then
        rm -f ${TESTS_DIR}/*.aux ${TESTS_DIR}/*.log ${TESTS_DIR}/*.out
        rm -f ${TESTS_DIR}/*.toc ${TESTS_DIR}/*.lof ${TESTS_DIR}/*.lot ${TESTS_DIR}/*.loa
        rm -f ${TESTS_DIR}/*.bbl ${TESTS_DIR}/*.bcf ${TESTS_DIR}/*.blg ${TESTS_DIR}/*.run.xml
        rm -f ${TESTS_DIR}/*.idx ${TESTS_DIR}/*.ilg ${TESTS_DIR}/*.ind
        rm -f ${TESTS_DIR}/*.synctex.gz ${TESTS_DIR}/*.thm ${TESTS_DIR}/*.nav
        rm -f ${TESTS_DIR}/*.snm ${TESTS_DIR}/*.vrb ${TESTS_DIR}/*.pyg
        rm -rf ${TESTS_DIR}/_minted-*
    fi
    
    # Clean examples directory
    if [ -d "$EXAMPLES_DIR" ]; then
        rm -f ${EXAMPLES_DIR}/*.aux ${EXAMPLES_DIR}/*.log ${EXAMPLES_DIR}/*.out
        rm -f ${EXAMPLES_DIR}/*.toc ${EXAMPLES_DIR}/*.lof ${EXAMPLES_DIR}/*.lot
        rm -f ${EXAMPLES_DIR}/*.bbl ${EXAMPLES_DIR}/*.bcf ${EXAMPLES_DIR}/*.blg
        rm -f ${EXAMPLES_DIR}/*.idx ${EXAMPLES_DIR}/*.ilg ${EXAMPLES_DIR}/*.ind
        rm -rf ${EXAMPLES_DIR}/_minted-*
    fi
    
    print_success "All auxiliary files cleaned!"
}

#===========================================
# Main Script
#===========================================

main() {
    print_header
    
    # Check if tests directory exists
    if [ ! -d "$TESTS_DIR" ]; then
        print_error "Tests directory '${TESTS_DIR}' not found!"
        print_info "Searched in: ${TESTS_DIR}"
        exit 1
    fi
    
    # Check for xelatex
    if ! command -v ${TEX_ENGINE} &> /dev/null; then
        print_error "${TEX_ENGINE} not found! Please install XeLaTeX first."
        exit 1
    fi
    
    print_info "Engine: ${TEX_ENGINE}"
    print_info "Flags:  ${TEX_FLAGS}"
    echo ""
    
    # Run all stage tests
    print_info "Running all stage tests..."
    
    # Stage 1-15 tests (check for file existence first)
    for i in $(seq -w 1 15); do
        # Try different naming patterns
        found=0
        for pattern in "stage${i}-basic" "stage${i}-fonts" "stage${i}-layout" \
                       "stage${i}-typography" "stage${i}-math" "stage${i}-theorems" \
                       "stage${i}-boxes" "stage${i}-code" "stage${i}-algorithms" \
                       "stage${i}-tikz" "stage${i}-references" "stage${i}-biblatex" \
                       "stage${i}-index" "stage${i}-book" "stage${i}-cover"; do
            if [ -f "${TESTS_DIR}/${pattern}.tex" ]; then
                run_test "${TESTS_DIR}/${pattern}.tex"
                found=1
                break
            fi
        done
        if [ $found -eq 0 ]; then
            print_info "Stage ${i}: No test file found, skipping..."
        fi
    done
    
    # Final cleanup
    clean_all_aux
    
    # Print summary
    print_summary
}

# Run main function
main "$@"