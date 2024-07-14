---
title: "WeibullR.plotly: Interactive Weibull Probability Plots"
tags:
  - R
  - life data analysis
  - Weibull analysis
  - reliability
  - plotly
authors:
  - name: Paul B. Govan
    orcid: 0000-0002-1821-8492
    affiliation: 1
affiliations:
  - name: Senior Reliability Systems Engineer, GE Aerospace
    index: 1
date: 11 July 2024
bibliography: paper.bib
---

## Statement of Need

Life data analysis examines the behavior of systems over time. Often termed Weibull data analysis, due to the common use of the Weibull distribution, this field involves iterative data wrangling, modeling, and visualization. Interactive Weibull modeling offers numerous advantages, such as the ability to explore subsamples and uncover hidden data structures. `WeibullR.plotly` [@WeibullRplotly] is an open-source software package designed for creating interactive Weibull Probability Plots. It aims to provide more flexibility for exploratory Weibull analysis than traditional static plotting. The primary users of this project are reliability engineers and university students specializing in reliability engineering.

## Description

`WeibullR.plotly` is developed in R [@R], leveraging `WeibullR` [@WeibullR], a package dedicated to Life Data Analysis, and `plotly` [@plotly], an interactive web-based graphing library.

### Usage

#### Weibull Probability Plots 

Fit a `wblr` object to a life data set using the `WeibullR` package, then generate plots with the `plotly_wblr` function.

``` r
plotly_wblr(obj, main='Weibull Probability Plot', xlab='Years', ylab='Failure Probability', confCol='blue', signif=4, grid=FALSE)
```

![](https://github.com/paulgovan/WeibullR.plotly/blob/main/ReadMe_files/figure-gfm/unnamed-chunk-5-1.png?raw=true)<!-- -->

#### Contour Plots

Create contour plots using the `plotly_contour` function with a `wblr` object.

``` r
plotly_contour(obj, main='Weibull Contour Plot', col='red', signif=4, grid=FALSE)
```

![](https://github.com/paulgovan/WeibullR.plotly/blob/main/ReadMe_files/figure-gfm/unnamed-chunk-6-1.png?raw=true)<!-- -->

#### Customization Options

Customize labels, colors, and grids to tailor the plots to specific needs. Refer to the package documentation for a comprehensive list of options.

### Documentation and Resources

The project documentation provides:

- **Installation Instructions**: Guidance on installing `WeibullR.plotly` and its dependencies.
- **Function Examples**: Demonstrations of how to use the package functions.
- **Unit Tests**: Ensuring code reliability and performance.
- **Further Learning Resources**:
  - `WeibullR.learnr` [@WeibullRlearnr]: An interactive introduction to Life Data Analysis.
  - `WeibullR.shiny` [@WeibullRshiny]: A shiny [@shiny] web application for Life Data Analysis that     leverages `WeibullR.plotly`.

### Contribution and Community Engagement

Engineers and analysts are encouraged to use and contribute to the project. The repository includes a Contributor Code of Conduct. Issues and feature requests can be submitted through Issues or Pull Requests.

## References
