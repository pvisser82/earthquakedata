## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 7,
  fig.height = 7
)
library(earthquakedata)
library(dplyr)
library(ggplot2)
library(leaflet)



## ---- message=FALSE------------------------------------------------------
readr::read_delim("../earthquakes.tsv.gz",delim = "\t") %>%
  eq_clean_data() %>%
  dplyr::filter(COUNTRY == c("USA","MEXICO") & lubridate::year(DATE) >= 2000) %>%
  ggplot() +
    geom_timeline(aes(x = DATE, y = COUNTRY,size = EQ_PRIMARY, colour = DEATHS)) +
    geom_timeline_label(aes(x = DATE, y = COUNTRY, label = LOCATION_NAME, size = EQ_PRIMARY), n_max = 5) +
    ggtitle("Earthquake Timeline") +
    theme_timeline() +
    labs(size = "Richter Scale value:", colour = "# of Deaths:")

## ---- message=FALSE------------------------------------------------------

 readr::read_delim("earthquakes.tsv.gz", delim = "\t") %>%
  eq_clean_data() %>%
  dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
  eq_map(annot_col = "DATE")

## ---- message=FALSE------------------------------------------------------
readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>%
  eq_clean_data() %>%
  dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
  dplyr::mutate(popup_text = eq_create_label(.))%>%
  eq_map(annot_col = "popup_text")

