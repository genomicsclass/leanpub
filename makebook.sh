#!/bin/bash

## Run makechapter on each line
while read line; do
	if [ "$line" != "" ]; then
		if [[ $line != *"#"* ]]; then
			set -- $line;
			./makechapter.sh $1 $2; 
		fi
	fi
done < filenames.txt 


## create the Book.txt file
while read line; do
	if [ "$line" != "" ]; then
		if [[ $line != *"#"* ]]; then
			set -- $line;
			echo $2.md;
		else
			echo $line;
		fi
	else
		printf "\n";
	fi
done < filenames.txt > manuscript/Book.txt

./downloadimages.sh 

git commit -m "editing Book.txt" manuscript/Book.txt
git push 
