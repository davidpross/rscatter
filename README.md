# Introducing rscatter
An R package that creates an [htmlwidget](https://www.htmlwidgets.org/) wrapping the [regl-scatterplot](https://github.com/flekschas/regl-scatterplot) JavaScript library. Create pan-and-zoomable scatterplots—with the [rscatter](https://davidpross.github.io/rscatter/reference/rscatter.html) function—that scale to millions of points and display in the RStudio viewer, R Markdown, Quarto, and Shiny. View additional documentation and function references at https://davidpross.github.io/rscatter/.

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

# Shiny example
You can integrate rscatter in Shiny apps; a sample Fermat spiral app lives at `inst/shiny-examples/spiral`. Run it from R with:

```r
shiny::runApp(system.file("shiny-examples/spiral", package = "rscatter"))
```

# Related Tools
- [Jupyter Scatter](https://jupyter-scatter.dev/) is a widget for use with interactive computational notebooks in the Python world, written by the creator of [`regl-scatterplot`](https://github.com/flekschas/regl-scatterplot).
- [ScatterD3](https://juba.github.io/scatterD3/) is another HTML widget for making scatterplots.
