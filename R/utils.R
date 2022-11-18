facet_data <- function(plot) {
  facet_vars <- plot$facet$vars()

  if (is_empty(facet_vars)) {
    data_frame(.rows = list(plot))
  } else {
    plot_data <- as.data.frame(plot$data)[facet_vars]
    facet_data <- unique(plot_data)

    .rows <- purrr::modify(vec_chop(facet_data),
                           function(facet_data) {
                             alpha <- as.double(vec_equal(plot_data, facet_data))

                             plot +
                               ggplot2::aes(alpha = .env$alpha) +
                               ggplot2::scale_alpha_identity() +
                               ggplot2::facet_null()
                           })

    vec_cbind(facet_data,
              .rows = .rows)
  }
}

crs_gsi<- function() {
  6668L
}

bbox_gsi <- function(x) {
  bbox <- sf::st_bbox(x)

  if (is.na(sf::st_crs(bbox))) {
    sf::st_crs(bbox) <- crs_gsi()
  }

  bbox
}

zoom_gsi <- function(zoom, bbox) {
  if (is.null(zoom)) {
    zoom <- slippymath::bbox_tile_query(bbox)
    zoom <- vec_slice(zoom$zoom, zoom$total_tiles >= 5L)[[1L]]

    inform(glue::glue("Using, zoom = {zoom}"))
  }

  zoom
}

get_gsi <- function(bbox, url, zoom) {
  provider <- list(src = "",
                   q = url,
                   sub = "",
                   cit = "")
  maptiles::get_tiles(bbox,
                      provider = provider,
                      crop = TRUE,
                      zoom = zoom,
                      cachedir = fs::file_temp())
}
