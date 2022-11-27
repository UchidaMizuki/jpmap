#' Deprecated functions
#'
#' @param plot A plot of ggplot2.
#' @param ryukyu Include the Ryukyu Islands in the map? By default, `TRUE`.
#' @param ogasawara Include the Ogasawara Islands in the map? By default,
#' `TRUE`.
#'
#' @name deprecated
NULL

#' @rdname deprecated
#' @export
layout_islands <- function(plot,
                           ryukyu = TRUE,
                           ogasawara = TRUE) {
  lifecycle::deprecate_warn("0.2.0", "layout_islands()", "layout_japan()")

  layout_japan(plot,
               ryukyu = ryukyu,
               ogasawara = ogasawara)
}
