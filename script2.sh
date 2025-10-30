#!/bin/bash
#This script takes a directory as argument and in that directory:
#-creates a backup directory with a name that includes today's date
#-copies all .txt and .sh files from the given directory into that backup folder
#-and reports how many files were copied

#change current directory to the specified one if any
#and indicate to user. 
if [[ $# -ge 1 ]]; then
    cd $1
    echo "Operating on $1"
else
    echo "Operating on $PWD"
fi

#generate the name of the backup directory
backup_name=$(date +backup_%d-%m-%Y)
#create said directory
mkdir $backup_name

#copy every file ending with ".sh" to backup directory

#find command iterates on every specifed file:
# -type -f specifies regular files.
# -name '*.sh' specifies files ending with ".sh" .
# ! -path "./$backup_name/*" excludes files under this path. -exec cp executes copy command.{} is the files iterated.
#and -v prints a line of information for every copied file we then pipe these lines to count.

find . -type f -name '*.sh' ! -path "./$backup_name/*" -exec cp -v {} $backup_name \; >> ../count

#copy every file ending with ".txt" to backup directory

find . -type f -name '*.txt' ! -path "./$backup_name/*" -exec cp -v {} $backup_name \; >> ../count

#compute file count via line counts
#wc -l returns how many lines are in a file
filecount=$(wc -l < ../count)
rm ../count

#report to user how many files it copied to backup
echo "$filecount files copied into $backup_name"
