#' Create bsts model
#'
#' @param .data training set
#' @param spec \code{cbar.model.spec} object
#' @param ... params for \code{bsts_spec_static}
#' @return \code{bsts} which is a bsts model
#' @importFrom bsts bsts
#' @references Scott, S. L., & Varian, H. R. (2014). Predicting the present with
#'   bayesian structural time series. International Journal of Mathematical
#'   Modelling and Numerical Optimisation, 5(1-2), 4-23.
bsts_model <- function(.data,
                       spec = NULL,
                       ...) {
  if (is.null(spec)) {
    spec <- bsts_spec_static(.data, ...)
  }
  stopifnot(inherits(spec, "cbar.model.spec"))
  class(spec) <- "list"
  do.call(bsts::bsts, spec)
}

#' Specify bsts model for static linear regression
#'
#' @param .data time-series data to be trained
#' @param sigma_guess an argument for \code{bsts::bsts}
#' @param upper_limit an argument for \code{bsts::bsts}
#' @param sd_prior_sample_size an argument for \code{bsts::bsts}
#' @param expected_model_size an argument for \code{bsts::bsts}
#' @param expected_r2 an argument for \code{bsts::bsts}
#' @param prior_df an argument for \code{bsts::bsts}
#' @param niter an argument for \code{bsts::bsts}
#' @param ping an argument for \code{bsts::bsts}
#' @param model_options an argument for \code{bsts::bsts}
#' @param nseasons number of seasons
#' @param ... params for \code{bsts_model}
#' @return \code{cbar.model.spec} object for model specification
#' @importFrom bsts AddLocalLevel BstsOptions
#' @importFrom dplyr select
#' @importFrom stats sd
#' @importFrom Boom SdPrior
bsts_spec_static <- function(.data,
                             sigma_guess = NULL,
                             upper_limit = NULL,
                             sd_prior_sample_size = 32,
                             expected_model_size = 3,
                             expected_r2 = 0.8,
                             prior_df = 50,
                             niter = 1000,
                             ping = 0,
                             model_options = NULL,
                             nseasons = 0,
                             ...) {
  y <- .data[, 2]

  if (is.null(sigma_guess)) {
    sigma_guess <- 0.01 * sd(y, na.rm = TRUE)
  }
  stopifnot(sigma_guess > 0)

  if (is.null(upper_limit)) {
    upper_limit <- sd(y, na.rm = T)
  }
  stopifnot(upper_limit > 0)

  if (is.null(model_options)) {
    model_options <- bsts::BstsOptions(save.prediction.errors = TRUE)
  }
  stopifnot(inherits(model_options, "BstsOptions"))

  sd_prior <- Boom::SdPrior(sigma.guess = sigma_guess,
                            upper.limit = upper_limit,
                            sample.size = sd_prior_sample_size)

  ss <- bsts::AddLocalLevel(list(), y, sigma.prior = sd_prior)

  if (nseasons > 0) {
    ss <- bsts::AddSeasonal(ss, y, nseasons = nseasons)
  }

  structure(list(formula = paste0(names(.data)[2], sep = " ~ ."),
                 data = dplyr::select(.data, -datetime),
                 state.specification = ss,
                 expected.model.size = expected_model_size,
                 expected.r2 = expected_r2,
                 prior.df = prior_df,
                 niter = niter,
                 ping = ping,
                 model.options = model_options,
                 ...),
            class = "cbar.model.spec")
}

# reserved function
bsts_spec_dynamic <- function() {
  stop("Not implemented yet")
}
