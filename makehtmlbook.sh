#!/bin/bash

## run knit and add2book on each line
while read line; do
    if [ "$line" != "" ]; then
	if [[ $line != *"#"* ]]; then
	    if [[ $line != *"exercises"* ]]; then
		echo "\n\n --- now processing ---"
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

echo "\n\n --- updating index and final git push --- "

R CMD BATCH --no-save makehtmlindex.R
cd ../book
git commit -am "updating index"

git push

echo "\n\n *** done! ***"
