library(tidyverse)
library(xml2)
pkgload::load_all()

# gsitiles_wmts_example ---------------------------------------------------

# 年代別の空中写真
gsitiles_wmts_photo <- gsi_wmts() |>
  filter(str_detect(layer, "^年代別の写真")) |>
  collect()

write_xml(gsitiles_wmts_photo, "inst/extdata/gsitiles_wmts_photo.xml")
