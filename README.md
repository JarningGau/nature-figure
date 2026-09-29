# Nature-Figure

R and Python scripts for figures that meet Nature publication standards. Plotting rules are in `AGENTS.md`.

## Setup

The environment is managed with [pixi](https://pixi.sh).

```bash
pixi install
pixi run init
```

`pixi run init` writes `.vscode/settings.json` so the editor uses this environment's R and Python.

## Example

From the repository root:

```bash
pixi run Rscript template/scripts/scatter-plot-1.R
pixi run python template/scripts/scatter-plot-1.py
```

Both write a PDF to `template/results/`. The R script sets its working directory to `template/scripts`, so run it from the repository root.

## Layout

| Path | Contents |
| --- | --- |
| `template/scripts/` | One script per figure. R and Python versions share a name when both exist. |
| `template/data/` | Input tables. |
| `template/results/` | Generated PDFs. Gitignored. |
| `references/` | Plotting guidelines. |
| `env/` | Editor setup scripts. |
| `pixi.toml` | R and Python dependencies. |
