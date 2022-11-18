#' @export
write_gsi <- function(x, file,
                      overwrite = TRUE, ...) {
  if (inherits(x, "SpatRaster")) {
    terra::writeRaster(x, file,
                       overwrite = overwrite, ...)
  } else if (inherits(x, "gsi_photo")) {
    if (stringr::str_detect(file, "/[^\\.]+$")) {
      fs::dir_create(file)

      x |>
        dplyr::rowwise() |>
        dplyr::group_walk(function(x, y) {
          terra::writeRaster(x$raster[[1L]], fs::path(file, glue::glue("{x$period}.tif")))
        })
    } else if (stringr::str_detect(file, "\\.gif$")) {
      x <- x |>
        dplyr::rowwise() |>
        dplyr::mutate(file = fs::file_temp(ext = "png"))

      x |>
        dplyr::group_walk(function(x, y) {
          terra::writeRaster(x$raster[[1L]], x$file)
        })

      out <- x$file |>
        magick::image_read() |>
        magick::image_animate(fps = 1,
                              loop = 0) |>
        magick::image_annotate(res$period,
                               size = 20,
                               boxcolor = "white")
      magick::image_write(out, file)
    }
  }
}
