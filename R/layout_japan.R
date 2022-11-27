#' Lay out the Japanese prefectures
#'
#' @param plot A plot of ggplot2.
#' @param ryukyu Include the Ryukyu Islands in the map? By default, `TRUE`.
#' @param ogasawara Include the Ogasawara Islands in the map? By default,
#' `TRUE`.
#'
#' @return A plot of ggplot2.
#'
#' @export
layout_japan <- function(plot,
                         ryukyu = TRUE,
                         ogasawara = TRUE) {
  xlim_japan <- c(128, 150)
  ylim_japan <- c(30, 46)

  japan <- plot +
    ggplot2::coord_sf(xlim = xlim_japan,
                      ylim = ylim_japan)

  theme_inset <- ggplot2::theme_void() +
    ggplot2::theme(line = ggplot2::element_blank(),
                   rect = ggplot2::element_rect(fill = "transparent",
                                                color = "dimgray"),
                   text = ggplot2::element_blank(),
                   title = ggplot2::element_blank(),
                   legend.position = "none")

  if (ryukyu) {
    xlim_ryukyu <- c(122, 132)
    ylim_ryukyu <- c(23, 30)

    ryukyu <- plot +
      ggplot2::coord_sf(xlim = xlim_ryukyu,
                        ylim = ylim_ryukyu) +
      theme_inset
    ryukyu <- facet_data(ryukyu)

    japan <- japan +
      ggpp::geom_plot_npc(data = ryukyu,
                          ggplot2::aes(label = .data$.rows),
                          npcx = "left",
                          npcy = "top")
  }

  if (ogasawara) {
    xlim_ogasawara <- c(141.6, 142.8)
    ylim_ogasawara <- c(26.2, 28)

    ogasawara <- plot +
      ggplot2::coord_sf(xlim = xlim_ogasawara,
                        ylim = ylim_ogasawara) +
      theme_inset
    ogasawara <- facet_data(ogasawara)

    japan <- japan +
      ggpp::geom_plot_npc(data = ogasawara,
                          ggplot2::aes(label = .data$.rows),
                          npcx = "right",
                          npcy = "bottom")
  }
  japan
}
