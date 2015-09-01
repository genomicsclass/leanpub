#!/bin/bash

printf "  *** knit file, fix latex, and move to  *** \n\n"

cd ../labs/$1


linetoadd="R markdown document for this section available \[here.]\(https\:\/\/github.com\/genomicsclass\/labs\/tree\/master\/$1\/$2.Rmd\)"

sed '/^## /a \
\'$'\n@@@@@@
' $2.Rmd | sed 's/@@@@@@/'"$linetoadd"'/' > $2-tmp.Rmd

Rscript --no-init-file -e "library(knitr); knit('$2-tmp.Rmd')"

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

rm $2-tmp.md
    
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
' $2.md > ../../leanpub/manuscript/$2.md

#rm $2.md
cd ../../leanpub

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

