install.packages(‘tinytex’) tinytex::install_tinytex()output: \#Notes on
Generating output files for this. title: “RmarkdownTurtialNotes” author:
“Katie Temple” date: “2025-02-21” output: html_document: toc: true
toc_float: true word_document: pdf_document:

This is how you can include figures

``` r
library(ggplot2)
data("mtcars")
ggplot(mtcars, aes(x=wt, y=mpg))+
  geom_point()
```

![](RMarkDownTutorialNotes_kat_files/figure-gfm/Include%20Figure-1.png)<!-- -->
