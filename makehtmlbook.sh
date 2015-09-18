#!/bin/bash

## Run makechapter on each line
while read line; do
    if [ "$line" != "" ]; then
	if [[ $line != *"#"* ]]; then
	    if [[ $line != *"exercises"* ]]; then
		cd ../book
		./knit.sh $1 $2;
		./add2book.sh $1 $2;
		cd ../leanpub
	    fi
	fi
    fi
done < filenames.txt 
