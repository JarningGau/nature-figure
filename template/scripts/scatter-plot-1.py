from pathlib import Path

import matplotlib as mpl
import matplotlib.pyplot as plt
import pandas as pd
from matplotlib.lines import Line2D
from matplotlib.ticker import PercentFormatter

script_dir = Path(__file__).resolve().parent
data_path = script_dir / "../data/scatter-plot-1.tsv"
results_dir = script_dir / "../results"
results_dir.mkdir(parents=True, exist_ok=True)

# Nature Research 1-column width. Height keeps the previous aspect ratio.
column_width_mm = 38+12 # panel width + legend width
figure_height_mm = 38
fig_width_in = column_width_mm / 25.4
fig_height_in = figure_height_mm / 25.4

fills = {
    "Plasma": "#FD34AA",
    "T cell": "#E78B2A",
    "Macrophage": "#511A5A",
    "ILF": "#E8251E",
    "Other": "#E5E5E5",  # R grey90
}

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
        "savefig.dpi": 300,
    }
)

df = pd.read_csv(data_path, sep="\t")
df["cell_type_fill"] = pd.Categorical(
    df["cell_type_fill"], categories=list(fills.keys()), ordered=True
)

n_points = len(df)
rasterize_points = n_points > 100

fig, ax = plt.subplots(figsize=(fig_width_in, fig_height_in), constrained_layout=True)

# ggplot size=1.5 ≈ 1.5 mm diameter → ~4.25 pt → area ≈ π*(d/2)^2
marker_area = 3.14159 * ((1.5 / 25.4 * 72) / 2) ** 2

for category, color in fills.items():
    subset = df[df["cell_type_fill"] == category]
    ax.scatter(
        subset["median_umi"],
        subset["prop_clone"],
        s=marker_area,
        facecolors=color,
        edgecolors="black",
        linewidths=0.4,
        zorder=3 if category != "Other" else 2,
        rasterized=rasterize_points,
    )

ax.set_title("Y007 PSI (1wk)", fontsize=6)
ax.set_xlabel("Median UMIs", fontsize=6)
ax.set_ylabel("Prop. of cells with clone label", fontsize=6)
ax.set_ylim(bottom=0)
ax.yaxis.set_major_formatter(PercentFormatter(xmax=1.0, decimals=0))

ax.set_axisbelow(False)
ax.grid(False)
ax.set_facecolor("white")
for spine in ax.spines.values():
    spine.set_linewidth(0.5)
    spine.set_color("black")
ax.tick_params(colors="black", width=0.5, length=2, pad=1)

legend_handles = [
    Line2D(
        [0],
        [0],
        marker="o",
        color="none",
        markerfacecolor=color,
        markeredgecolor="black",
        markeredgewidth=0.4,
        markersize=3,
        label=label,
    )
    for label, color in fills.items()
]
legend = ax.legend(
    handles=legend_handles,
    loc="center left",
    bbox_to_anchor=(1.02, 0.5),
    bbox_transform=ax.transAxes,
    frameon=False,
    handletextpad=0.3,
    labelspacing=0.15,
    handlelength=0.8,
    fontsize=5,
)

fig.savefig(results_dir / "scatter-plot-1-py.pdf")
plt.close(fig)
