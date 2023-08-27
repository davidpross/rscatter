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
<img width="534" alt="scatter plot of 2D normally distributed points" src="https://github.com/davidpross/rscatter/assets/48140684/ec235af9-820c-4d35-9166-f2c366c42b2d">
