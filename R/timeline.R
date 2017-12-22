#' Title
#'
#' @param base_size
#' @param base_family
#'
#' @return
#' @export
#'
#' @examples
theme_timeline <- function(base_size = 11, base_family = ""){
  ggplot2::theme_classic(base_size = base_size, base_family = base_family) %+replace%
    ggplot2::theme(
      # show x.axis but not y.axis
      axis.line.x = ggplot2::element_line(colour = "black", size = ggplot2::rel(1)),
      axis.line.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),

      # match legend key to panel.background
      legend.key = ggplot2::element_blank(),
      # locate legend at the bottom
      legend.position = "bottom",

      complete = TRUE
    )
}
