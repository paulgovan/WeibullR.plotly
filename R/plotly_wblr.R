#' Interactive Probability Plot.
#'
#' @param wblr_obj An object of class 'wblr'.
#' @param susp An optional numeric vector of suspension data.
#' @param showConf Show the confidence bounds (TRUE) or not (FALSE).
#' @param showSusp Show the suspensions plot (TRUE) or not (FALSE).
#' @param showRes Show the results table (TRUE) or not (FALSE).
#' @param showGrid Show grid (TRUE) or hide grid (FALSE).
#' @param main Main title.
#' @param xlab X-axis label.
#' @param ylab Y-axis label.
#' @param probCol Color of the probability values.
#' @param fitCol Color of the model fit.
#' @param confCol Color of the confidence bounds.
#' @param intCol Color of the intervals for interval censored models.
#' @param gridCol Color of the grid.
#' @param signif Significant digits of results
#' @return The function returns no value.
#' @examples
#' library(WeibullR)
#' library(WeibullR.plotly)
#' failures<-c(30, 49, 82, 90, 96)
#' obj<-wblr.conf(wblr.fit(wblr(failures)))
#' plotly_wblr(obj)
#' @import WeibullR
#' @import plotly
#' @importFrom graphics text
#' @importFrom stats runif qnorm
#' @export

plotly_wblr <- function(wblr_obj,
                        susp = NULL,
                        showConf = TRUE,
                        showSusp = TRUE,
                        showRes = TRUE,
                        showGrid = TRUE,
                        main = "Probability Plot",
                        xlab = "Time to Failure",
                        ylab = "Probability",
                        probCol = "black",
                        fitCol = "black",
                        confCol = "black",
                        intCol = "black",
                        gridCol = "lightgray",
                        signif = 3) {

  # Validate inputs
  validate_inputs <- function() {
    if (!identical(class(wblr_obj), "wblr")) {
      stop("Argument 'wblr_obj' is not of class 'wblr'.")
    }
    if (!is.null(susp) && !is.numeric(susp)) {
      stop("Argument 'susp' must be a numeric vector.")
    }
  }
  validate_inputs()

  ## Begin extracting data from the wblr object

  # Check for intervals and get the probability values
  if(wblr_obj$interval==0) {
    time <- wblr_obj$data$dpoints$time
    time_sd <- round(time, signif)
    ints <- NULL
    probability <- wblr_obj$data$dpoints$ppp
    prob_sd <- round(probability, signif)
  }
  else if(wblr_obj$interval>0) {
    time <- (wblr_obj$data$dlines$t2+wblr_obj$data$dlines$t1)/2
    time_sd <- round(time, signif)
    ints <- log(wblr_obj$data$dlines$t2-wblr_obj$data$dlines$t1)
    probability <- wblr_obj$data$dlines$ppp
    prob_sd <- round(probability, signif)
  }

  # Check for a fit method
  if(is.null(wblr_obj$fit)) {
    datum <- NULL
    unrel <- NULL
    lower <- NULL
    upper <- NULL
  }

  # Check for confidence bounds
  else if(is.null(wblr_obj$fit[[1]]$conf)) {
    datum <- NULL
    unrel <- NULL
    lower <- NULL
    upper <- NULL
  }

  else if(showConf==FALSE) {
    datum <- wblr_obj$fit[[1]]$conf[[1]]$bounds$Datum
    unrel <- wblr_obj$fit[[1]]$conf[[1]]$bounds$unrel
    lower <- NULL
    upper <- NULL
    datum_sd <- round(datum, signif)
    unrel_sd <- round(unrel, signif)
    lower_sd <- NULL
    upper_sd <- NULL
  }

  # Get the fit and upper/lower confidence bounds
  else {
    datum <- wblr_obj$fit[[1]]$conf[[1]]$bounds$Datum
    unrel <- wblr_obj$fit[[1]]$conf[[1]]$bounds$unrel
    lower <- wblr_obj$fit[[1]]$conf[[1]]$bounds$Lower
    upper <- wblr_obj$fit[[1]]$conf[[1]]$bounds$Upper
    datum_sd <- round(datum, signif)
    unrel_sd <- round(unrel, signif)
    lower_sd <- round(lower, signif)
    upper_sd <- round(upper, signif)
  }

  # Check the distribution and transform probability/unreliability
  if(is.null(wblr_obj$fit)) {
    param1 <- NULL
    param2 <- NULL
    param3 <- NULL
    paramval1 <- NULL
    paramval2 <- NULL
    paramval3 <- NULL
    prob_trans <- NULL
    unrel_trans <- NULL
  }
  else if(wblr_obj$fit[[1]]$options$dist=='lognormal') {
    param1 <- 'Mulog'
    param2 <- 'Sigmalog'
    param3 <- NULL
    paramval1 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[1]), signif)
    paramval2 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[2]), signif)
    paramval3 <- NULL
    prob_trans <- qnorm(probability)
    unrel_trans <- qnorm(unrel)
  }
  else if(wblr_obj$fit[[1]]$options$dist=='weibull'){
    param1 <- 'Beta'
    param2 <- 'Eta'
    param3 <- NULL
    paramval1 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[2]), signif)
    paramval2 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[1]), signif)
    paramval3 <- NULL
    prob_trans <- log(1/(1-probability))
    unrel_trans <- log(1/(1-unrel))
  }
  else if(wblr_obj$fit[[1]]$options$dist=='weibull3p'){
    param1 <- 'Beta'
    param2 <- 'Eta'
    param3 <- 'Gamma'
    paramval1 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[2]), signif)
    paramval2 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[1]), signif)
    paramval3 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[3]), signif)
    prob_trans <- log(1/(1-probability))
    unrel_trans <- log(1/(1-unrel))
  }

  # Check the fit method and get the GOF metrics
  if(is.null(wblr_obj$fit)) {
    methlab <- NULL
    methval <- NULL
  }
  else if(wblr_obj$fit[[1]]$options$method.fit=='rr-xony') {
    methlab <- 'R^2'
    methval <-  round(wblr_obj$fit[[1]]$gof$r2, signif)
  }
  else if(wblr_obj$fit[[1]]$options$method.fit=='mle') {
    methlab <- 'Loglikelihood'
    methval <- round(wblr_obj$fit[[1]]$gof$loglik, signif)
  }

  ## End extracting data from the wblr object

  # Create the main probability plot
  plotProbabilities <- function() {

    # Set up the plot layout
    fillcolor <- plotly::toRGB(confCol, 0.2)
    xgrid <- ifelse(is.null(showGrid) || isTRUE(showGrid), TRUE, FALSE)
    ygrid <- xgrid

    # Setup the yaxis tick marks
    yticks <- c(0.000001,0.00001,0.0001,0.001,0.01,0.05,0.1,0.2,0.5,1,2,5,10,20,50,90,99,99.999)

    # Setup the yaxis scale for lognormal vs Weibull
    if(wblr_obj$fit[[1]]$options$dist=='lognormal') {
      yticks_trans <- qnorm(yticks/100)
      yaxis_scale <- 'linear'
    } else {
      yticks_trans<- log(1/(1-yticks/100))
      yaxis_scale <- 'log'
    }

    # Setup the axis min and max
    ymin <- min(log10(unrel))
    ymax <- max(log10(yticks_trans))
    xmin <- min(log10(datum))
    xmax <- max(log10(datum))

    probPlot <- plot_ly(x=time, y=prob_trans, type='scatter', mode='markers',
                        marker=list(color=probCol), showlegend=FALSE, error_x=list(array=~ints, color=intCol),
                        name="", text=~paste0("Probability: (",time_sd,", ",prob_sd,")"), hoverinfo = 'text'
    ) %>%

      # Set up the main probability plot layout
      layout(title=main,
             xaxis = list(type='log', title=xlab, showline=TRUE, mirror='ticks',
                          showgrid=xgrid, gridcolor=gridCol, range=list(xmin, xmax)),
             yaxis = list(type=yaxis_scale, title=ylab, showline=TRUE, mirror = 'ticks',
                          size=text, showgrid=ygrid, gridcolor=gridCol, range=list(ymin, ymax),
                          tickvals=yticks_trans, ticktext=yticks)
      ) %>%

      # Add best fit
      add_trace(x=datum, y=unrel_trans, mode='markers+lines',
                marker=list(color='transparent'), line = list(color = fitCol),
                error_x=list(array=NULL),
                text=~paste0("Fit: ",datum_sd,", ",unrel_sd,")"), hoverinfo = 'text'
      ) %>%

      # Add lower confidence bound
      add_trace(x=lower, y=unrel_trans, mode='markers+lines',
                marker=list(color='transparent'), line=list(color='transparent'),
                error_x=list(array=NULL),
                text=~paste0("Upper: ",lower_sd,", ",unrel_sd,")"), hoverinfo = 'text'

      ) %>%

      # Add upper confidence bound
      add_trace(x=upper, y=unrel_trans, mode='markers+lines',
                fill='tonexty',
                fillcolor=fillcolor,
                marker=list(color='transparent'), line=list(color='transparent'),
                error_x=list(array=NULL),
                text=~paste0("Lower: ",upper_sd,", ",unrel_sd,")"), hoverinfo='text'
      )
    return(probPlot)
  }

  # Create the suspensions plot
  plotSuspensions <- function() {
    if (showSusp && !is.null(susp)) {

      # Setup the axis min and max
      xmin <- min(log10(datum))
      xmax <- max(log10(datum))

      # Draw random values to represent the y-axis positions for the suspensions plot
      susp_sd <- round(susp, signif)
      ry <- stats::runif(length(susp))

      # Create the suspensions plot
      suspPlot <- plot_ly(x=susp, y=ry, type='scatter', mode='markers',
                          marker=list(color=probCol), showlegend=FALSE,
                          text=~paste0("Suspension: ",susp_sd), hoverinfo='text'
      ) %>%

        # Create the suspensions plot layout
        layout(
          xaxis = list(type='log', title='', zeroline=FALSE, showline=TRUE, mirror='ticks',
                       showticklabels=FALSE, showgrid=FALSE, range=list(xmin, xmax)
          ),
          yaxis = list(title='', zeroline=FALSE, showline=TRUE, mirror='ticks',
                       showticklabels=FALSE, showgrid=FALSE
          )
        )
    } else {
      suspPlot <- NULL
    }
    return(suspPlot)
  }

  # Build the results table
  buildTable <- function() {
    if (showRes) {

      # Set up the results table
      Params <- c('Ranks', 'n', 'Failures', 'Intervals', 'Suspensions', 'Distribution',
                  'Method', param1, param2, param3, methlab, 'CI', 'Type')

      Values = c(wblr_obj$options$pp, wblr_obj$n, wblr_obj$fail, wblr_obj$interval,
                 wblr_obj$cens, wblr_obj$options$dist, wblr_obj$options$method.fit,
                 paramval1, paramval2, paramval3, methval, wblr_obj$options$ci,
                 wblr_obj$options$method.conf)

      res <- data.frame(Params, Values)

      # Build the table
      resTab <- plot_ly(type='table',
                        domain = list(x = c(0.775, 1)),
                        header=list(values=names(res), align=c('center','center'),
                                    line=list(width=1, color='black'),
                                    fill=list(color=c("grey", "grey")),
                                    font = list(family="Arial", color="white")
                        ),
                        cells=list(values=rbind(res$Params, res$Values),
                                   align=c('center', 'center'),
                                   line=list(color="black", width = 1),
                                   font=list(family="Arial", color=c("black"))
                        )
      )
    } else {
      resTab <- NULL
    }

    return(resTab)
  }

  # Build the combination plot
  combinePlots <- function(probPlot, suspPlot, resTab) {

    # Workaround for open issue with plotly causing warning
    function_to_hide_plotly_warning <- function(...) {
      plot <- subplot(...)
      plot$x$layout <- plot$x$layout[grep('NA', names(plot$x$layout), invert = TRUE)]
      plot
    }

    # Build the combination plot
    if(!is.null(resTab) && !is.null(suspPlot)) {
      comboPlot <- function_to_hide_plotly_warning(probPlot, suspPlot, resTab, nrows=2, titleX=TRUE, titleY=TRUE) %>%
        layout(xaxis=list(domain=c(0, 0.75)),
               xaxis2=list(domain=c(0, 0.75)),
               xaxis3=list(domain=c(0.775, 1)),
               yaxis=list(domain=c(0, 0.875)),
               yaxis2=list(domain=c(0.9, 1)),
               yaxis3=list(domain=c(0, 0.85))
        )
    } else  if(is.null(resTab) && is.null(suspPlot)) {
        comboPlot <- probPlot
    } else if(is.null(resTab) && !is.null(suspPlot)) {
      comboPlot <- function_to_hide_plotly_warning(probPlot, suspPlot, nrows=2, titleX=TRUE, titleY=TRUE) %>%
        layout(xaxis=list(domain=c(0, 1)),
               xaxis2=list(domain=c(0, 1)),
               yaxis=list(domain=c(0, 0.875)),
               yaxis2=list(domain=c(0.9, 1))
        )
    } else if(!is.null(resTab) && is.null(suspPlot)) {
      comboPlot <- function_to_hide_plotly_warning(probPlot, resTab, titleX=TRUE, titleY=TRUE) %>%
        layout(xaxis=list(domain=c(0, 0.75)),
               xaxis2=list(domain=c(0.775, 1)),
               yaxis=list(domain=c(0, 1)),
               yaxis2=list(domain=c(0, 1))
        )
    }
    return(comboPlot)
  }

  # Main function body
  prob_plot <- plotProbabilities()
  susp_plot <- plotSuspensions()
  res_tab <- buildTable()
  final_plot <- combinePlots(prob_plot, susp_plot, res_tab)

  return(final_plot)
}
