#' eq_map function
#'
#' This function receives a data set of earthquake information and plots it
#' on an interactive map using leaflet. It will use the annot_col parameter
#' to set the value of the pop-up based column of the data set that matches annot_col.
#'
#' The earthquakes are mapped using the Latitude and Longitude for each and the size of the circle
#' reflects the magnitude of the earthquake.
#'
#' @param df_data The data set containing the earthquake information
#' @param annot_col The column that will be used for the pop-up. Default set to DATE
#'
#' @importFrom leaflet addTiles addCircleMarkers leaflet
#'
#' @return An interactive leaflet map displaying the earthquakes contained in the dataset
#' @export
#'
#' @examples
#' \dontrun{
#' readr::read_delim("earthquakes.tsv.gz", delim = "\t") %>%
#' eq_clean_data() %>%
#'  dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#'  eq_map(annot_col = "DATE")
#' }
eq_map <- function(df_data, annot_col = "DATE")
{

  leaflet::leaflet(df_data) %>%
    leaflet::addTiles() %>%
    leaflet::addCircleMarkers(lng = df_data[["LONGITUDE"]],
                              lat = df_data[["LATITUDE"]],
                              radius = df_data[["EQ_PRIMARY"]],
                              opacity = 0.5,
                              stroke = TRUE,
                              weight = 1,
                              popup = df_data[[annot_col]])

}

#' eq_create_label function
#'
#' This function receives the earthquake data set and builds an annotation_text in html format
#' that can be displayed as a pop-up on the map. The function checks to see if the LOCATION_NAME,
#' EQ_PRIMARY and DEATHS for each earthquake contains a valid value and will add the lines if
#' they are valid. Otherwise, it will simply skip the specific field.
#'
#' @param df_data The data set containing the earthquake information
#'
#' @return A character vector containing the annotation text in html format
#' @export
#'
#' @examples
#' \dontrun{
#' readr::read_delim("earthquakes.tsv.gz", delim = "\t") %>%
#'  eq_clean_data() %>%
#'   dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
#'   dplyr::mutate(popup_text = eq_create_label(.)) %>%
#'   eq_map(annot_col = "popup_text")
#' }
eq_create_label <- function(df_data)
{
  annotation_text <- paste(
    ifelse(!is.na(df_data$LOCATION_NAME), paste("<b>Location: </b>", df_data$LOCATION_NAME, "<br/>"), ""),
    ifelse(!is.na(df_data$EQ_PRIMARY), paste("<b>Magnitude: </b>", df_data$EQ_PRIMARY, "<br/>"), ""),
    ifelse(!is.na(df_data$DEATHS), paste("<b>Total deaths: </b>", df_data$DEATHS, "<br/>"), ""))

  return(annotation_text)
}
