#!/bin/bash

# Recursively searches for *.rar files and extracts them in their directory
# Path to unrar utility
UNRAR_PATH="/rar/unrar"

# Check if unrar exists
if [ ! -x "$UNRAR_PATH" ]; then
    echo "Error: unrar not found at $UNRAR_PATH"
    exit 1
fi

# Check if directory argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <directory>"
    echo "Example: $0 /path/to/search"
    exit 1
fi

SEARCH_DIR="$1"

# Check if search directory exists
if [ ! -d "$SEARCH_DIR" ]; then
    echo "Error: Directory '$SEARCH_DIR' does not exist"
    exit 1
fi

echo "Searching for RAR files in: $SEARCH_DIR"
echo "----------------------------------------"

# Counter for statistics
total_found=0
total_extracted=0
total_failed=0

# Find all .rar files recursively
while IFS= read -r -d '' rar_file; do
    ((total_found++))
    
    # Get the directory where the RAR file is located
    rar_dir=$(dirname "$rar_file")
    rar_name=$(basename "$rar_file")
    
    echo ""
    echo "[$total_found] Found: $rar_file"
    echo "    Extracting to: $rar_dir"
    
    # Extract the RAR file to its own directory
    # x = extract with full path
    # -o+ = overwrite existing files
    # -y = assume Yes on all queries
    if "$UNRAR_PATH" x -o+ -y "$rar_file" "$rar_dir/" > /dev/null 2>&1; then
        echo "    ✓ Successfully extracted"
        ((total_extracted++))
    else
        echo "    ✗ Extraction failed"
        ((total_failed++))
    fi
    
done < <(find "$SEARCH_DIR" -type f -iname "*.rar" -print0)

# Print summary
echo ""
echo "========================================"
echo "Extraction Summary:"
echo "----------------------------------------"
echo "Total RAR files found:  $total_found"
echo "Successfully extracted: $total_extracted"
echo "Failed extractions:     $total_failed"
echo "========================================"

exit 0
