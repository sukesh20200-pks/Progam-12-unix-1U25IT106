#!/bin/bash

set -u

STUDENT_FILE="student.sh"
PASS=0
FAIL=0

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

pass_test() {
    echo -e "${GREEN}[PASS]${NC} $1"
    PASS=$((PASS + 1))
}

fail_test() {
    echo -e "${RED}[FAIL]${NC} $1"
    FAIL=$((FAIL + 1))
}

echo "======================================"
echo "     Bash For Loop Autograder"
echo "======================================"
echo

# Test 1: Check student.sh exists
if [ -f "$STUDENT_FILE" ]; then
    pass_test "student.sh exists"
else
    fail_test "student.sh does not exist"
    echo
    echo "Cannot continue without student.sh"
    exit 1
fi

# Test 2: Check executable permission
if [ -x "$STUDENT_FILE" ]; then
    pass_test "student.sh is executable"
else
    fail_test "student.sh is not executable"
    chmod +x "$STUDENT_FILE"
    echo "  Temporary executable permission added for testing."
fi

# Test 3: Check that a for loop is used
if grep -Eq '(^|[[:space:]])for[[:space:]]' "$STUDENT_FILE"; then
    pass_test "Program uses a for loop"
else
    fail_test "Program does not appear to use a for loop"
fi

# Test 4: Run the program
OUTPUT=$(timeout 5 bash "$STUDENT_FILE" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 124 ]; then
    fail_test "Program timed out"
else
    pass_test "Program executes successfully"
fi

# Test 5: Check exact output
EXPECTED=$'1\n2\n3\n4\n5\n6\n7\n8\n9\n10'

if [ "$OUTPUT" = "$EXPECTED" ]; then
    pass_test "Output is exactly 1 to 10"
else
    fail_test "Output is not exactly 1 to 10"
    echo
    echo "Expected:"
    printf '%s\n' "$EXPECTED"
    echo
    echo "Actual:"
    printf '%s\n' "$OUTPUT"
fi

# Test 6: Check number of output lines
LINE_COUNT=$(printf '%s\n' "$OUTPUT" | wc -l)

if [ "$LINE_COUNT" -eq 10 ]; then
    pass_test "Output contains exactly 10 lines"
else
    fail_test "Output should contain exactly 10 lines"
fi

echo
echo "======================================"
echo "             RESULT"
echo "======================================"
echo -e "${GREEN}Passed: $PASS${NC}"
echo -e "${RED}Failed: $FAIL${NC}"
echo "======================================"

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}All tests passed!${NC}"
    exit 0
else
    echo -e "${RED}Some tests failed.${NC}"
    exit 1
fi
