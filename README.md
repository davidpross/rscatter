# rscatter
An R package that creates an [htmlwidget](https://www.htmlwidgets.org/) wrapping the [regl-scatterplot](https://github.com/flekschas/regl-scatterplot) JavaScript library. Create pan-and-zoomable scatterplots that scale to millions of points and display in the RStudio viewer, R Markdown, Quarto, and Shiny.

```R
# Install remotes package if necessary
if (!require("remotes")) {
  install.packages("remotes")
}

remotes::install_github("davidpross/rscatter", upgrade = FALSE)
library(rscatter)

rscatter(rnorm(1e4), rnorm(1e4))
```
<img width="534" alt="plot" src="https://github.com/davidpross/rscatter/assets/48140684/1fcfade1-3ebf-4576-aaa1-c770a878b15f">
