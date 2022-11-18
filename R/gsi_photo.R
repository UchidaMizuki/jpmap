#' @export
gsi_photo <- function(x,
                      year_from = NULL,
                      year_to = NULL,
                      zoom = NULL) {
  bbox <- bbox_gsi(x)
  zoom <- zoom_gsi(zoom, bbox)

  year_from <- year_from %||% -Inf
  year_to <- year_to %||% Inf

  out <- gsitiles_photo |>
    dplyr::filter(.data$year_from >= .env$year_from,
                  .data$year_to <= .env$year_to) |>
    dplyr::select(!c("year_from", "year_to"))

  if (vec_is_empty(out)) {
    out <- tibble::tibble(period = character(),
                          raster = list())
  } else {
    pb <- progress::progress_bar$new(total = vec_size(out))

    out <- out |>
      dplyr::rowwise() |>
      dplyr::mutate(raster = list({
        out <- purrr::possibly(get_gsi, NULL)(bbox = bbox,
                                              url = .data$url,
                                              zoom = zoom)
        pb$tick()
        Sys.sleep(1)

        out
      })) |>
      dplyr::filter(!is.null(.data$raster)) |>
      dplyr::ungroup() |>
      dplyr::select(!"url")
  }

  stickyr::new_sticky_tibble(out,
                             cols = c("period", "raster"),
                             class = "gsi_photo",
                             class_grouped_df = "gsi_photo",
                             class_rowwise_df = "gsi_photo")
}

#' @export
gsi_photo_latest <- function(x, zoom = NULL) {
  bbox <- bbox_gsi(x)
  zoom <- zoom_gsi(zoom, bbox)

  get_gsi(bbox = bbox,
          url = "https://cyberjapandata.gsi.go.jp/xyz/seamlessphoto/{z}/{x}/{y}.jpg",
          zoom = zoom)
}

#' @export
tbl_sum.gsi_photo <- function(x) {
  out <- NextMethod()
  names(out)[[1L]] <- "GSI Photo"
  out
}
