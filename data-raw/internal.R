library(tidyverse)

# internal ----------------------------------------------------------------

gsitiles_photo <- read_rds("data-raw/data-gsi_photo/gsitiles_photo.rds")

usethis::use_data(gsitiles_photo,
                  internal = TRUE,
                  overwrite = TRUE)
