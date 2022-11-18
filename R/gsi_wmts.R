#' @export
gsi_wmts <- function(x = NULL) {
  x <- x %||% "https://gsi-cyberjapan.github.io/experimental_wmts/gsitiles_wmts.xml"

  gsitiles_wmts <- xml2::read_xml(x)
  ows_title <- gsitiles_wmts |>
    xml2::xml_find_all("//ows:Title")
  layer <- xml2::xml_parent(ows_title)

  out <- tibble::tibble(layer = xml2::xml_text(ows_title)) |>
    tibble::rowid_to_column("layer_id")
  stickyr::new_sticky_tibble(out,
                             cols = "layer_id",
                             col_show = !"layer_id",
                             attrs = c("gsitiles_wmts", "layer"),
                             gsitiles_wmts = gsitiles_wmts,
                             layer = layer,
                             class = "gsi_wmts",
                             class_grouped_df = "gsi_wmts",
                             class_rowwise_df = "gsi_wmts")
}

#' @export
tbl_sum.gsi_wmts <- function(x) {
  out <- NextMethod()
  names(out)[[1L]] <- "GSI WMTS"
  out
}

#' @importFrom dplyr collect
#' @export
collect.gsi_wmts <- function(x, ...) {
  layer <- attr(x, "layer")
  xml2::xml_remove(layer[!seq_along(layer) %in% x$layer_id])

  attr(x, "gsitiles_wmts")
}
