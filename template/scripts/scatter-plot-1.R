setwd("template/scripts")
library(tidyverse)
library(svglite)
library(rsvg)

dir.create("../results", recursive = TRUE, showWarnings = FALSE)

# Nature Research 1-column width. Height keeps the previous aspect ratio.
column_width_mm = 38+12 # panel width + legend width
figure_height_mm = 38
fig_width_in <- column_width_mm / 25.4
fig_height_in <- figure_height_mm / 25.4

fills <- c(
  Plasma = "#FD34AA", `T cell` = "#E78B2A", Macrophage = "#511A5A",
  ILF = "#E8251E", Other = "grey90"
)

df <- read_tsv("../data/scatter-plot-1.tsv", show_col_types = FALSE) %>%
  mutate(cell_type_fill = factor(cell_type_fill, names(fills)))

p <- ggplot(df, aes(median_umi, prop_clone, fill = cell_type_fill)) +
  geom_point(shape = 21, color = "black", size = 1.5) +
  scale_fill_manual(values = fills, name = NULL) +
  scale_y_continuous(labels = scales::percent, limits = c(0, NA)) +
  labs(title = "Y007 PSI (1wk)", x = "Median UMIs", y = "Prop. of cells with clone label") +
  theme_bw(base_size = 6, base_family = "Arial") +
  theme(
    panel.grid = element_blank(),
    plot.title = element_text(hjust = 0.5, size = 6),
    axis.text = element_text(color = "black", size = 5),
    axis.text.x = element_text(margin = margin(t = 1, unit = "pt")),
    axis.text.y = element_text(margin = margin(r = 1, unit = "pt")),
    axis.title = element_text(size = 6),
    axis.ticks.length = unit(1.5, "pt"),
    legend.text = element_text(size = 5),
    legend.position = "right",
    legend.background = element_blank(),
    legend.key = element_blank(),
    legend.key.size = unit(0.25, "cm"),
    legend.spacing.y = unit(0.02, "cm")
  )

# cairo_pdf embeds Arial but writes bad per-glyph TJ offsets (e.g. "Plas ma").
# svglite + rsvg keeps selectable Arial text with natural advances.
svg_tmp <- tempfile(fileext = ".svg")
on.exit(unlink(svg_tmp), add = TRUE)
ggsave(
  filename = svg_tmp,
  plot = p,
  width = fig_width_in,
  height = fig_height_in,
  units = "in",
  device = svglite
)
rsvg_pdf(svg_tmp, file = "../results/scatter-plot-1-R.pdf")
