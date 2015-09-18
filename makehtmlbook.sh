#!/bin/bash

## run knit and add2book on each line
while read line; do
    if [ "$line" != "" ]; then
	if [[ $line != *"#"* ]]; then
	    if [[ $line != *"exercises"* ]]; then
		echo " --- now processing ---"
		echo $line
		echo ""
		cd ../book
		set -- $line;
		./knit.sh $1 $2;
		./add2book.sh $1 $2;
		cd ../leanpub
	    fi
	fi
    fi
done < filenames.txt 
