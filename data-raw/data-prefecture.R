library(tidyverse)
library(rvest)
library(sf)

# data-prefecture ---------------------------------------------------------

JGD2011 <- 6668

prefecture <- rnaturalearth::ne_states("japan") |>
  as_tibble() |>
  st_as_sf() |>
  st_transform(JGD2011) |>
  select(iso_3166_2, name, name_ja) |>
  mutate(pref_code = iso_3166_2 |>
           str_extract("(?<=JP-)\\d{2}") |>
           as.integer(),
         .keep = "unused") |>
  arrange(pref_code) |>
  rename(pref_name = name,
         pref_name_ja = name_ja) |>
  relocate(pref_code, pref_name, pref_name_ja)

usethis::use_data(prefecture,
                  overwrite = TRUE)
