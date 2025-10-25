#!/bin/bash
#
# Third Problem
#
echo "******* This program takes target and replacement word. It replaces and writes to a new modified file ******"

# Input Validation: Check if exactly three arguments are provided
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <filename> <target_word> <replacement_word>"
    echo "Example: $0 report.txt error warning"
    exit 1
fi

# Assign arguments to meaningful variables
INPUT_FILE="$1"
TARGET="$2"
REPLACEMENT="$3"
OUTPUT_FILE="modified_${INPUT_FILE}"
LOG_FILE="changes.log"

# File Existence Check
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file '$INPUT_FILE' not found."
    exit 1
fi

#  Count occurrences of the target word
COUNT=$(grep -o -E "$TARGET" "$INPUT_FILE" | wc -l) # -o (Only matching) so we want only word not line. In default, grep returns line that includes target word. wc -l count number of lines

# Remove leading/trailing whitespace from count
COUNT=$(echo $COUNT | tr -d ' ')


sed "s/${TARGET}/${REPLACEMENT}/g" "$INPUT_FILE" > "$OUTPUT_FILE" # sed(Stream Editor), s(substitute), g(bir satırda birden fazla kez eşleşme bulsa bile, o satırdaki tüm eşleşmeleri değiştirmesi talimatını verir), 

# Log the changes
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
LOG_MESSAGE="[$TIMESTAMP] In file '$INPUT_FILE', replaced '$TARGET' with '$REPLACEMENT'. Total changes: $COUNT."
echo "$LOG_MESSAGE" >> "$LOG_FILE"

# Exit successfully
exit 0

