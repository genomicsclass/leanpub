#!/bin/bash

printf "  *** knit file, fix latex, and move to  *** \n\n"

cd ../labs/$1

## Before we knit we create  temporary file
## and add a link to the Rmd markdown after every subsection
## but only if not an exercise file

if [[ ! "$2" =~ "_exercises" ]]
then
	linetoadd="R markdown document for this section available \[here]\(https\:\/\/github.com\/genomicsclass\/labs\/tree\/master\/$1\/$2.Rmd\)."

	sed '/^## /a \
\'$'\n@@@@@@
' $2.Rmd | sed 's/@@@@@@/'"$linetoadd"'/' > $2-tmp.Rmd
else
	cp $2.Rmd $2-tmp.Rmd
fi

## Now we knit
Rscript --no-init-file -e "library(knitr); knit('$2-tmp.Rmd')"

### Here we are converting the $ used by latex to $$ used by jekyll

sed 's/\$\$/@@@@/g' $2-tmp.md |
    sed 's/ \$/ @@@@/g' |
    sed 's/\$ /@@@@ /g' |
    sed 's/\$\./@@@@\./g' |
    sed 's/\$,/@@@@,/g' |
    sed 's/\$:/@@@@:/g' |
    sed 's/\$-/@@@@-/g' |
    sed 's/(\$/(@@@@/g' |
    sed 's/\$)/@@@@)/g' |
    sed 's/^\$/@@@@/g' |
    sed 's/\$$/@@@@/g' |
    sed 's/:\$/:@@@@/g' |
    sed 's/@@@@/\$\$/g' |
    sed 's/\$\$/{\$\$}/g' |
    sed 's/(figure\//(images\/R\//g' |
    sed 's/\"figure\//\"images\/R\//g'> $2.md

rm $2-tmp.Rmd
rm $2-tmp.md
  
### Here we are converting the $$ used by latex and jekyll to
### in {$$} {\$$} used by leanpub
  
awk '
BEGIN {count = 0;}
{
gsub(/\{\$\$\}/,"@@@@\{\$\$\}@@@@");
n=split($0,a,"@@@@")
line = "";
for (i=1;i<=n;++i){
	if(a[i]=="\{\$\$\}") {
		++count;
		if(count==2) { 
			a[i] = "\{/\$\$\}"; 
			count=0
		}
	}
	line=(line a[i])
}
print line;
}
' $2.md > $2-tmp.md

if [[ "$2" =~ "_exercises" ]]
then
	../../leanpub/convert2exercise.sh $2-tmp.md > ../../leanpub/manuscript/$2.md
else
	mv $2-tmp.md ../../leanpub/manuscript/$2.md
fi

rm $2.md

cd ../../leanpub


## move the images into leanpub directory and add to github

imgcount=`ls -1 ../labs/$1/figure/$2* 2> /dev/null | wc -l`
 
if [ $imgcount -gt 0 ]
then
mv ../labs/$1/figure/$2* manuscript/images/R/
fi


printf "  *** add new files to BOOK, commit and push *** \n\n"

cd manuscript
git add $2.md

if [ $imgcount -gt 0 ]
then
git add images/R/$2*
fi

git commit -am "adding $2 to book"

printf "\n  *** done! *** \n\n"

