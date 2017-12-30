# earthquakedata

## Overview

The goal of the earthquakedata package is to visualise the data in a timeline and using an interactive map:

-   `eq_clean_data()` cleans the earhtquake data set and prepares it for visualisation
-   `geom_timeline()` allows the user to view the earthquake data using ggplot2
-   `geom_timeline_label()` allows the user to view a specific amount of location labels on the timeline
-   `eq_map()` lets the user plot the earthquake data on an interactive map
-   `eq_create_label()` allows the user to see more detailed information regarding the earhtquake in the annotation text for each event

## Installation

You can install earthquakedata from github with:


``` r
# install.packages("devtools")
devtools::install_github("pvisser82/earthquakedata")
```

## Examples

### Clean your data:

It is quite easy to clean your earthquake data set using the `eq_clean_data()` function. This function takes the data set as a parameter and returns a cleaned data set.
For the example below to work, it is assumed that the raw data set is in your working directory.

``` r
df_cleaneddata <- eq_clean_data(readr::read_delim("earthquakes.tsv.gz",delim = "\t"))
```

### Plot a timeline:

Once you have cleaned data, it is handy to plot it using a timeline to display the earthquake events over a time period with additional dimensions for magnitude and number of casualties. You have the option to also add the locations of the earthquakes as labels.

#### Single country - no label:

Plot a timeline using the `geom_timeline()` function. Set the aesthetics as follows:
-   x = DATE
-   y = COUNTRY
-   size = EQ_PRIMARY
-   colour = DEATHS

``` r
readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>%
 eq_clean_data() %>%
  dplyr::filter(COUNTRY == c("USA") & lubridate::year(DATE) >= 2000) %>%
  ggplot() +
  geom_timeline(aes(x = DATE, y = COUNTRY,size = EQ_PRIMARY, colour = DEATHS))
``` 
![Single country, no label](images/single_country_no_label.png?raw=true "Single country, no label")

#### Single country - with labels:

It is possible to set the number of labels using the `geom_timeline_label()` function is conjunction with the `geom_timeline()` function. This will allow you to set the `n_max` variable. This will display the labels for the `n_max` number of earthquakes with the highest magnitude.

``` r
readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>%
  eq_clean_data() %>%
  dplyr::filter(COUNTRY == c("USA") & lubridate::year(DATE) >= 2000) %>%
  ggplot() +
    geom_timeline(aes(x = DATE, y = COUNTRY,size = EQ_PRIMARY, colour = DEATHS)) +
    geom_timeline_label(aes(x = DATE, y = COUNTRY, label = LOCATION_NAME, size = EQ_PRIMARY), n_max = 5) +
    ggtitle("Earthquake Timeline") +
    theme_timeline +
    labs(size = "Richter Scale value:", colour = "# of Deaths:")
``` 
![Single country, with labels](images/single_country_with_labels.png?raw=true "Single country, with labels")

#### Multiple countries:

By specifying multiple countries in the data set, it is possible to create more than one timeline on the same graph. The labels can be enabled or disabled as with single countries

``` r
readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>%
  eq_clean_data() %>%
  dplyr::filter(COUNTRY == c("USA", "MEXICO") & lubridate::year(DATE) >= 2000) %>%
  ggplot() +
    geom_timeline(aes(x = DATE, y = COUNTRY,size = EQ_PRIMARY, colour = DEATHS)) +
    geom_timeline_label(aes(x = DATE, y = COUNTRY, label = LOCATION_NAME, size = EQ_PRIMARY), n_max = 5) +
    ggtitle("Earthquake Timeline") +
    theme_timeline +
    labs(size = "Richter Scale value:", colour = "# of Deaths:")
``` 
![Multiple Countries](images/multiple_countries_with_labels.png?raw=true "Multiple Countries")

### Plot on a map:
Because the earthquake data also contains the coordinates of the earthquakes, it is possible to plot them on an interactive Leaflet map using the `eq_map()` function. You can also use the `eq_create_label()` function to display more information for each earthquake.

#### Basic plot:
The `eq_map()` function is used to plot the location of each earthquake on the map. The size of the circles represent the magnitude of the earthquakes. The user can set the `annot_col` parameter to any column in the earthquake data set. This will allow the user to see the value of that column for the corresponding earthquake by clicking on the circle.

```r 
readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>%
  eq_clean_data() %>%
  dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
  eq_map(annot_col = "DATE") 
```
![Basic plot](images/eq_map_DATE_column.png?raw=true "Basic plot")

#### Additional annotation text:
The `eq_create_label()` function takes the data set as an argument and creates an HTML label that can be displayed on the map. The label consists of the Location, Magnitude and Total deaths. If one of these fields are missing a value, the field is ignored when the label is built.

```r
readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>%
  eq_clean_data() %>%
  dplyr::filter(COUNTRY == "MEXICO" & lubridate::year(DATE) >= 2000) %>%
  dplyr::mutate(popup_text = eq_create_label(.))%>%
  eq_map(annot_col = "popup_text")
```
![Additional annotation text](images/eq_create_label.png?raw=true "Additional annotation text")
