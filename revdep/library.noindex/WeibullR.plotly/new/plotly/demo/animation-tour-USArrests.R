# adapted from  https://github.com/rstudio/ggvis/blob/master/demo/tourr.r
library(plotly)

data("USArrests")

# Avoids R CMD check NOTE about using `tourr` without mentioning it in DESCRIPTION
# Install it via CRAN `install.packages("tourr")`
rescale <- getFromNamespace("rescale", "tourr")
new_tour <- getFromNamespace("new_tour", "tourr")
grand_tour <- getFromNamespace("grand_tour", "tourr")

mat <- rescale(USArrests[, 1:4])
tour <- new_tour(mat, grand_tour(), NULL)

# projection of each observation
tour_dat <- function(step_size) {
  step <- tour(step_size)
  proj <- scale(mat %*% step$proj, center = TRUE, scale = FALSE)
  data.frame(x = proj[,1], y = proj[,2], state = rownames(mat))
}

# projection of each variable's axis
proj_dat <- function(step_size) {
  step <- tour(step_size)
  data.frame(
    x = step$proj[,1], y = step$proj[,2], variable = colnames(mat)
  )
}

steps <- c(0, rep(1/15, 200))
stepz <- cumsum(steps)

# tidy version of tour data
tour_dats <- lapply(steps, tour_dat)
tour_datz <- Map(function(x, y) cbind(x, step = y), tour_dats, stepz)
tour_dat <- dplyr::bind_rows(tour_datz)

# tidy version of tour projection data
proj_dats <- lapply(steps, proj_dat)
proj_datz <- Map(function(x, y) cbind(x, step = y), proj_dats, stepz)
proj_dat <- dplyr::bind_rows(proj_datz)


ax <- list(
  title = "", showticklabels = FALSE,
  zeroline = FALSE, showgrid = FALSE,
  range = c(-1.1, 1.1)
)

# for nicely formatted slider labels
options(digits = 3)

tour_dat <- highlight_key(tour_dat, ~state, group = "A")

tour <- proj_dat %>%
  plot_ly(x = ~x, y = ~y, frame = ~step, color = I("black")) %>%
  add_segments(xend = 0, yend = 0, color = I("gray80")) %>%
  add_text(text = ~variable) %>%
  add_markers(data = tour_dat, text = ~state, ids = ~state, hoverinfo = "text") %>%
  layout(xaxis = ax, yaxis = ax)

dend <- USArrests %>% 
  dist() %>% 
  hclust() %>%
  as.dendrogram() %>%
  plot_dendro(set = "A", xmin = -100, height = 900, width = 1100)

USArrests$state <- rownames(USArrests)
USArrests$abb <- setNames(state.abb, state.name)[USArrests$state]

map <- plot_geo(USArrests, color = I("black")) %>% 
  add_trace(locations = ~abb, locationmode = "USA-states",
            key = ~state, set = "A") %>% 
  layout(geo = list(
    scope = 'usa',
    projection = list(type = 'albers usa'),
    lakecolor = toRGB('white')
  ))

subplot(map, tour, nrows = 2, margin = 0) %>%
  subplot(dend, shareY = FALSE, margin = 0) %>%
  hide_legend() %>%
  animation_opts(33, easing = "cubic", redraw = FALSE) %>%
  highlight(persistent = TRUE, dynamic = TRUE)
