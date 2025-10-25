#
# First Problem
#
echo "******* This program takes a file and prints the top 3 most frequent words in the file ******"

if [ $# -eq 0 ]   # 
then
	echo "Please give a file name !! "
	echo "Usecase: $0 <file_name>"
fi

file=$1

if [ ! -f "$file" ]; then
  echo "File not found!"
  exit 1
fi

cat "$file" |                        # Print the content of the file
tr -cs '[:alpha:]' '\n' |            # Replace non-alphabetic characters with newlines (split words)
tr '[:upper:]' '[:lower:]' |         # Convert all letters to lowercase (case-insensitive)
grep -v '^$' |                       # Remove empty lines
sort |                               # Sort words alphabetically (required for uniq)
uniq -c |                            # Count occurrences of each unique word (uniq yalnızca yan yana duran (ardışık) aynı satırları fark eder.)
sort -nr |                                   # Sort by frequency (numeric, descending order)
head -3 |                                    # Take the top 3 most frequent words
awk '{print NR ". " $2 " – " $1}'            # Format output: "rank. word – count"

 #  awk her satırı sütunlara ayırır ve üzerinde işlem yapabilir
 #  $1 → satırdaki birinci sütun (yani kelime sayısı)
 #  $2 → satırdaki ikinci sütun (yani kelimenin kendisi)
 #  NR → Record Number yani satır numarası (1, 2, 3, …)
