# Nature-Figure

R and Python scripts for figures that meet Nature publication standards. Plotting rules are in `AGENTS.md`.

## Setup

The environment is managed with [pixi](https://pixi.sh).

```bash
pixi install
pixi run init
```

`pixi run init` writes `.vscode/settings.json` so the editor uses this environment's R and Python.

## Install the skill

The `create-nature-figure` skill restyles existing matplotlib, seaborn, and ggplot2 code to Nature format (column width, 5–7 pt Arial, RGB, one vector PDF, rasterized dense scatter layers). It lives in `.cursor/skills/create-nature-figure/` and bundles `SKILL.md` plus `scripts/theme_nature.py` and `scripts/theme_nature.R`. It follows the open agent skills format, so Cursor, Claude Code, and Codex can all load it.

Clone the repository, then copy the skill folder into your agent's skills directory:

```bash
git clone https://github.com/JarningGau/nature-figure.git
cd nature-figure
```

| Agent | All projects (user-level) | One project |
| --- | --- | --- |
| Cursor | `~/.cursor/skills/` | `<project>/.cursor/skills/` |
| Claude Code | `~/.claude/skills/` | `<project>/.claude/skills/` |
| Codex | `~/.agents/skills/` | `<project>/.agents/skills/` |

For example, to install it for every project:

```bash
# Cursor
mkdir -p ~/.cursor/skills && cp -r .cursor/skills/create-nature-figure ~/.cursor/skills/

# Claude Code
mkdir -p ~/.claude/skills && cp -r .cursor/skills/create-nature-figure ~/.claude/skills/

# Codex
mkdir -p ~/.agents/skills && cp -r .cursor/skills/create-nature-figure ~/.agents/skills/
```

For a single project, replace the destination with the project column, for example `/path/to/your-project/.claude/skills/`. To keep one copy that updates with `git pull`, use `ln -s "$PWD/.cursor/skills/create-nature-figure" <destination>/create-nature-figure` instead of `cp -r`. Both Claude Code and Codex follow symlinked skill folders.

Copy the whole folder, because `SKILL.md` links to the theme files in `scripts/`. Cursor needs a window reload. Claude Code and Codex detect new skills automatically, but restart them if the skill doesn't appear.

To use it, ask the agent to apply the Nature figure style to your plotting script, for example "apply Nature figure style to `plot.py`". You can also invoke it by name:

| Agent | Invocation |
| --- | --- |
| Cursor | `/create-nature-figure` |
| Claude Code | `/create-nature-figure` |
| Codex | `$create-nature-figure` |

The skill only edits style and export code. It does not create plots.

The R theme needs `ggplot2`, `svglite`, and `rsvg`. The Python theme needs `matplotlib`. `pixi install` in this repository provides them. Rasterizing dense R scatter layers also uses `ggrastr`, which you install separately.

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
