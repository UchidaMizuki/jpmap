#' Lay out the Japanese Islands
#'
#' @param plot A plot of ggplot2.
#' @param ryukyu Include the Ryukyu Islands in the map? By default, `TRUE`.
#' @param ogasawara Include the Ogasawara Islands in the map? By default,
#' `TRUE`.
#'
#' @return A plot of ggplot2.
#'
#' @export
layout_islands <- function(plot,
                           ryukyu = TRUE,
                           ogasawara = TRUE) {
  xlim_japan <- c(128, 150)
  ylim_japan <- c(30, 46)

  japan <- plot +
    coord_sf(xlim = xlim_japan,
             ylim = ylim_japan)

  if (ryukyu) {
    xlim_ryukyu <- c(122, 132)
    ylim_ryukyu <- c(23, 30)

    ryukyu <- plot +
      coord_sf(xlim = xlim_ryukyu,
               ylim = ylim_ryukyu) +
      theme_void() +
      theme(rect = element_rect(fill = "transparent"))

    japan <- japan +
      ggpp::annotate("plot_npc",
                     npcx = "left",
                     npcy = "top",
                     label = ryukyu)
  }

  if (ogasawara) {
    xlim_ogasawara <- c(141.6, 142.8)
    ylim_ogasawara <- c(26.2, 28)

    ogasawara <- plot +
      coord_sf(xlim = xlim_ogasawara,
               ylim = ylim_ogasawara) +
      theme_void() +
      theme(rect = element_rect(fill = "transparent"))

    japan <- japan +
      ggpp::annotate("plot_npc",
                     npcx = "right",
                     npcy = "bottom",
                     label = ogasawara)
  }
  japan
}
