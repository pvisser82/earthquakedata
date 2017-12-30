#' GeomTimeLine proto
#'
#' This geom is responsible for drawing a line per country and plotting the earthquakes on it.
#' The magnitude of the earthquake is used for the size of the circles, while the deaths are used for colour.
#'
#'
#' @importFrom ggplot2 ggproto
#' @importFrom ggplot2 Geom
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 draw_key_point
#' @importFrom grid pointsGrob
#' @importFrom grid unit
#' @importFrom grid gpar
#' @importFrom grid segmentsGrob
#' @importFrom grid gTree
#' @importFrom grid gList
GeomTimeline <- ggplot2::ggproto("GeomTimeline", ggplot2::Geom,
                                 required_aes = c("x", "y"),
                                 non_missing_aes = c("size", "shape", "colour"),
                                 default_aes = ggplot2::aes(y = 0.05,
                                                            size = 2,
                                                            shape = 19,
                                                            colour = "grey",
                                                            alpha = 0.3,
                                                            stroke = 0.5,
                                                            fill = NA),
                                 draw_key = ggplot2::draw_key_point,
                                 draw_panel = function(data, panel_scales, coord) {
                                   ## Transform the data first
                                   coords <- coord$transform(data, panel_scales)

                                   # build the grid grob
                                   eq_point <-grid::pointsGrob(
                                     x = coords$x,
                                     y = coords$y,
                                     pch = coords$shape,
                                     size = grid::unit(coords$size * 2, "mm"),
                                     default.units = "native",
                                     gp = grid::gpar(
                                       col = scales::alpha(coords$colour, coords$alpha),
                                       fill = scales::alpha(coords$colour, coords$alpha))
                                   )

                                   country_line <- grid::segmentsGrob(
                                     x0 = 0,
                                     x1 = 1,
                                     y0 = coords$y,
                                     y1 = coords$y,
                                     default.units = "native",
                                     gp = grid::gpar(
                                       size = 0.5,
                                       alpha = coords$alpha * 0.5,
                                       col = "grey")
                                   )

                                   timeline <- grid::gTree(children = grid::gList(
                                     country_line, eq_point))
                                 })

#' geom_timeline function
#'
#' @param mapping The aesthetics that the geom accepts
#' @param stat The statistical transformation function that must be used
#'
#' @return  This function returns a plot where earthquakes are plotted per country and where the size
#' is the magnitude and the colour is the number of deaths
#' @export
#'
#' @examples
#' \dontrun{
#' readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>%
#' eq_clean_data() %>%
#'  dplyr::filter(COUNTRY == "USA" & lubridate::year(DATE) >= 2000) %>%
#'  ggplot() +
#'  geom_timeline(aes(x = DATE, y = COUNTRY,size = EQ_PRIMARY, colour = DEATHS))
#' }
geom_timeline <- function(mapping = NULL, data = NULL, stat = "identity",
                          position = "identity", na.rm = FALSE,
                          show.legend = NA, inherit.aes = TRUE, ...) {
  ggplot2::layer(
    geom = GeomTimeline, mapping = mapping,
    data = data, stat = stat, position = position,
    show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(na.rm = na.rm, ...)
  )
}

#' GeomTimeLineLabel proto
#'
#' This geom is responsible for drawing the labels on the timeline. The number of labels are set
#' using the n_max parameter. The function will retrieve the n_max number of highest magnitudes
#' using the setup_data function and add the label to those earthquakes.
#'
#' @param n_max The maximum number of labels to be displayed.
#'
#' @importFrom ggplot2 ggproto
#' @importFrom ggplot2 Geom
#' @importFrom ggplot2 aes
#' @importFrom ggplot2 draw_key_label
#' @importFrom dplyr top_n
#' @importFrom grid segmentsGrob
#' @importFrom grid gpar
#' @importFrom grid textGrob
#' @importFrom grid gTree
GeomTimeLineLabel <- ggplot2::ggproto("GeomTimeLineLabel", ggplot2::Geom,
                                      required_aes = c("x", "y", "label"),
                                      default_aes = ggplot2::aes(
                                        y = 0.1,
                                        colour = "gray",
                                        size = 0.2,
                                        linetype = 1,
                                        alpha = 0.2,
                                        angle = 45,
                                        hjust = 0,
                                        vjust = 0,
                                        family = "",
                                        fontface = 1,
                                        pt = 4,
                                        lineheight = 1.5,
                                        n_max = 5,
                                        fill = NA),
                                      draw_key = ggplot2::draw_key_label,
                                      setup_data = function(data, params) {
                                        data <- data %>%
                                          dplyr::top_n(params$n_max, size)
                                      },
                                      draw_group = function(data, panel_scales, coord) {

                                        # transform data
                                        coords <- coord$transform(data, panel_scales)

                                        # build grid grob
                                        line <- grid::segmentsGrob(
                                          x0 = coords$x,
                                          x1 = coords$x,
                                          y0 = coords$y,
                                          y1 = coords$y + 0.1,
                                          default.units = "native",
                                          gp = grid::gpar(
                                            size = 0.5,
                                            alpha = coords$alpha,
                                            col = coords$color,
                                            fill = NA)
                                        )

                                        # build the textGrob
                                        text <- grid::textGrob(
                                          label = coords$label,
                                          x = coords$x + 0.01,
                                          y = coords$y + 0.1,
                                          hjust = coords$hjust,
                                          vjust = coords$vjust,
                                          rot = coords$angle,
                                          default.units = "native",
                                          gp = grid::gpar(
                                            col = coords$color,
                                            fontsize = 3.5 * coords$pt,
                                            size = 0.5,
                                            fontfamily = coords$family,
                                            fontface = coords$fontface,
                                            lineheight = coords$lineheight,
                                            fill = NA)
                                        )


                                        timeline_label <- grid::gTree(children = grid::gList(
                                          line, text))

                                      })

#' geom_timeline_label function
#'
#' @param mapping The aesthetics that the geom accepts
#' @param stat The statistical transformation function that must be used
#' @param n_max The maximum number of labels to display
#'
#' @return This function returns the labels that are plotted on the timeline
#' @export
#'
#' @examples
#' \dontrun{
#' readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>%
#' eq_clean_data() %>%
#'  dplyr::filter(COUNTRY == "USA" & lubridate::year(DATE) >= 2000) %>%
#'  ggplot() +
#'  geom_timeline(aes(x = DATE, y = COUNTRY,size = EQ_PRIMARY, colour = DEATHS)) +
#'  geom_timeline_label(aes(x = DATE, y = COUNTRY, label = LOCATION_NAME, size = EQ_PRIMARY), n_max = 5) +
#'  ggtitle("Earthquake Timeline") +
#'  theme_timeline() +
#'  labs(size = "Richter Scale value:", colour = "# of Deaths:")
#' }
geom_timeline_label <- function(mapping = NULL,
                                data = NULL,
                                stat = "identity",
                                position = "identity",
                                na.rm = TRUE,
                                show.legend = NA,
                                inherit.aes = TRUE,
                                xmin = NULL,
                                xmax = NULL,
                                n_max = 5,
                                fill = NA
) {

  ggplot2::layer(
    geom = GeomTimeLineLabel,
    mapping = mapping,
    data = data,
    stat = stat,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      n_max = n_max
    )
  )
}

#' Timeline theme
#'
#' This theme modifies the Classic Theme to display the \code{geom_timeline} geometry.
#' The y axis line, ticks and title are hidden
#' The y axis line text is changed to darkgray with size 11 and a right-hand margin of 15
#' The x axis line colour black with a thickness of 1
#' The x axis text is changed to darkgray with size 11 with a top margin of 3
#' The x axis title is size 14 with a top margin of 5
#' The plot a title is added and justified horisontally in the middle of the plot
#' The legend is positioned at the bottom of the screen
#'
#' @return A ggplot2 theme
#'
#' @export
#'
#' @examples
#' #' \dontrun{
#' readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>%
#' eq_clean_data() %>%
#'  dplyr::filter(COUNTRY == "USA" & lubridate::year(DATE) >= 2000) %>%
#'  ggplot() +
#'  geom_timeline(aes(x = DATE, y = COUNTRY,size = EQ_PRIMARY, colour = DEATHS)) +
#'  geom_timeline_label(aes(x = DATE, y = COUNTRY, label = LOCATION_NAME, size = EQ_PRIMARY), n_max = 5) +
#'  ggtitle("Earthquake Timeline") +
#'  theme_timeline() +
#'  labs(size = "Richter Scale value:", colour = "# of Deaths:")
#' }
theme_timeline <- function()
{
  ggplot2::theme_classic() +
    ggplot2::theme(
      # hide the y axis line, ticks and title
      axis.line.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      # change the y axis line text to be darkgray, size 11 with a right-hand margin of 15
      axis.text.y = ggplot2::element_text(colour = "darkgray",size = 11, margin = margin(r = 15)),
      # show x axis and make the line colour black with a thickness of 1
      axis.line.x = ggplot2::element_line(colour = "black", size = ggplot2::rel(1)),
      # change the x axis text to be darkgray, size 11 with a top margin of 3
      axis.text.x = ggplot2::element_text(colour = "darkgray",size = 11, margin = margin(t = 3)),
      # change the x axis title to be size 14with a top margin of 5
      axis.title.x = ggplot2::element_text(size = 14, margin = margin(t = 5)),
      # as an extra, give the plot a title and justify it horisontally in the middle of the plot
      plot.title = ggplot2::element_text(color = "darkgray", size = 24, hjust = 0.5),
      # position the legend at the bottom of the screen
      legend.position = "bottom",

      complete = TRUE
    )
}




