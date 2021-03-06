% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/process.R
\name{lstat}
\alias{lstat}
\alias{mean.lisst}
\alias{median.lisst}
\alias{sd.lisst}
\title{Descriptive statistics for lisst objects}
\usage{
lstat(x, brks, fun = "mean", ...)

\method{mean}{lisst}(x, ...)

\method{median}{lisst}(x, ...)

\method{sd}{lisst}(x, ...)
}
\arguments{
\item{x}{A lisst object.}

\item{brks}{A vector with the breaks (intervals) for the aggregation. See 
details.}

\item{fun}{A function to perform the aggregation (mean, median, sd). 
Defaults to mean.}

\item{...}{Arguments to be passed to aggregation functions.}
}
\description{
The functions calculate the average or the median per variable of a lisst 
object, for the whole data or in intervals. The dispersion of the dataset or
intervals is also retrieved and stored.
}
\details{
The breaks (intervals) are passed directly to the subset function, so must 
now be supplied in final form.

The resulting time indexing will always be the average of the time of the 
imput records. In the case of aggregation by depth, time indexing will most
likelly not be regular or monotonic. In these cases, plot functions that can
have different ordinates should always be by 'depth'.
}
\section{Methods (by generic)}{
\itemize{
\item \code{mean}: Compute the mean for lisst objects

\item \code{median}: Compute the median for lisst objects

\item \code{sd}: Compute the median for lisst objects
}}

\examples{
mean(donkmeer_bin)

median(donkmeer_bin)

sd(donkmeer_bin)

}
