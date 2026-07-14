#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"

for command in git jq nvim stylua; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'missing required check dependency: %s\n' "$command" >&2
    exit 1
  fi
done

stylua --check init.lua lua
jq empty lazy-lock.json snippets/package.json snippets/latex.json
git diff --check

tmpdir=$(mktemp -d)
trap 'rm -rf -- "$tmpdir"' EXIT
mkdir -p "$tmpdir/cache" "$tmpdir/runtime" "$tmpdir/state"

XDG_CACHE_HOME="$tmpdir/cache" \
XDG_RUNTIME_DIR="$tmpdir/runtime" \
XDG_STATE_HOME="$tmpdir/state" \
NVIM_LOG_FILE="$tmpdir/nvim.log" \
  nvim --headless \
    --startuptime "$tmpdir/startuptime.log" \
    "+lua assert(vim.fn.has('nvim-0.11.3') == 1, 'Neovim 0.11.3 or newer is required')" \
    "+lua assert(require('lazy.core.config').plugins['zen-mode.nvim'], 'zen-mode.nvim spec is missing')" \
    "+lua require('functions'); assert(vim.fn.exists(':ToUTF8') == 2, ':ToUTF8 is missing')" \
    "+qa"

printf 'Neovim configuration checks passed.\n'
