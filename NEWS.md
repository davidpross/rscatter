# rscatter 0.2.0

- Upgrade underlying regl-scatterplot JavaScript library to v1.14.1.
- Add `showLegend` argument to build interactive legend when `colorBy` is categorical.
- Default normalization now preserves aspect ratio. Use `preserveAspect = FALSE` for old behavior where x and y are normalized independently.

# rscatter 0.1.1

- Allow named color vector for categorical color encoding
- Add [vignettes](https://davidpross.github.io/rscatter/articles/)

# rscatter 0.1.0

- Add [package documentation](https://davidpross.github.io/rscatter/)
- Add unit tests
- Enable color encoding based on values in the data for continuous and categorical data

# rscatter 0.0.1

- [MVP](https://en.wikipedia.org/wiki/Minimum_viable_product): create a scatterplot widget and statically specify color, size, and opacity for points.
