test_that("htmlwidget is created", {
  expect_s3_class(rscatter(rnorm(1e2), rnorm(1e2)), "htmlwidget")
})

test_that("data is scaled", {
  my_widget <- rscatter(runif(1e2, min = 0, max = 10),
                        runif(1e2, min = 0, max = 10))
  expect_lte(max(my_widget[["x"]][["points"]][["x"]]), 1)
  expect_gte(min(my_widget[["x"]][["points"]][["x"]]), -1)
})

test_that("passing data.frame is successful", {
  df <- data.frame(
    x = rnorm(1e2),
    y = rnorm(1e2)
  )
  my_widget <- rscatter("x", "y", data = df)
  expect_equal(cor(df[["x"]], my_widget[["x"]][["points"]][["x"]]), 1)
  expect_equal(cor(df[["y"]], my_widget[["x"]][["points"]][["y"]]), 1)
})
