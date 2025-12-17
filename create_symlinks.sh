#!/bin/bash
set -e

# Default dotfiles repo location is current directory, or use first argument
GIT_REPO_FOR_DOTFILES="${1:-$(pwd)}"

declare -A LINK_MAP
LINK_MAP["$HOME/.wezterm.lua"]=".wezterm.lua"
LINK_MAP["$HOME/.config/nvim"]="nvim"
LINK_MAP["$HOME/.zshrc"]=".zshrc"
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


echo "Refresh Oh-My-Zsh plugins"

# Define plugin repositories and their target directories
declare -A plugins=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting"
)

ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

for plugin in "${!plugins[@]}"; do
    plugin_dir="$ZSH_CUSTOM/plugins/$plugin"
    repo_url="${plugins[$plugin]}"

    if [ -d "$plugin_dir" ]; then
        echo "Updating $plugin..."
        git -C "$plugin_dir" pull
    else
        echo "Cloning $plugin..."
        git clone "$repo_url" "$plugin_dir"
    fi
done

echo "✅ Successfully refreshed Oh-My-Zsh plugins!"
