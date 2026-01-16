#!/bin/bash

set -euo pipefail

# Java symlink for macOS
if [[ -d "$(brew --prefix)/opt/openjdk/libexec/openjdk.jdk" ]]; then
    echo "Setting up Java symlink..."
    sudo ln -sfn "$(brew --prefix)/opt/openjdk/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk.jdk
    echo "Java setup complete!"
else
    echo "OpenJDK not found, skipping Java setup."
fi
