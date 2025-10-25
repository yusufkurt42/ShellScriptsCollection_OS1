backup_name=$(date +backup_%d-%m-%Y)
mkdir $backup_name
count=$(cp -iv *.txt $backup_name | wc -l)
count=$(expr $count + $(cp -iv *.sh $backup_name | wc -l))
echo $count files copied into $backup_name