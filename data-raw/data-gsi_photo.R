library(tidyverse)
library(xml2)
library(fs)

# data-gsi_photo ----------------------------------------------------------

url_gsi <- "https://cyberjapandata.gsi.go.jp/xyz"

gsitiles_wmts_photo <- gsi_wmts(system.file("extdata/gsitiles_wmts_photo.xml",
                                            package = "jpmap")) |>
  filter(str_detect(layer, "^年代別の写真_(年度別写真（2007年以降）|\\d{4}年～\\d{4}年|1928年頃)"))


layer <- attr(gsitiles_wmts_photo, "layer")[gsitiles_wmts_photo$layer_id] |>

  # https://stackoverflow.com/questions/55727236/xml-find-all-function-from-xml2-package-r-does-not-find-relevant-nodes
  xml_ns_strip()

gsitiles_photo <- tibble(period = gsitiles_wmts_photo$layer |>
                           str_extract("(\\d{4}年～)?\\d{4}年頃?$") |>
                           str_split("～"),
                         url = .env$layer |>
                           xml_find_all("ows:Identifier") |>
                           xml_text(),
                         format = .env$layer |>
                           xml_find_all("Format") |>
                           xml_text()) |>
  mutate(format = case_when(format == "image/png" ~ "png",
                            format == "image/jpeg" ~ "jpg"),
         url = str_c(url_gsi, url, glue::glue("{{z}}/{{x}}/{{y}}.{format}"),
                     sep = "/")) |>
  select(!format) |>
  mutate(year_from = period |>
           map_chr(~ .x |>
                     first() |>
                     str_extract("\\d{4}")) |>
           as.integer(),
         year_to = period |>
           map_chr(~ .x |>
                     last() |>
                     str_extract("\\d{4}")) |>
           as.integer(),
         period = period |>
           map_chr(~ {
             case_when(str_detect(.x, "^\\d{4}年$") ~ .x |>
                         str_extract("\\d{4}"),
                       str_detect(.x, "^\\d{4}年頃$") ~ .x |>
                         str_extract("\\d{4}") |>
                         str_c("?")) |>
               str_c(collapse = "--")
           })) |>
  relocate(period, year_from, year_to) |>
  arrange(year_from)

dir_create("data-raw/data-gsi_photo")
write_rds(gsitiles_photo, "data-raw/data-gsi_photo/gsitiles_photo.rds")
