#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
r_env="${1:-default}"

case "${r_env}" in
    default|decoupler)
        ;;
    *)
        echo "Unknown R environment: ${r_env}" >&2
        echo "Usage: bash env/use-r-env.sh [default|decoupler]" >&2
        exit 1
        ;;
esac

mkdir -p "${ROOT}/.vscode"

cat > "${ROOT}/.vscode/settings.json" <<EOF
{
    "r.rpath.linux": "\${workspaceFolder}/.pixi/envs/${r_env}/bin/R",
    "r.rterm.linux": "\${workspaceFolder}/.pixi/envs/${r_env}/bin/R",
    "r.env": {
        "RETICULATE_PYTHON": "\${workspaceFolder}/.pixi/envs/${r_env}/bin/python"
    },
    "python.terminal.activateEnvironment": false
}
EOF
