% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inference.R
\name{point_prediction}
\alias{point_prediction}
\title{Get point prediction from posterior means and response trajectories}
\usage{
point_prediction(y_hat, .posterior_mean, alpha = 0.05)
}
\arguments{
\item{y_hat}{response trajectories}

\item{.posterior_mean}{posterior mean values}

\item{alpha}{alpha}
}
\value{
\code{data.frame} for predicted values
}
\description{
Get point prediction from posterior means and response trajectories
}
