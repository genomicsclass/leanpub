#!/bin/bash

############################################
#
# usage:
#
# ./knit.sh course1 random_variables
#
############################################

printf "\n  *** knit *** \n\n"

Rscript --no-init-file -e "library(knitr); knit('$1.Rmd')"

printf "\n  *** done! *** \n\n"
