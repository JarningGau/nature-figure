## Nature-style ggplot2 theme (companion of theme_nature.py).
##
## Usage: source("<skill>/scripts/theme_nature.R") before building the plot.
## It sets theme_nature() as the global default via theme_set(). Export with
##   save_nature_pdf(p, "figure.pdf", width = NATURE_W1, height = ...)
##
## Text is 5-7 pt Arial, background white, no grid, black 0.5 pt axis lines
## and ticks, top/right spines hidden (open axes, same as the Python theme).
## Spacing (tick length, axis-title gap, title gap, legend) is tuned to match
## theme_nature.py.
##
## When the plot has a point legend, shrink its glyphs to match Python's 3 pt
## legend markers (the theme cannot set glyph size):
##   guides(fill = guide_legend(override.aes = list(size = NATURE_LEGEND_POINT_SIZE)))
library(ggplot2)

## Nature Research figure widths (inches)
NATURE_W1 <- 88 / 25.4 # 1 column
NATURE_W2 <- 180 / 25.4 # 2 columns

## ggplot linewidth that renders as 0.5 pt after svglite -> rsvg_pdf
## (1 linewidth = .pt svg px, 1 svg px = 0.75 pt).
NATURE_LINEWIDTH <- 0.5 / (.pt * 0.75)

## geom_point(size) for legend glyphs (~3 pt marker, as in theme_nature.py)
NATURE_LEGEND_POINT_SIZE <- 1

theme_nature <- function(base_size = 6, base_family = "Arial") {
  theme_bw(base_size = base_size, base_family = base_family) +
    theme(
      plot.margin = margin(3, 3, 3, 3, unit = "pt"),
      panel.grid = element_blank(),
      panel.border = element_blank(),
      axis.line = element_line(color = "black", linewidth = NATURE_LINEWIDTH),
      axis.ticks = element_line(color = "black", linewidth = NATURE_LINEWIDTH),
      plot.title = element_text(size = 6, hjust = 0.5, margin = margin(b = 4.8, unit = "pt")),
      axis.title = element_text(size = 6),
      axis.title.x = element_text(margin = margin(t = 4, unit = "pt")),
      axis.title.y = element_text(margin = margin(r = 4, unit = "pt")),
      axis.text = element_text(color = "black", size = 5),
      axis.text.x = element_text(margin = margin(t = 1, unit = "pt")),
      axis.text.y = element_text(margin = margin(r = 1, unit = "pt")),
      axis.ticks.length = unit(2, "pt"),
      legend.text = element_text(size = 5, margin = margin(l = 1.5, unit = "pt")),
      legend.title = element_text(size = 6),
      legend.background = element_blank(),
      legend.key = element_blank(),
      legend.key.width = unit(4, "pt"),
      legend.key.height = unit(5.4, "pt"),
      legend.key.spacing = unit(0, "pt"),
      legend.box.spacing = unit(6, "pt"),
      legend.spacing.x = unit(0, "pt"),
      legend.margin = margin(t = 0, r = 2, b = 0, l = 0, unit = "pt"),
      strip.text = element_text(size = 6),
      strip.background = element_blank(),
      plot.subtitle = element_text(size = 5),
      plot.caption = element_text(size = 5)
    )
}

## global default for every ggplot created after sourcing this file
theme_set(theme_nature())

## Save as a vector PDF with selectable text (svglite -> rsvg; avoid cairo_pdf).
## width/height in inches; defaults to 1-column width.
save_nature_pdf <- function(plot, file, width = NATURE_W1, height = NATURE_W1 / 2) {
  svg_tmp <- tempfile(fileext = ".svg")
  on.exit(unlink(svg_tmp), add = TRUE)
  ggsave(
    filename = svg_tmp, plot = plot,
    width = width, height = height, units = "in",
    device = svglite::svglite
  )
  rsvg::rsvg_pdf(svg_tmp, file = file)
  invisible(file)
}
