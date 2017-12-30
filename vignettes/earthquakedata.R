## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7
)
library(earthquakedata)
library(dplyr)
library(ggplot2)

theme_timeline <- ggplot2::theme_classic() +
  ggplot2::theme(
    # hide the y axis line, ticks and title
    axis.line.y = ggplot2::element_blank(),
    axis.ticks.y = ggplot2::element_blank(),
    axis.title.y = ggplot2::element_blank(),
    # change the y axis line text to be darkgray, size 11 with a right-hand margin of 15
    axis.text.y = ggplot2::element_text(colour = "darkgray",size = 11, margin = ggplot2::margin(r = 15)),
    # show x axis and make the line colour black with a thickness of 1
    axis.line.x = ggplot2::element_line(colour = "black", size = ggplot2::rel(1)),
    # change the x axis text to be darkgray, size 11 with a top margin of 3
    axis.text.x = ggplot2::element_text(colour = "darkgray",size = 11, margin = ggplot2::margin(t = 3)),
    # change the x axis title to be size 14 with a top margin of 5
    axis.title.x = ggplot2::element_text(size = 14, margin = ggplot2::margin(t = 5)),
    # as an extra, give the plot a title and justify it horisontally in the middle of the plot
    plot.title = ggplot2::element_text(color = "darkgray", size = 24, hjust = 0.5),
    # position the legend at the bottom of the screen
    legend.position = "bottom",

    complete = TRUE
  )

## ---- message=FALSE------------------------------------------------------
readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>%
  eq_clean_data() %>%
  dplyr::filter(COUNTRY == c("USA") & lubridate::year(DATE) >= 2000) %>%
  ggplot() +
    geom_timeline(aes(x = DATE, y = COUNTRY,size = EQ_PRIMARY, colour = DEATHS)) +
    geom_timeline_label(aes(x = DATE, y = COUNTRY, label = LOCATION_NAME, size = EQ_PRIMARY), n_max = 5) +
    ggtitle("Earthquake Timeline") +
    theme_timeline +
    labs(size = "Richter Scale value:", colour = "# of Deaths:")

## ---- fig.show='hold'----------------------------------------------------
plot(1:10)
plot(10:1)

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(head(mtcars, 10))

