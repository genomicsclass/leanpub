x <- readLines("filenames.txt")
x <- x[x != ""]
chapter <- substr(x,1,2) == "##"
file <- "../book/index.md"
simpleCap <- function(x) {
  paste0(toupper(substring(x, 1, 1)), substring(x, 2))
}
pre <- readLines("../book/preamble.md")
post <- readLines("../book/postscript.md")
labs <- "https://github.com/genomicsclass/labs/blob/master/"
for (i in seq_along(pre)) write(pre[i], file=file, append=i > 1)  
for (i in seq_along(x)) {
  if (chapter[i]) {
    write(paste0("\n",x[i]), file=file, append=TRUE)
  } else {
    s <- strsplit(x[i], " ")[[1]]
    if (length(s) == 2) {
      title <- simpleCap(gsub("_"," ",s[2]))
    } else {
      stopifnot(length(s) == 3)
      title <- gsub("_"," ",s[3])
    }
    out <- paste0("- [",title,"](pages/",s[1],".html)")
    if (!grepl("exercises",s[1])) {
      out <- paste0(out," [Rmd](",labs,s[1],"/",s[2],".Rmd)")
    }
    write(out, file=file, append=(i > 1))
  }
}
for (i in seq_along(post)) write(post[i], file=file, append=TRUE)
