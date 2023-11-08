#' Scalable scatterplot HTML widget
#'
#' Create interactive scalable scatterplot using `regl-scatterplot` JavaScript library.
#'
#' For categorical color encoding ensure the `colorBy` values are factor or character vectors.
#'
#' @param x numeric vector of x coordinates, OR column name for x in \code{data}
#' @param y numeric vector of y coordinates, OR column name for y in \code{data}
#' @param size point size
#' @param color point color
#' @param opacity point opacity
#' @param colorBy factor/chr/numeric vector to colorBy, OR column name for colorBy in \code{data}
#' @param data optional data.frame containing data to plot
#' @param width fixed width of canvas in pixels (default is resizable)
#' @param height fixed height of canvas in pixels (default is resizable)
#' @param elementId specify id for containing div
#'
#' @import htmlwidgets
#'
#' @examples
#' data(quakes)
#' rscatter(quakes$long, quakes$lat, size = 10, colorBy = quakes$depth)
#'
#' # Or pass data.frame
#' phi = seq(from = 0, to = 100, by = 3e-2)
#' fermat_spiral = data.frame(
#'  x = c(-sqrt(phi)*cos(phi), sqrt(phi)*cos(phi)),
#'  y = c(-sqrt(phi)*sin(phi), sqrt(phi)*sin(phi)),
#'  branch = rep(c("a", "b"), each = length(phi))
#'  )
#' rscatter("x", "y", colorBy = "branch", data = fermat_spiral)
#'
#' @export
rscatter <-
  function(x,
           y,
           size = NULL,
           color = NULL,
           opacity = NULL,
           colorBy = NULL,
           data = NULL,
           width = NULL,
           height = NULL,
           elementId = NULL) {
    if (!is.null(data)) {
      x <- data[, x]
      y <- data[, y]
      if (!is.null(colorBy)) {
        colorBy <- data[, colorBy]
      }
    }

    if (!is.numeric(x) || !is.numeric(y)) {
      stop("x and y coordinates must be numeric")
    }

    if (!is.null(colorBy) && !is.numeric(colorBy) &&
        !is.factor(colorBy) && !is.character(colorBy)) {
      stop("colorBy must be numeric, character, or factor")
    }

    # scale points to between -1 and 1
    points <-
      data.frame(x = -1 + 2 * (x - min(x)) / (max(x) - min(x)),
                 y = -1 + 2 * (y - min(y)) / (max(y) - min(y)))

    if (!is.null(colorBy)) {
      if (anyNA(colorBy)) {
        stop("NAs not allowed in colorBy values")
      }
      if (is.character(colorBy) || is.factor(colorBy)) {
        colorBy <- as.integer(as.factor(colorBy)) - 1L
      } else {
        colorBy <- (colorBy - min(colorBy)) / (max(colorBy) - min(colorBy))
      }
      points <- cbind(points, valueA = colorBy)
    }

    if (!is.null(color)) {
      # convert color to hex code
      color <- do.call(rgb, as.list(col2rgb(color)[, 1] / 255))
    } else {
      if (!is.null(colorBy)) {
        if (is.integer(colorBy)) {
          # categorical color encoding
          n <- length(unique(points[["valueA"]]))
          if (n < 9) {
            color <- okabe_ito[1:n]
          } else {
            if (n > length(glasbey_light)) {
              stop("Too many unique values to encode color categorically.")
            }
            color <- glasbey_light[1:n]
          }
        } else {
          # continuous color encoding
          color <- viridis
        }
      } else {
        color <- "#0072B2"
      }
    }

    # forward points and options using x
    x <- list(points = points,
              options = list(
                size = size,
                color = color,
                opacity = opacity
              ))

    if (!is.null(colorBy)) {
      x[["options"]][["colorBy"]] <- "valueA"
    }

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
