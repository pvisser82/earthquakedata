#' Clean the LOCATION_NAME column of the earthquake dataset
#'
#' @param df_data The earthquake dataframe as sent by the eq_clean_data function
#'
#' @return This function returns the earthquake dataframe with a cleaned LOCATION_NAME column in title case
#'
#' @importFrom dplyr %>% mutate
#'
#' @examples
#' \dontrun{
#'  df_cleaneddata <- eq_locationclean(readr::read_delim("earthquakes.tsv.gz",delim = "\t"))
#' }
eq_locationclean <- function(df_data)
{
  df_data <- df_data %>%
    dplyr::mutate(LOCATION_NAME = trimws(sub("\\S+:+\\s","",LOCATION_NAME))) %>%
    dplyr::mutate(LOCATION_NAME = gsub("(\\w)(\\w*)", "\\U\\1\\L\\2", LOCATION_NAME, perl=TRUE))

  return(df_data)
}


#' Receive the raw earthquake dataset and clean it to make it usable for visualisation
#'
#' @param df_raw_NOAA The raw earthquake dataset
#'
#' @return Returns a clean dataset with an added DATE column
#' @export
#'
#' @importFrom dplyr %>% filter mutate select
#' @importFrom lubridate ymd year
#' @importFrom stringr str_pad
#'
#' @examples
#' \dontrun{
#'  df_cleaneddata <- eq_clean_data(readr::read_delim("earthquakes.tsv.gz",delim = "\t"))
#' }
eq_clean_data <- function(df_raw_NOAA)
{
  df_clean_noaa <- df_raw_NOAA

  df_clean_noaa$MONTH[is.na(df_clean_noaa$MONTH)] <- 01
  df_clean_noaa$DAY[is.na(df_clean_noaa$DAY)] <- 01
  df_clean_noaa$HOUR[is.na(df_clean_noaa$HOUR)] <- 01
  df_clean_noaa$MINUTE[is.na(df_clean_noaa$MINUTE)] <- 01

  df_clean_noaa <- df_clean_noaa %>%
    dplyr::filter(!is.na(EQ_PRIMARY)) %>%
    dplyr::mutate_(
      abs_year = ~stringr::str_pad(as.character(abs(YEAR)), width = 4, side = "left", pad = "0"),
      date_paste = ~paste(abs_year, MONTH, DAY, sep = "-"),
      DATE = ~lubridate::ymd(date_paste, truncated = 2)) %>%
    dplyr::select_(quote(-year_fix), quote(-date_paste)) %>%
    dplyr::mutate(LATITUDE = as.numeric(LATITUDE)) %>%
    dplyr::mutate(LONGITUDE = as.numeric(LONGITUDE)) %>%
    dplyr::mutate(DEATHS = as.numeric(DEATHS)) %>%
    dplyr:: mutate(EQ_PRIMARY = as.numeric(EQ_PRIMARY))

  lubridate::year(df_clean_noaa$DATE) <- df_clean_noaa$YEAR

  df_clean_noaa <- eq_locationclean(df_clean_noaa)

  return (df_clean_noaa)
}
