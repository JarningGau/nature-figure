---
name: create-nature-figure
description: >-
  Restyles existing matplotlib, seaborn, and ggplot2 code to Nature publication
  format using bundled Python and R themes: column width in millimetres, 5–7 pt
  Arial or Helvetica, RGB, one vector PDF with selectable text, and rasterized
  dense scatter layers. Use when the user asks to apply Nature figure style,
  match Nature Research sizing, or fix figure fonts, themes, or PDF export in
  Python or R. Does not create plots, choose chart types, or write figure
  files; it only refines plotting style and export format in existing code.
---

# Create Nature Figure Style

This skill does not generate actual plots. It only refines the plotting style and format.

Edit theme, type, size, colour mode, line weights, and the PDF export in plotting code the user already has. Leave the scientific figure alone.

## Bundled themes

| File | Language | Provides |
| --- | --- | --- |
| [scripts/theme_nature.py](scripts/theme_nature.py) | Python | `apply_theme()`, `style_axes(ax)`, `save_nature_pdf(fig, path)`, `NATURE_W1_IN`, `NATURE_W2_IN` |
| [scripts/theme_nature.R](scripts/theme_nature.R) | R | `theme_nature()` (set as the default), `save_nature_pdf(plot, file, width, height)`, `NATURE_W1`, `NATURE_W2` |

Both themes use the same type sizes, 0.5 pt black lines, no grid, and open axes (no top or right spine). Treat them as the single source of truth for style values; do not copy their settings into the user's script.

Install: copy this folder to `~/.cursor/skills/` (all projects) or `<project>/.cursor/skills/` (one project).

Apply to the user's script (paths relative to this folder; copy the file next to the script if the skill folder is not reachable):

```python
import sys
sys.path.insert(0, "<skill>/scripts")
import theme_nature as tn

tn.apply_theme()          # after any seaborn theme
# ... existing plotting code, figsize from the Size table ...
tn.style_axes(ax)         # each axes the script already creates
tn.save_nature_pdf(fig, "figure.pdf")
```

```r
source("<skill>/scripts/theme_nature.R")   # sets theme_nature() globally
# ... existing plotting code ...
save_nature_pdf(p, "figure.pdf", width = NATURE_W1, height = fig_height_in)
```

If the script already defines its own theme or `rcParams`, replace those style settings with the bundled theme and keep the user's palette, data, geoms, and layout. Load the theme once; do not leave conflicting settings behind.

## Do not

- Choose a chart type, geom, or statistic.
- Add layers, annotations, legends, panels, or trend lines.
- Invent, load, subset, or reshape data.
- Write a new script that draws a figure. Adding the theme import or `source` line and the export call to an existing script is allowed.
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

Default to Nature Research (88 mm / 180 mm) unless the user names another journal. The bundled constants use the Nature Research widths; for another journal compute `mm / 25.4` directly.

Column width is the whole figure, not one panel. Keep a stated panel width when it is already under the column limit. If the script uses a library default or is wider than the column, set the width to the column width and scale the height so the current aspect ratio stays the same. The finished figure stays under the 2-column width. Draw it at that size. Do not scale it later.

## Text, colour, and effects

- Sans-serif. Prefer Arial, then Helvetica, then DejaVu Sans.
- 5–7 pt. Default: 6 pt for titles and axis titles, 5 pt for tick labels and legends.
- RGB, flat colours. Use a gradient only when it is scientifically necessary and still readable at this text size. Do not export CMYK.
- Keep the user's existing palette. Do not recolour a series to "look more Nature".
- No drop shadows, 3D effects, bevels, glows, or outlined text.
- White background. No grid. Black axis lines and tick marks, about 0.5 pt. No top or right spine. Tick length about 1.5–2 pt. Legend frame off. Do not add a legend that is not already there.

## Raster content

Embed photographs, microscopy, gels, and blots in the PDF. The source must be at least 300 dpi at the size used in the figure. Leave low-resolution images at their real resolution. Do not upscale them.

## Scatter layers

| Points | Treatment |
| --- | --- |
| ≤ 100 | Leave vector points as they are. |
| > 100 | Rasterize only the point layer at ≥ 300 dpi. |

Axes, labels, legends, annotations, trend lines, error bars, and confidence bands stay vector. This is a format change to an existing point layer, not a new plot. Do not replace the scatter with hexbin, density, or a summary unless the user asks for that change.

## Python

`theme_nature.apply_theme()` sets fonts, `pdf.fonttype` 42, `savefig.dpi` 600 (minimum 300), line widths, colours, and the legend frame. Seaborn must not overwrite it, so call it after any `sns.set_theme(...)`.

In the existing script:

- Call `style_axes(ax)` on each axes it already creates. Pass `fontsize=6` for existing titles and axis titles, and `fontsize=5` for existing tick labels and legends, when the script sets sizes explicitly.
- `save_nature_pdf(fig, "figure.pdf")` (or `fig.savefig("figure.pdf")`) only. No PNG, JPG, EPS, TIFF, or SVG as the delivered file.
- `rasterized=True` only on the existing scatter layer when that layer has more than 100 points. Leave every other artist at the default `rasterized=False`.
- Set `figsize` in inches from the millimetre width and height above. Prefer the script's existing layout engine (`constrained_layout` or subplots). Do not add `bbox_inches="tight"`.

## R

`theme_nature()` uses `base_family = "Arial"` and `base_size = 6`, and is installed as the default by `source()`. If the script already builds a `theme()`, keep its non-style arguments (for example an existing `legend.position`); do not replace geoms. If the script had no legend theme, do not invent one.

Export with `save_nature_pdf()`, which writes SVG with `svglite` and then converts with `rsvg::rsvg_pdf`. `cairo_pdf` embeds Arial but inserts bad per-glyph offsets and splits words. Do not use `cairo_pdf`, `pdf()`, `postscript()`, `png()`, `jpeg()`, or `tiff()` for the final file.

For more than 100 points, rasterize only the point layer at 300 dpi or more (`ggrastr::geom_point_rast`). Keep `geom_line`, `geom_smooth`, `geom_errorbar`, and text geoms as vector.

## Multi-panel figures

If the script already assembles panels, restyle each panel and keep a single PDF export. Do not split panels into separate files, and do not add a new assembly library. Rasterize only the dense point layers. Prefer a file under 50 MB.

## Check the edit

Confirm in the diff, without rendering:

- The bundled theme is imported or sourced once, with no conflicting `rcParams` or `theme()` settings left behind.
- Final device is one PDF. Text is selectable (`pdf.fonttype` 42 in Python; `svglite` then `rsvg_pdf` in R).
- Width is the journal column, or an existing smaller panel width. Height keeps the previous aspect ratio. No tight bounding box.
- Type is Arial or Helvetica, 5–7 pt, with the 6 pt / 5 pt defaults.
- Grid is off, no top or right spine. No shadows, 3D, bevels, or glows.
- Scatter `rasterized` / `geom_point_rast` is set only when that layer has more than 100 points.
- Data, geoms, stats, mappings, and label wording are unchanged.
