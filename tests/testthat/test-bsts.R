context("bsts")

.data <- iris[, 1:4]
datetime <- seq(from = Sys.time(), length.out = nrow(.data), by = "mins")
.data <- cbind(datetime = datetime, .data)

test_that("bsts_spec_static", {
  .spec <- bsts_spec_static(.data)
  expect_true(inherits(.spec, "cbar.model.spec"))
})

test_that("bsts_model", {
  pre_period <- c(1, 100)
  post_period <- c(101, 150)

  training_data <- .data
  training_data[post_period[1]:post_period[2], 1] <- NA

  .model <- bsts_model(.data)
  expect_true(inherits(.model, "bsts"))

  names(.model)
  .model$coefficients
  .model$state.contributions[1000, 1:2, 145:150]
})
