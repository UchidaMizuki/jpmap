library(tidyverse)
library(rvest)
library(mapdata)
library(sf)

# data-prefecture ---------------------------------------------------------

pref_name <- read_html("https://www.land.mlit.go.jp/webland/api.html") |>
  html_elements("table.api_table") |>
  nth(5) |>
  html_table() |>
  rename(pref_code = `都道府県コード`,
         pref_name = `英語表記`,
         pref_name_ja = `日本語表記`) |>
  relocate(pref_code, pref_name) |>
  mutate(pref_name = pref_name |>
           str_extract("^[^\\s]+"))

prefecture <- maps::map("japan",
                        plot = FALSE,
                        fill = TRUE) |>
  st_as_sf() |>
  st_make_valid() |>

  # https://github.com/r-spatial/sf/issues/951
  as_tibble() |>
  st_as_sf() |>

  rename(pref_name = ID) |>
  mutate(pref_name = str_to_title(pref_name)) |>

  left_join(pref_name,
            by = "pref_name") |>
  relocate(pref_code, pref_name, pref_name_ja)

usethis::use_data(prefecture,
                  overwrite = TRUE)
