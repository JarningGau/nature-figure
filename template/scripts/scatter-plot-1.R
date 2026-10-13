setwd("template/scripts")
library(tidyverse)
library(svglite)
library(rsvg)
source("../../.cursor/skills/create-nature-figure/scripts/theme_nature.R")

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
  guides(fill = guide_legend(override.aes = list(size = NATURE_LEGEND_POINT_SIZE))) +
  theme(legend.position = "right")

# cairo_pdf embeds Arial but writes bad per-glyph TJ offsets (e.g. "Plas ma").
# svglite + rsvg keeps selectable Arial text with natural advances.
save_nature_pdf(p, "../results/scatter-plot-1-R.pdf", width = fig_width_in, height = fig_height_in)
