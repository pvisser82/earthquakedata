context("earthquakedata unit tests")

library(dplyr)
library(lubridate)
library(ggplot2)
library(leaflet)

# Create a small data subset for testing purposes
df_data <- readr::read_delim("earthquakes.tsv.gz",delim = "\t") %>% slice(1:5) %>% eq_clean_data()

#-------------------------------------------------------------------------------
# eq_clean_data function
#
# These tests will check to make sure that the new DATE column is added and that
# it is in the correct Date format

test_that("Test eq_clean_data for the correct number of columns", {
  expect_that(ncol(df_data), equals(48))
})

test_that("Test eq_clean_data for the correct class for DATE column", {
  expect_true(lubridate::is.Date(df_data$DATE))
})

#-------------------------------------------------------------------------------
# eq_location_clean function
#
# This test will check to make sure that the eq_eq_location_clean function takes the
# strings from the LOCATION_NAME column of the data set and does the correct string
# manipulation to ensure that the data before the first colon (country name) is removed
# and that the text is converted to title case. The df_inputdata simulates the raw data
# and the df_verifieddata simulates the expected output.

df_inputdata <- data.frame(c("LOCATION","LOCATION LOCATION","LOCATION1: LOCATION2","LOCATION1: LOCATION2: LOCATION3"))
colnames(df_inputdata) <- "LOCATION_NAME"

df_verifieddata <- data.frame(c("Location","Location Location","Location2","Location2: Location3"))
colnames(df_verifieddata) <- "LOCATION_NAME"
df_verifieddata$LOCATION_NAME <- as.character(df_verifieddata$LOCATION_NAME)

test_that("Test eq_location_clean with different strings in the LOCATION_NAME column", {
  expect_identical(eq_location_clean(df_inputdata), df_verifieddata)
})

#-------------------------------------------------------------------------------
# geom_timeline function
#
# Test that the geom_timeline function creates a valid ggplot object

test_that("Test that the geom_timeline function creates a valid ggplot object", {
  gobject <- ggplot(df_data) +
    geom_timeline(aes(x = DATE, y = COUNTRY,size = EQ_PRIMARY, colour = DEATHS))

  expect_is(gobject, "ggplot")
})

#-------------------------------------------------------------------------------
# geom_timeline_label function
#
# Test that the geom_timeline_label does indeed get the correct n_max value

test_that("Test that the geom_timeline_label displays the correct number of labels", {
  gobject <- ggplot(df_data) +
    geom_timeline(aes(x = DATE, y = COUNTRY,size = EQ_PRIMARY, colour = DEATHS)) +
    geom_timeline_label(aes(x = DATE, y = COUNTRY, label = LOCATION_NAME, size = EQ_PRIMARY), n_max = 5)

  expect_that(gobject$layers[[2]]$aes_params$n_max, equals(5))
})

#-------------------------------------------------------------------------------
# eq_map function
#
# Test that the eq_map function creates a valid Leaflet object

test_that("Test that the eq_map function creates a valid Leaflet object", {
  expect_is(eq_map(df_data), "leaflet")
})

#-------------------------------------------------------------------------------
# eq_create_label function
#
#Test that the eq_create_label function returns a character vector

test_that("Test that the eq_create_label function returns a character vector", {
  expect_true(is.character(eq_create_label(df_data)))
})
