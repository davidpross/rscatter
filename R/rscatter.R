#' Scalable scatterplot HTML widget
#'
#' Create interactive scalable scatterplot using `regl-scatterplot` JavaScript library.
#'
#' For categorical color encoding ensure the `colorBy` values are factor or character vectors.
#'
#' @param x numeric vector of x coordinates, OR column name for x in \code{data}
#' @param y numeric vector of y coordinates, OR column name for y in \code{data}
#' @param size point size; if not provided, a reasonable default is chosen based on the number of points
#' @param color point color, pass named color vector to map colors to categories
#' @param opacity point opacity, if not specified the opacity will vary with point density and zoom level
#' @param colorBy factor/chr/numeric vector to colorBy, OR column name for colorBy in \code{data}
#' @param data optional data.frame containing data to plot
#' @param showLegend logical; if \code{TRUE} and \code{colorBy} is categorical, render a legend using the color mapping
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
#' phi = seq(from = 0, to = 50, by = 1e-2)
#' fermat_spiral = data.frame(
#'  x = c(-sqrt(phi)*cos(phi), sqrt(phi)*cos(phi)),
#'  y = c(-sqrt(phi)*sin(phi), sqrt(phi)*sin(phi)),
#'  branch = rep(c("a", "b"), each = length(phi))
#'  )
#' rscatter("x", "y", size = 1.5, colorBy = "branch", data = fermat_spiral)
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
           showLegend = FALSE,
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
  x_range <- max(x) - min(x)
  y_range <- max(y) - min(y)

  points <- data.frame(
    x = if (x_range == 0) 0 else -1 + 2 * (x - min(x)) / x_range,
    y = if (y_range == 0) 0 else -1 + 2 * (y - min(y)) / y_range
  )

    if (is.null(size)) {
      n_points <- nrow(points)
      # Auto-size based on point count to balance visibility and overplotting
      # Buckets: <100 pts, 100-1K, 1K-10K, 10K-100K, 100K+
      breaks <- c(0, 100, 1000, 10000, 100000)
      sizes  <- c(8, 6, 4, 2, 1)
      size <- sizes[findInterval(n_points, breaks)]
    }

    if (!is.null(colorBy)) {
      if (anyNA(colorBy)) {
        stop("NAs not allowed in colorBy values")
      }
      levels <- NULL
      if (is.character(colorBy) || is.factor(colorBy)) {
        colorBy <- as.factor(colorBy)
        levels <- levels(colorBy)
        colorBy <- as.integer(colorBy) - 1L
      } else {
        colorBy <- (colorBy - min(colorBy)) / (max(colorBy) - min(colorBy))
      }
      points <- cbind(points, valueA = colorBy)
    }

    if (!is.null(color)) {
      # convert color to hex code
      color <- apply(col2rgb(color) / 255, 2, function(x) rgb(x[1], x[2], x[3]))
      if (!is.null(colorBy)) {
        if (length(color) < length(levels)) {
          stop("Not enough colors specified for number of categories")
        }
        if (!is.null(names(color))) {
          missing <- setdiff(levels, names(color))
          if (length(missing) != 0) {
            stop(paste0("Missing color assignment for: ",
                        paste(missing, collapse = ", ")))
          }
          color <- unname(color[levels])
        }
      }
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

    if (showLegend && !is.null(levels)) {
      labels <- if (!is.null(names(color))) names(color) else levels
      x[["options"]][["legend"]] <-
        lapply(seq_along(levels), function(i) {
          list(label = labels[[i]], color = color[[i]], index = i - 1L)
        })
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
