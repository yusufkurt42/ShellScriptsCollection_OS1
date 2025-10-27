#this script copies files larger than 1MB to large_files
#others to small_files
#prints a report of file counts

#change current directory to the specified one if any
#and indicate to user. 
if [[ $# -ge 1 ]]; then
    cd $1
    echo "Operating on $1"
else
    echo "Operating on $PWD"
fi

#create directories to copy items 
mkdir large_files
mkdir small_files

#copy every file larger than 1MB to large_files

#find command iterates on every specifed file.
#-type -f specifies regular files.
#-size +1048576 specifies files larger than 1MB (1048576 is the number of bytes in 1MB).
#! -path "./large_files/*" excludes files under this path. -exec cp executes copy command.{} is the files iterated.
#and -v prints a line of information for every copied file we then pipe these lines to lcp_count.

find . -type f -size +1048576 ! -path "./large_files/*" -exec cp -v {} large_files \; > ../lcp_count

#copy every file smaller than 1MB to small_files

find . -type f -size -1048576 ! -path "./small_files/*" -exec cp -v {} small_files \; > ../scp_count

#compute file counts via line counts
#wc -l returns how many lines are in a file
lfilecount=$(wc -l < ../lcp_count)
sfilecount=$(wc -l < ../scp_count)
rm ../lcp_count
rm ../scp_count

#report to user how many files it copied
echo "$lfilecount files moved to large_files"
echo "$sfilecount files moved to small_files"

