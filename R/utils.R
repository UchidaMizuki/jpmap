facet_data <- function(plot) {
  facet_vars <- plot$facet$vars()

  if (is_empty(facet_vars)) {
    data_frame(.rows = list(plot))
  } else {
    plot_data <- as.data.frame(plot$data)[facet_vars]
    facet_data <- unique(plot_data)

    .rows <- purrr::modify(vec_chop(facet_data),
                           function(facet_data) {
                             alpha <- ifelse(vec_equal(plot_data, facet_data),
                                             1,
                                             0)

                             plot +
                               aes(alpha = .env$alpha) +
                               scale_alpha_identity() +
                               facet_null()
                           })

    vec_cbind(facet_data,
              .rows = .rows)
  }
}
