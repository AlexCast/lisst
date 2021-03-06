% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/manipulate.R
\name{lgetvol}
\alias{lgetvol}
\title{Retrieve PSD in volume concentration}
\usage{
lgetvol(x)
}
\arguments{
\item{x}{A lisst object of type 'pnc' or 'csa'.}
}
\description{
The function converts the PSD in particle concentration (particle/L/µm) back 
to the original data in volume concentration (µL/L, ppm).
}
\details{
It merelly reverts the multiplication factors used by \code{lgetpnc}.
}
\examples{
l_vol <- lget(lgetpnc(donkmeer_pro), 'vol')
all.equal(l_vol, donkmeer_pro)

}
\seealso{
\code{\link{lget}} \code{\link{lgetraw}}, \code{\link{lgetcor}}, 
\code{\link{lgetcal}}, \code{\link{lgetvsf}}, \code{\link{lgetpnc}},
\code{\link{lgetcsa}}
}
