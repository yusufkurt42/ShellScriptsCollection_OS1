#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory_name> <prefix>"
    echo "Example: $0 docs proj_"
    exit 1
fi

DIR="$1"
PREFIX="$2"
RENAME_COUNT=0
RENAMED_LIST=""

if [ ! -d "$DIR" ]; then
    echo "Error: Directory '$DIR' not found."
    exit 1
fi

rename() {
    local search_path="$1" # bunlar fonksiyonun parametreleri
    local depth_opt="$2"
    
    find "$search_path" $depth_opt -type f -name "*.txt" -print0 | 
    
    while IFS= read -r -d $'\0' fullpath; do    
        filename=$(bax	sename "$fullpath")
        dirpart=$(dirname "$fullpath")
        newname="${PREFIX}${filename}"
        
        mv "$fullpath" "$dirpart/$newname"
        
        RENAMED_LIST+="${newname}, "
        RENAME_COUNT=$((RENAME_COUNT + 1))
    done
}

if find "$DIR" -mindepth 1 -maxdepth 1 -type d -not -name '.*' -print -quit 2>/dev/null | grep -q '.'; then
    
    echo "The directory '$DIR' contains subdirectories."
    read -r -p "Do you want to rename files in subdirectories too (y/N)? " RECURSIVE_CHOICE
    
    if [[ "$RECURSIVE_CHOICE" =~ ^[Yy]$ ]]; then
        rename "$DIR" ""
    else
        rename "$DIR" "-maxdepth 1"
    fi
else
    rename "$DIR" "-maxdepth 1"
fi

if [ "$RENAME_COUNT" -gt 0 ]; then
    CLEAN_LIST="${RENAMED_LIST%, }"
    echo "$RENAME_COUNT files renamed: $CLEAN_LIST"
else
    echo "No .txt files were found or renamed in the specified directory."
fi

exit 0

