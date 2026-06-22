#!/bin/bash

set -euo pipefail

# Install Nix only (flakes enabled by default via the Determinate installer).
# nix-darwin の反映 (darwin-rebuild switch) は手動で行う。
# chezmoi apply のたびに macOS のシステム設定を上書きしないため。
if ! command -v nix >/dev/null 2>&1; then
    echo "Installing Nix..."
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --no-confirm
    echo "Nix installation complete!"
else
    echo "Nix already installed, skipping."
fi
