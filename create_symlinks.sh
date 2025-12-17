#!/bin/bash
set -e

# Default dotfiles repo location is current directory, or use first argument
GIT_REPO_FOR_DOTFILES="${1:-$(pwd)}"

declare -A LINK_MAP
LINK_MAP["$HOME/.wezterm.lua"]=".wezterm.lua"
LINK_MAP["$HOME/.config/nvim"]="nvim"
LINK_MAP["$HOME/.config/zsh/.zshrc"]=".zshrc"
LINK_MAP["$HOME/.config/tmux/tmux.conf"]="tmux.conf"

for LINK_PATH in "${!LINK_MAP[@]}"; do
    TARGET_PATH="$GIT_REPO_FOR_DOTFILES/${LINK_MAP[$LINK_PATH]}"
    PARENT_DIR=$(dirname "$LINK_PATH")

    # Ensure the parent directory exists
    if [ ! -d "$PARENT_DIR" ]; then
        echo "📂 Creating parent directory: $PARENT_DIR"
        mkdir -p "$PARENT_DIR"
    fi

    if [ -e "$LINK_PATH" ] || [ -L "$LINK_PATH" ]; then
        echo "$LINK_PATH already exists... recreating symlink."
    fi

    echo "🔗 Creating symlink for $TARGET_PATH to $LINK_PATH"
    ln -sf "$TARGET_PATH" "$LINK_PATH"
done

echo "✅ Successfully applied dotfiles!"