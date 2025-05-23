#' Interactive Contour Plot
#'
#' This function creates an interactive contour plot for a WeibullR object.
#'
#' @param wblr_obj An object of class 'wblr'.
#' @param main Main title.
#' @param xlab X-axis label.
#' @param ylab Y-axis label.
#' @param showGrid Show grid (TRUE) or hide grid (FALSE).
#' @param col Color of the model contour
#' @param gridCol Color of the grid.
#' @param signif Significant digits of results
#' @return The function returns no value.
#' @examples
#' library(WeibullR)
#' library(WeibullR.plotly)
#' failures<-c(30, 49, 82, 90, 96)
#' obj<-wblr.conf(wblr.fit(wblr(failures), method.fit = 'mle'), method.conf = 'lrb')
#' plotly_contour(obj)
#' @import WeibullR
#' @import plotly
#' @export
plotly_contour <- function(wblr_obj,
                           main='Contour Plot',
                           xlab='Eta',
                           ylab='Beta',
                           showGrid=TRUE,
                           col='black',
                           gridCol='lightgray',
                           signif=3)
  {

  # Validate inputs
  validate_inputs <- function() {
    # Check for a wblr object
    if(!identical(class(wblr_obj),"wblr")){
      stop("Argument \"wblr_obj\" is not of class \"wblr\".")
    }

    # Check for contours
    if(!identical(wblr_obj$fit[[1]]$conf[[1]]$options$method.conf,"lrb")){
      stop("Contour plots are only available for \"wblr_obj\"s with \"method.conf='lrb'\".")
    }
  }
  validate_inputs()

  ## Begin extracting data from the wblr object

  # Check the distribution
  if(is.null(wblr_obj$fit)) {
    param1 <- NULL
    param2 <- NULL
    paramval1 <- NULL
    paramval2 <- NULL
  }
  else if(wblr_obj$fit[[1]]$options$dist=='lognormal') {
    param1 <- 'Mulog'
    param2 <- 'Sigmalog'
    paramval1 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[1]), signif)
    paramval2 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[2]), signif)
  }
  else if(wblr_obj$fit[[1]]$options$dist=='weibull'){
    param1 <- 'Beta'
    param2 <- 'Eta'
    paramval1 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[2]), signif)
    paramval2 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[1]), signif)
  }
  else if(wblr_obj$fit[[1]]$options$dist=='weibull3p'){
    param1 <- 'Beta'
    param2 <- 'Eta'
    paramval1 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[2]), signif)
    paramval2 <- round(as.numeric(wblr_obj$fit[[1]]$fit_vec[1]), signif)
  }

  # Get the x and y values
  xvals <- round(wblr_obj$fit[[1]]$conf[[1]]$contour[[1]], signif)
  yvals <- round(wblr_obj$fit[[1]]$conf[[1]]$contour[[2]], signif)

  ## End extracting data from the wblr object

  # Build the contour plot
  plotContour <- function() {

    # Set up the plot layout
    fillcolor <- plotly::toRGB(col, 0.2)
    xgrid <- ifelse(is.null(showGrid) || isTRUE(showGrid), TRUE, FALSE)
    ygrid <- xgrid

    # Build the contour plot
    contPlot <- plot_ly(x=xvals, y=yvals, type='scatter', mode='markers+lines',
                        showlegend=FALSE, fill='tonexty', fillcolor=fillcolor,
                        marker=list(color='transparent'), line=list(color='transparent'),
                        text=~paste0("Contour: (",xvals,", ",yvals,")"), hoverinfo = 'text'
    ) %>%

      # Specify the layout for the contour plot
      layout(title=main,
             xaxis = list(title=xlab, showline=TRUE, mirror='ticks',
                          showgrid=xgrid, gridcolor=gridCol),
             yaxis = list(title=ylab, showline=TRUE, mirror = 'ticks',
                          showgrid=ygrid, gridcolor=gridCol)
      ) %>%

      # Add parameter estimates
      add_trace(x=paramval2, y=paramval1, mode='markers+lines',
                marker=list(color='black', size=20),
                text=~paste0("Estimates: (",paramval2,", ",paramval1,")"), hoverinfo = 'text')

    return(contPlot)
  }

  # Main function body
  cont_plot <- plotContour()

  return(cont_plot)
}
