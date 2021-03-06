% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/abs-analytical.R
\name{summarise_pred_error}
\alias{summarise_pred_error}
\title{Summarise prediction error of model}
\usage{
summarise_pred_error(.cbar, .session = "measurement")
}
\arguments{
\item{.cbar}{\code{cbar} object}

\item{.session}{names of sessions, which is NULL by default}
}
\value{
\code{data.frame} with prediction errors
}
\description{
This function uses absolute difference and mean absolute percentage error
for summarising prediction errors
}
