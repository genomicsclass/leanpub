#!/bin/bash

cd manuscript
mkdir -p images/downloads
for f in *.md;
do
	## Find all the figures that are a url
	## form is ![foo](http::bar)
	## awk extracts just the link
	result=$(grep "\!\[.*](http" $f | awk -F'[()]' '{print $2}')
	for theurl in $result
	do
		##filename is just the last part of the url
 		filename="${theurl##*/}"
	 	cd images/downloads
		if [ ! -f $filename ]; then
  			wget $theurl
	 	fi
		cd ../..
	 	filename="images/downloads/$filename"
		## now that we have downloaded, replace 
	 	sed  "s#$theurl#$filename#" < $f > "$f.tmp"
	 	mv "$f.tmp" $f 
 	done
done
cd ..
git add manuscript/images/downloads/*
git commit -am "adding images"; git push
