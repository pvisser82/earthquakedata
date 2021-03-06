% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/timeline.R
\docType{data}
\name{GeomTimeLineLabel}
\alias{GeomTimeLineLabel}
\title{GeomTimeLineLabel proto}
\format{An object of class \code{GeomTimeLineLabel} (inherits from \code{Geom}, \code{ggproto}) of length 6.}
\usage{
GeomTimeLineLabel
}
\description{
This geom is responsible for drawing the labels on the timeline. The number of labels are set
using the n_max parameter. The function will retrieve the n_max number of highest magnitudes
using the setup_data function and add the label to those earthquakes.
}
\keyword{datasets}
