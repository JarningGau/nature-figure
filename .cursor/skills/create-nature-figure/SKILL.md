---
name: create-nature-figure
description: >-
  Restyle existing matplotlib, seaborn, and ggplot2 code to Nature publication
  format: column width in millimetres, 5–7 pt Arial or Helvetica, RGB, one
  vector PDF with selectable text, and rasterized dense scatter layers. Use
  when the user asks to apply Nature figure style, match Nature Research
  sizing, or fix figure fonts, themes, or PDF export in Python or R. Does not
  create plots, choose chart types, or write figure files — only refine
  plotting style and export format in existing code.
---

# Create Nature Figure Style

This skill does not generate actual plots. It only refines the plotting style and format.

Edit theme, type, size, colour mode, line weights, and the PDF export in plotting code the user already has. Leave the scientific figure alone.

## Do not

- Choose a chart type, geom, or statistic.
- Add layers, annotations, legends, panels, or trend lines.
- Invent, load, subset, or reshape data.
- Write a new script that draws a figure.
- Run the script or save a PDF, PNG, or any other figure file.
- Change mappings (`x`, `y`, `fill`, `colour`), axis meanings, limits that encode the data, category order, label wording, or existing colour encodings.
- Resize the figure after export, or add `bbox_inches="tight"` / `coord_fixed` cropping that changes the publication size.

If there is no existing plotting code, stop and ask for it. Do not draft a plot.

When an R script and a Python script draw the same figure, apply the same width, height, type sizes, and font. Do not let one language drift.

## Size

`inches = mm / 25.4`. Font sizes in R and Python are already in points.

| Journal | 1 column | 2 columns |
| --- | --- | --- |
| Nature Research | 88 mm | 180 mm |
| Other, or unknown | 85 mm | 175 mm |

Default to Nature Research (88 mm / 180 mm) unless the user names another journal.

Column width is the whole figure, not one panel. Keep a stated panel width when it is already under the column limit. If the script uses a library default or is wider than the column, set the width to the column width and scale the height so the current aspect ratio stays the same. The finished figure stays under the 2-column width. Draw it at that size. Do not scale it later.

## Text, colour, and effects

- Sans-serif. Prefer Arial, then Helvetica, then DejaVu Sans.
- 5–7 pt. Default: 6 pt for titles and axis titles, 5 pt for tick labels and legends.
- RGB, flat colours. Use a gradient only when it is scientifically necessary and still readable at this text size. Do not export CMYK.
- Keep the user's existing palette. Do not recolour a series to "look more Nature".
- No drop shadows, 3D effects, bevels, glows, or outlined text.
- White background. No grid. Black spines and tick marks, about 0.5 pt. Tick length about 1.5–2 pt. Legend frame off. Do not add a legend that is not already there.

## Raster content

Embed photographs, microscopy, gels, and blots in the PDF. The source must be at least 300 dpi at the size used in the figure. Leave low-resolution images at their real resolution. Do not upscale them.

## Scatter layers

| Points | Treatment |
| --- | --- |
| ≤ 100 | Leave vector points as they are. |
| > 100 | Rasterize only the point layer at ≥ 300 dpi. |

Axes, labels, legends, annotations, trend lines, error bars, and confidence bands stay vector. This is a format change to an existing point layer, not a new plot. Do not replace the scatter with hexbin, density, or a summary unless the user asks for that change.

## Python

Apply this after any seaborn theme. Seaborn must not overwrite these settings.

```python
import matplotlib as mpl

mpl.rcParams.update(
    {
        "font.family": "sans-serif",
        "font.sans-serif": ["Arial", "Helvetica", "DejaVu Sans"],
        "font.size": 6,
        "axes.titlesize": 6,
        "axes.labelsize": 6,
        "xtick.labelsize": 5,
        "ytick.labelsize": 5,
        "legend.fontsize": 5,
        "figure.titlesize": 6,
        "pdf.fonttype": 42,
        "ps.fonttype": 42,
        "savefig.dpi": 300,
        "axes.linewidth": 0.5,
        "axes.edgecolor": "black",
        "axes.labelcolor": "black",
        "axes.facecolor": "white",
        "axes.grid": False,
        "figure.facecolor": "white",
        "text.color": "black",
        "xtick.color": "black",
        "ytick.color": "black",
        "xtick.major.width": 0.5,
        "ytick.major.width": 0.5,
        "xtick.major.size": 2,
        "ytick.major.size": 2,
        "legend.frameon": False,
    }
)
```

On each axes that the script already creates:

- `set_axisbelow(False)`, `grid(False)`, `set_facecolor("white")`.
- Spines: linewidth `0.5`, colour black.
- `tick_params(colors="black", width=0.5, length=2, pad=1)`.
- Pass `fontsize=6` for titles and axis titles, `fontsize=5` for tick labels and legends, when those texts already exist.
- `fig.savefig("figure.pdf")` only. `pdf.fonttype` is 42 and `savefig.dpi` is 300. No PNG, JPG, EPS, TIFF, or SVG as the delivered file.
- `rasterized=True` only on the existing scatter layer when that layer has more than 100 points. Leave every other artist at the default `rasterized=False`.
- Set `figsize` in inches from the millimetre width and height above. Prefer the script's existing layout engine (`constrained_layout` or subplots). Do not add `bbox_inches="tight"`.

## R

`base_family = "Arial"`, `base_size = 6`. Merge this into the existing `theme()`; do not replace geoms.

```r
theme_bw(base_size = 6, base_family = "Arial") +
  theme(
    panel.grid = element_blank(),
    plot.title = element_text(size = 6),
    axis.title = element_text(size = 6),
    axis.text = element_text(color = "black", size = 5),
    axis.text.x = element_text(margin = margin(t = 1, unit = "pt")),
    axis.text.y = element_text(margin = margin(r = 1, unit = "pt")),
    axis.ticks.length = unit(1.5, "pt"),
    legend.text = element_text(size = 5),
    legend.background = element_blank(),
    legend.key = element_blank(),
    strip.text = element_text(size = 6),
    plot.subtitle = element_text(size = 5),
    plot.caption = element_text(size = 5)
  )
```

Keep an existing `legend.position`. If the script had no legend theme, do not invent one.

Export:

```r
library(svglite)
library(rsvg)

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
rsvg_pdf(svg_tmp, file = "figure.pdf")
```

Write SVG with `svglite`, then `rsvg::rsvg_pdf`. `cairo_pdf` embeds Arial but inserts bad per-glyph offsets and splits words. Do not use `cairo_pdf`, `pdf()`, `postscript()`, `png()`, `jpeg()`, or `tiff()` for the final file.

For more than 100 points, rasterize only the point layer at 300 dpi (`ggrastr::geom_point_rast`). Keep `geom_line`, `geom_smooth`, `geom_errorbar`, and text geoms as vector.

## Multi-panel figures

If the script already assembles panels, restyle each panel and keep a single PDF export. Do not split panels into separate files, and do not add a new assembly library. Rasterize only the dense point layers. Prefer a file under 50 MB.

## Check the edit

Confirm in the diff, without rendering:

- Final device is one PDF. Text is selectable (`pdf.fonttype` 42 in Python; `svglite` then `rsvg_pdf` in R).
- Width is the journal column, or an existing smaller panel width. Height keeps the previous aspect ratio. No tight bounding box.
- Type is Arial or Helvetica, 5–7 pt, with the 6 pt / 5 pt defaults.
- Grid is off. No shadows, 3D, bevels, or glows.
- Scatter `rasterized` / `geom_point_rast` is set only when that layer has more than 100 points.
- Data, geoms, stats, mappings, and label wording are unchanged.
