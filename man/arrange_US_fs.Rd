% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/arrange_US_fs.R
\name{arrange_US_fs}
\alias{arrange_US_fs}
\title{Arrange all listed firm's financial statement data in US Markets.}
\usage{
arrange_US_fs()
}
\value{
arranged financial statement data by account
}
\description{
You should be execute get_US_fs function first to download financial statement data.
It will arrange fs data by account for list type, and save csv file.
}
\examples{
\dontrun{
 US_fs = arrange_US_fs()
 }
}
