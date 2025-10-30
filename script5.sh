#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <directory_name> <prefix>"
    echo "Example: $0 docs proj_"
    exit 1
fi
cd $1
echo "Operating on $1"

# Export $2 as an environment variable to make it usable inside rename_logic
export prefix="$2"

# Define the logic to rename a file AND print its new name.
# '$0' is the file path find passes to sh (e.g., ./sub/notes.txt)
rename_logic='
    file="$0"
    dir=$(dirname -- "$file")
    base=$(basename -- "$file")
    new_base="$prefix$base"
    
    mv -- "$file" "$dir/$new_base" && echo "$new_base"
'

# Define the awk logic to build the summary string
summary_logic='
BEGIN { count=0; list="" }
{
    if (count==0) { list=$0 } else { list=list ", " $0 }
    count++
}
END {
    if (count>0) { print count " files renamed: " list }
    else { print "No *.txt files found to rename." }
}
'

# --- Main Script ---

# Check for subdirectories
if [ -n "$(find . -mindepth 1 -maxdepth 1 -type d)" ]; then
    #Ask if user wants to rename recursively
    read -p "Subdirectories found. Apply rename recursively? (y/n): " choice
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        echo "Renaming recursively..."
        #This part iterates through every file that contains ".txt" as their postfix 
        find . -type f -name "*.txt" -exec sh -c "$rename_logic" {} \; | awk "$summary_logic"
    else
        echo "Renaming in $1 only..."
        find . -maxdepth 1 -type f -name "*.txt" -exec sh -c "$rename_logic" {} \; | awk "$summary_logic"
    fi
else
    find . -maxdepth 1 -type f -name "*.txt" -exec sh -c "$rename_logic" {} \; | awk "$summary_logic"
fi
