#' Scalable scatterplot HTML widget
#'
#' Create interactive scalable scatterplot using `regl-scatterplot` JavaScript library.
#'
#' @param x numeric vector of x coordinates, OR variable name for x in \code{data}
#' @param y numeric vector of y coordinates, OR variable name for y in \code{data}
#' @param data optional data.frame containing data to plot
#'
#' @import htmlwidgets
#'
#' @export
rscatter <- function(x, y, data = NULL, width = NULL, height = NULL, elementId = NULL) {

  if (!is.null(data)) {
    x <- data[, deparse(substitute(x))]
    y <- data[, deparse(substitute(y))]
  }
  
  if (!is.numeric(x) || !is.numeric(y)) {
    stop("x and y coordinates must be numeric")
  }
  
  points <- data.frame(x = -1 + 2 * (x - min(x)) / (max(x) - min(x)),
                       y = -1 + 2 * (y - min(y)) / (max(y) - min(y)))

  # forward options using x
  x <- list(
    points = points,
    options = NULL
  )

  # create widget
  htmlwidgets::createWidget(
    name = 'rscatter',
    x,
    width = width,
    height = height,
    package = 'rscatter',
    elementId = elementId
  )
}

#' Shiny bindings for rscatter
#'
#' Output and render functions for using rscatter within Shiny
#' applications and interactive Rmd documents.
#'
#' @param outputId output variable to read from
#' @param width,height Must be a valid CSS unit (like \code{'100\%'},
#'   \code{'400px'}, \code{'auto'}) or a number, which will be coerced to a
#'   string and have \code{'px'} appended.
#' @param expr An expression that generates a rscatter
#' @param env The environment in which to evaluate \code{expr}.
#' @param quoted Is \code{expr} a quoted expression (with \code{quote()})? This
#'   is useful if you want to save an expression in a variable.
#'
#' @name rscatter-shiny
#'
#' @export
rscatterOutput <- function(outputId, width = '100%', height = '400px'){
  htmlwidgets::shinyWidgetOutput(outputId, 'rscatter', width, height, package = 'rscatter')
}

#' @rdname rscatter-shiny
#' @export
renderRscatter <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  htmlwidgets::shinyRenderWidget(expr, rscatterOutput, env, quoted = TRUE)
}
