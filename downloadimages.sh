#!/bin/bash

cd manuscript
mkdir -p images/downloads
for f in *.md;
do
	result=$(grep "\!\[.*](http" $f | awk -F'[()]' '{print $2}')
	for theurl in $result
	do
 		cd images/downloads
		wget $theurl
	 	cd ../..
	 	filename="${theurl##*/}"
	 	filename="images/downloads/$filename"
	 	sed  "s#$theurl#$filename#" < $f > "$f.tmp"
	 	mv "$f.tmp" $f 
 	done
done
cd ..
git add manuscript/images/downloads/*
git commit -am "added imagess"; git push
