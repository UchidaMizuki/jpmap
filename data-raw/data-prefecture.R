library(tidyverse)
library(rvest)
# library(mapdata)
library(sf)

# data-prefecture ---------------------------------------------------------

JGD2011 <- 6668

pref_name <- read_html("https://www.land.mlit.go.jp/webland/api.html") |>
  html_elements("table.api_table") |>
  nth(5) |>
  html_table() |>
  rename(pref_code = `都道府県コード`,
         pref_name_ja = `日本語表記`) |>
  select(pref_code, pref_name_ja)

prefecture <- rnaturalearth::ne_states("japan",
                                       returnclass = "sf") |>
  as_tibble() |>
  st_as_sf() |>
  st_transform(JGD2011) |>
  select(iso_3166_2, name) |>
  mutate(pref_code = iso_3166_2 |>
           str_extract("(?<=JP-)\\d{2}") |>
           as.integer()) |>
  select(!iso_3166_2) |>
  rename(pref_name = name) |>
  arrange(pref_code) |>
  left_join(pref_name,
            by = "pref_code") |>
  relocate(pref_code, pref_name, pref_name_ja)

usethis::use_data(prefecture,
                  overwrite = TRUE)
