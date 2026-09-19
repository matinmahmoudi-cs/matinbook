#!/bin/bash
FILE="$1"
if [ -z "$FILE" ]; then
    echo "Usage: ./compile.sh <filename.tex>"
    exit 1
fi

BASENAME="${FILE%.tex}"
PROJECT_ROOT="$(cd ../.. && pwd)"

# TEXINPUTS: PROJECT_ROOT + all subdirectories
export TEXINPUTS="${PROJECT_ROOT}:${PROJECT_ROOT}//:"

echo "Compiling $FILE..."
xelatex -shell-escape -interaction=nonstopmode "$FILE" > /dev/null 2>&1
xelatex -shell-escape -interaction=nonstopmode "$FILE" > /dev/null 2>&1

if [ -f "${BASENAME}.pdf" ]; then
    echo "✅ PDF: ${BASENAME}.pdf"
else
    echo "❌ PDF not found"
fi

if grep -q "^!" "${BASENAME}.log"; then
    echo "❌ Errors:"
    grep "^!" "${BASENAME}.log" | head -3
else
    echo "✅ No errors!"
fi
