#!/bin/bash

printf "  *** knit file, fix latex, and move to  *** \n\n"

cd ../labs/$1
Rscript --no-init-file -e "library(knitr); knit('$2.Rmd')"

sed 's/\$\$/@@@@/g' $2.md |
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
    sed 's/@@@@/\$\$/g' |
    sed 's/\$\$/{\$\$}/g' |
    sed 's/(figure\//(images\//g' > $2.md
    
awk '
BEGIN {count = 0;}
{
gsub(/\{\$\$\}/," \{\$\$\} ");
for (i=1;i<=NF;++i){ 
	if($i=="\{\$\$\}") {
		++count;
		if(count==1){ printf "%s", "\{\$\$\}"} else { printf "%s", "\{/\$\$\}"; count=0} 
} else {printf "%s ", $i}
}
printf "\n";
} 
' $2.md > ../../leanpub/manuscript/$2.md

rm $2.md
cd ../../leanpub

imgcount=`ls -1 ../labs/$1/figure/$2* 2> /dev/null | wc -l`
 
if [ $imgcount -gt 0 ]
then
mv ../labs/$1/figure/$2* manuscript/images/
fi


printf "  *** add new files to BOOK, commit and push *** \n\n"

cd manuscript
git add $2.md

if [ $imgcount -gt 0 ]
then
git add images/$2*
fi

git commit -am "adding $2 to book"

printf "\n  *** done! *** \n\n"

