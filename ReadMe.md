
# WeibullR.plotly

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/WeibullR.plotly)](https://CRAN.R-project.org/package=WeibullR.plotly)
![](http://cranlogs.r-pkg.org/badges/grand-total/WeibullR.plotly)
![](http://cranlogs.r-pkg.org/badges/WeibullR.plotly) [![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![DOI](https://zenodo.org/badge/639144870.svg)](https://zenodo.org/badge/latestdoi/639144870)
<!-- badges: end -->

Build interactive Weibull Probability Plots with WeibullR, an R package
for Weibull analysis, and plotly, an interactive web-based graphing
library.

# Getting Started

To install WeibullR.plotly in R:

``` r
install.packages('WeibullR.plotly')
```

Or install the development version:

``` r
devtools::install_github('paulgovan/weibullr.plotly')
```

# Basic Examples

To build a probability plot, first fit a `wblr` object using the
`WeibullR` package and then use `plotly_wblr` to build the plot.

``` r
library(WeibullR)
library(WeibullR.plotly)
failures<-c(30, 49, 82, 90, 96)
obj<-wblr.conf(wblr.fit(wblr(failures)))
plotly_wblr(obj)
```

![](ReadMe_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

To build a contour plot, use the `plotly_contour` function. Note that
contour plots are only available where `method.fit='mle'` and
`method.conf='lrb'`.

``` r
obj<-wblr.conf(wblr.fit(wblr(failures), method.fit = 'mle'), method.conf = 'lrb')
plotly_contour(obj)
```

![](ReadMe_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

# Customization

WeibullR.plotly has several customization options.

``` r
plotly_wblr(obj, main='Weibull Probability Plot', xlab='Years', ylab='Failure Probability', col='blue', signif=4, grid=FALSE)
```

![](ReadMe_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
plotly_contour(obj, main='Weibull Contour Plot', col='red', signif=4, grid=FALSE)
```

![](ReadMe_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->

## Code of Conduct

Please note that the WeibullR.plotly project is released with a [Contributor Code of Conduct](https://paulgovan.github.io/WeibullR.plotly/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.

# More Resources

For an interactive introduction to Life Data Analysis, check out
[WeibullR.learnr](https://paulgovan.github.io/WeibullR.learnr/)

To try WeibullR.plotly in a Shiny app, check out
[WeibullR.shiny](https://paulgovan.github.io/WeibullR.shiny/)
