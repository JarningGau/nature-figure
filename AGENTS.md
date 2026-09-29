Do
- Manage the env with pixi.
- Run code with `pixi run ...`.

Do NOT
- Read references/human-only.
- Use the superpowers skill.

## Figures

Save every final figure as one PDF, drawn at publication size. Text stays selectable. Lines, axes, labels, legends, arrows, boxes, and scale bars stay vector. No drop shadows, 3D effects, bevels, glows, or outlined text. Prefer a file under 50 MB.

`inches = mm / 25.4`. Font sizes in R and Python are already in points.

### Size

| Journal | 1 column | 2 columns |
| --- | --- | --- |
| Nature Research | 88 mm | 180 mm |
| Other, or unknown | 85 mm | 175 mm |

Column width is the whole figure, not one panel. For a single panel, size the panel from the text size below. The finished figure stays under the 2-column width.

### Text and colour

- Sans-serif. Prefer Arial or Helvetica.
- 5–7 pt. Default: 6 pt for titles and axis titles, 5 pt for tick labels and legends.
- RGB, flat colours. Use a gradient only when it is scientifically necessary and still readable at this text size.

### Raster content

Embed photographs, microscopy, gels, and blots in the PDF. The source must be at least 300 dpi at the size used in the figure. Leave low-resolution images at their real resolution.

### Scatter plots

| Points | Treatment |
| --- | --- |
| ≤ 100 | Vector points are fine. |
| > 100 | Rasterize only the point layer at ≥ 300 dpi. |

Axes, labels, legends, annotations, trend lines, error bars, and confidence bands stay vector. When points heavily overlap, use smaller markers, transparency, hexbin, 2D density, or a summary instead of one vector marker per point.

Assemble multi-panel figures in R or Python and export one PDF. Rasterize only the dense point layers.

### Python

- `fig.savefig("figure.pdf")` with `pdf.fonttype = 42` and `savefig.dpi = 300`.
- `rasterized=True` only on the scatter layer when there are more than 100 points.
- If using seaborn, apply Matplotlib font and PDF settings after the seaborn theme.

### R

- `base_family = "Arial"`, `base_size = 6`.
- Write SVG with `svglite`, then `rsvg::rsvg_pdf`. `cairo_pdf` embeds Arial but inserts bad per-glyph offsets and splits words.
- For more than 100 points, rasterize only the point layer at 300 dpi (`ggrastr::geom_point_rast`).
