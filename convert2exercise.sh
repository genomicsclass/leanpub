#!/bin/bash

awk '
BEGIN {start=0; flag=1}
{
if ($0 ~ "## Exercises") { start = 1 } 
if ($0 ~ "```r") flag=0
if (start && flag) 
	print "X>" $0
else 
	print $0
	if ($0 == "```") flag=1
}
' $1


