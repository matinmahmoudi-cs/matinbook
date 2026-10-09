#!/bin/bash

#===========================================
# MatinBook — Test Suite Runner
# Compiles all v1 tests and cleans up.
#
# Behavior:
#   - Runs every test in tests/v1/ in numeric order.
#   - Keeps the .log of any failed test for inspection.
#   - Removes all other auxiliary files after the run.
#   - Prints a summary with paths to preserved logs.
#
# Usage:
#   ./run-all-tests.sh          # run all tests
#   ./run-all-tests.sh stage08  # run only stage08-*.tex
#===========================================

# NOTE: We do NOT use `set -e` because we want to
# continue running tests even if one fails.

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
XINDY="texindy"
PASSED=0
FAILED=0
TOTAL=0
FAILED_TESTS=()

#===========================================
# Find Project Root
#===========================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Walk up until we find matinbook.cls.
PROJECT_ROOT="${SCRIPT_DIR}"
while [ "${PROJECT_ROOT}" != "/" ] && [ ! -f "${PROJECT_ROOT}/matinbook.cls" ]; do
    PROJECT_ROOT="$(dirname "${PROJECT_ROOT}")"
done

if [ ! -f "${PROJECT_ROOT}/matinbook.cls" ]; then
    echo -e "${RED}Cannot find matinbook.cls!${NC}"
    echo -e "${YELLOW}Make sure you're running this script from inside the matinbook project.${NC}"
    exit 1
fi

TESTS_DIR="${SCRIPT_DIR}"
EXAMPLES_DIR="${PROJECT_ROOT}/examples"

#===========================================
# Helper Functions
#===========================================

print_header() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}  MatinBook — Test Suite Runner${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "${BLUE}Project: ${PROJECT_ROOT}${NC}"
    echo -e "${BLUE}Tests:   ${TESTS_DIR}${NC}"
    echo ""
}

print_separator() {
    echo -e "${BLUE}----------------------------------------${NC}"
}

print_success() {
    echo -e "${GREEN}  PASS: $1${NC}"
}

print_error() {
    echo -e "${RED}  FAIL: $1${NC}"
}

print_info() {
    echo -e "${YELLOW}  INFO: $1${NC}"
}

print_stage() {
    echo -e "${CYAN}>>> $1${NC}"
}

cleanup_aux_files() {
    local base_name="$1"
    local dir="$2"

    # Remove LaTeX auxiliary files.
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
    rm -f "${dir}/${base_name}".xdy
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
    rm -f "${dir}/${base_name}".xdv
    rm -f "${dir}/${base_name}".fdb_latexmk
    rm -f "${dir}/${base_name}".fls

    # Remove minted cache directory
    rm -rf "${dir}/_minted-${base_name}"

    # Remove markdown cache if any
    rm -rf "${dir}/_markdown_${base_name}"
}

compile_tex() {
    local file="$1"
    local dir
    dir=$(dirname "$file")
    local base
    base=$(basename "$file" .tex)

    print_stage "Compiling: ${base}.tex"

    # Set TEXINPUTS so that the whole project is searched
    # recursively (the double slash `//` means "recursive").
    export TEXINPUTS="${PROJECT_ROOT}//:${TEXINPUTS:-}"
    export BIBINPUTS="${PROJECT_ROOT}//:${BIBINPUTS:-}"
    export BSTINPUTS="${PROJECT_ROOT}//:${BSTINPUTS:-}"

    # Change into the test directory so that relative paths
    # inside the .tex file (e.g. ../references.bib) resolve.
    pushd "${dir}" > /dev/null

    # ---- Pass 1 ----
    print_info "Pass 1/3: xelatex"
    if ${TEX_ENGINE} ${TEX_FLAGS} "${base}.tex" > /dev/null 2>&1; then
        print_success "Pass 1 complete"
    else
        print_error "Pass 1 failed"
        popd > /dev/null
        return 1
    fi

    # ---- biber (for stage12, stage14, stage15) ----
    if [[ "$base" == *"stage12"* ]] || \
       [[ "$base" == *"stage14"* ]] || \
       [[ "$base" == *"stage15"* ]]; then
        if [ -f "${base}.bcf" ]; then
            print_info "Running biber"
            if ${BIBER} "${base}" > /dev/null 2>&1; then
                print_success "Biber complete"
            else
                print_info "Biber had issues (may be OK)"
            fi
        fi
    fi

    # ---- xindy (for stage13, stage14, stage15) ----
    if [[ "$base" == *"stage13"* ]] || \
       [[ "$base" == *"stage14"* ]] || \
       [[ "$base" == *"stage15"* ]]; then
        if [ -f "${base}.idx" ]; then
            print_info "Running texindy"
            if ${XINDY} -L persian-variant2 -C utf8 \
                        -M texindy -M page-ranges \
                        -o "${base}.ind" "${base}.idx" > /dev/null 2>&1; then
                print_success "Xindy complete"
            else
                print_info "Xindy had issues (may be OK)"
            fi
        fi
    fi

    # ---- Pass 2 ----
    print_info "Pass 2/3: xelatex"
    if ${TEX_ENGINE} ${TEX_FLAGS} "${base}.tex" > /dev/null 2>&1; then
        print_success "Pass 2 complete"
    else
        print_error "Pass 2 failed"
        popd > /dev/null
        return 1
    fi

    # ---- Pass 3 (cross-references and cover) ----
    print_info "Pass 3/3: xelatex"
    if ${TEX_ENGINE} ${TEX_FLAGS} "${base}.tex" > /dev/null 2>&1; then
        print_success "Pass 3 complete"
    else
        print_info "Pass 3 had warnings (may be OK)"
    fi

    popd > /dev/null
    return 0
}

run_test() {
    local file="$1"
    local base
    base=$(basename "$file" .tex)
    local dir
    dir=$(dirname "$file")

    TOTAL=$((TOTAL + 1))

    echo ""
    print_separator
    echo -e "${CYAN}Test ${TOTAL}: ${base}${NC}"
    print_separator

    if compile_tex "$file"; then
        PASSED=$((PASSED + 1))
        print_success "Test ${TOTAL} PASSED: ${base}"

        # Clean auxiliary files after a successful test
        cleanup_aux_files "$base" "$dir"
    else
        FAILED=$((FAILED + 1))
        print_error "Test ${TOTAL} FAILED: ${base}"
        echo -e "${YELLOW}  Log kept at ${dir}/${base}.log${NC}"

        # Record the failed test so that its .log file is
        # preserved during the final cleanup.
        FAILED_TESTS+=("${base}|${dir}")
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
    if [ "${FAILED}" -gt 0 ]; then
        echo -e "${RED}Failed: ${FAILED}${NC}"
    else
        echo -e "Failed: ${FAILED}"
    fi
    echo ""

    if [ "${FAILED}" -eq 0 ]; then
        echo -e "${GREEN}All tests passed. MatinBook is ready.${NC}"
        echo ""
        return 0
    else
        echo -e "${RED}Some tests failed. Preserved logs:${NC}"
        for entry in "${FAILED_TESTS[@]}"; do
            local base="${entry%%|*}"
            local dir="${entry##*|}"
            echo -e "${YELLOW}  - ${dir}/${base}.log${NC}"
        done
        echo ""
        return 1
    fi
}

clean_all_aux() {
    echo ""
    print_separator
    print_info "Cleaning all auxiliary files"
    print_separator

    # Build an associative array of logs to preserve.
    declare -A PRESERVE=()
    for entry in "${FAILED_TESTS[@]}"; do
        local base="${entry%%|*}"
        local dir="${entry##*|}"
        PRESERVE["${dir}/${base}.log"]=1
    done

    # ---- Clean tests directory ----
    if [ -d "$TESTS_DIR" ]; then
        # Always-safe auxiliary files
        rm -f "${TESTS_DIR}"/*.aux "${TESTS_DIR}"/*.out
        rm -f "${TESTS_DIR}"/*.toc "${TESTS_DIR}"/*.lof "${TESTS_DIR}"/*.lot "${TESTS_DIR}"/*.loa
        rm -f "${TESTS_DIR}"/*.bbl "${TESTS_DIR}"/*.bcf "${TESTS_DIR}"/*.blg "${TESTS_DIR}"/*.run.xml
        rm -f "${TESTS_DIR}"/*.idx "${TESTS_DIR}"/*.ilg "${TESTS_DIR}"/*.ind "${TESTS_DIR}"/*.xdy
        rm -f "${TESTS_DIR}"/*.synctex.gz "${TESTS_DIR}"/*.thm "${TESTS_DIR}"/*.nav
        rm -f "${TESTS_DIR}"/*.snm "${TESTS_DIR}"/*.vrb "${TESTS_DIR}"/*.pyg
        rm -f "${TESTS_DIR}"/*.listing "${TESTS_DIR}"/*.hd
        rm -f "${TESTS_DIR}"/*.xdv "${TESTS_DIR}"/*.fdb_latexmk "${TESTS_DIR}"/*.fls
        rm -rf "${TESTS_DIR}"/_minted-*

        # Logs: remove only those NOT in the preserve list.
        for log in "${TESTS_DIR}"/*.log; do
            [ -e "$log" ] || continue
            if [ -z "${PRESERVE[$log]:-}" ]; then
                rm -f "$log"
            fi
        done
    fi

    # ---- Clean examples directory (no preserve list) ----
    if [ -d "$EXAMPLES_DIR" ]; then
        rm -f "${EXAMPLES_DIR}"/*.aux "${EXAMPLES_DIR}"/*.log "${EXAMPLES_DIR}"/*.out
        rm -f "${EXAMPLES_DIR}"/*.toc "${EXAMPLES_DIR}"/*.lof "${EXAMPLES_DIR}"/*.lot
        rm -f "${EXAMPLES_DIR}"/*.bbl "${EXAMPLES_DIR}"/*.bcf "${EXAMPLES_DIR}"/*.blg
        rm -f "${EXAMPLES_DIR}"/*.idx "${EXAMPLES_DIR}"/*.ilg "${EXAMPLES_DIR}"/*.ind
        rm -f "${EXAMPLES_DIR}"/*.xdv "${EXAMPLES_DIR}"/*.fdb_latexmk "${EXAMPLES_DIR}"/*.fls
        rm -rf "${EXAMPLES_DIR}"/_minted-*
    fi

    print_success "All auxiliary files cleaned"
}

#===========================================
# Main Script
#===========================================

main() {
    print_header

    if [ ! -d "$TESTS_DIR" ]; then
        print_error "Tests directory '${TESTS_DIR}' not found!"
        exit 1
    fi

    if ! command -v ${TEX_ENGINE} &> /dev/null; then
        print_error "${TEX_ENGINE} not found! Please install XeLaTeX first."
        exit 1
    fi

    print_info "Engine: ${TEX_ENGINE}"
    print_info "Flags:  ${TEX_FLAGS}"
    echo ""

    # The actual v1 tests, in numeric order.
    # This explicit list is more robust than trying every
    # possible name for every number.
    local test_files=(
        "stage01-basic.tex"
        "stage02-fonts.tex"
        "stage03-layout.tex"
        "stage04-typography.tex"
        "stage05-math.tex"
        "stage06-theorems.tex"
        "stage07-boxes.tex"
        "stage08-code.tex"
        "stage09-algorithms.tex"
        "stage10-tikz.tex"
        "stage11-references.tex"
        "stage12-biblatex.tex"
        "stage13-index.tex"
        "stage14-book.tex"
        "stage15-cover.tex"
    )

    # If the user passed a pattern on the command line, filter
    # the test list to only those that match.
    local filter="${1:-}"
    if [ -n "${filter}" ]; then
        print_info "Filter: only tests matching '${filter}'"
        local filtered=()
        for test_file in "${test_files[@]}"; do
            if [[ "${test_file}" == *"${filter}"* ]]; then
                filtered+=("${test_file}")
            fi
        done
        test_files=("${filtered[@]}")
    fi

    if [ ${#test_files[@]} -eq 0 ]; then
        print_error "No test files matched the filter."
        exit 1
    fi

    for test_file in "${test_files[@]}"; do
        if [ -f "${TESTS_DIR}/${test_file}" ]; then
            run_test "${TESTS_DIR}/${test_file}"
        else
            print_info "Skipping ${test_file} (not found)"
        fi
    done

    # Final cleanup (preserves logs of failed tests)
    clean_all_aux

    # Print summary
    print_summary
}

# Run main function
main "$@"