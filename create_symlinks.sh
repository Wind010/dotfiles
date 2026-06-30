#!/bin/bash
set -e

# Default dotfiles repo location is current directory, or use first argument
GIT_REPO_FOR_DOTFILES="${1:-$(pwd)}"

LINK_PATHS=(
    "$HOME/.wezterm.lua"
    "$HOME/.config/nvim"
    "$HOME/.zshrc"
    "$HOME/.config/tmux/tmux.conf"
    "$HOME/.config/kitty/kitty.conf"
)

TARGET_PATHS=(
    ".wezterm.lua"
    "nvim"
    ".zshrc"
    "tmux.conf"
    "Terminals/Kitty/kitty.conf"
)

case "$(uname)" in
    Darwin)
        LINK_PATHS+=("$HOME/Library/Application Support/Code/User/settings.json")
        TARGET_PATHS+=("VSCode/settings.json")
        LINK_PATHS+=("$HOME/.config/aerospace/aerospace.toml")
        TARGET_PATHS+=("aerospace.toml")
        ;;
    Linux)
        LINK_PATHS+=("$HOME/.config/Code/User/settings.json")
        TARGET_PATHS+=("VSCode/settings.json")
        ;;
    *)
        echo "⚠️ Unsupported OS: $(uname). Skipping VS Code settings symlink."
        ;;
esac

for i in "${!LINK_PATHS[@]}"; do
    LINK_PATH="${LINK_PATHS[$i]}"
    TARGET_PATH="$GIT_REPO_FOR_DOTFILES/${TARGET_PATHS[$i]}"
    PARENT_DIR=$(dirname "$LINK_PATH")

    # Ensure parent directory exists
    if [ ! -d "$PARENT_DIR" ]; then
        echo "📂 Creating parent directory: $PARENT_DIR"
        mkdir -p "$PARENT_DIR"
    fi

    # Remove existing directory/symlink before creating new symlink
    if [ -e "$LINK_PATH" ] || [ -L "$LINK_PATH" ]; then
        echo "🗑️  Removing existing $LINK_PATH"
        rm -rf "$LINK_PATH"
    fi

    echo "🔗 Creating symlink: $LINK_PATH → $TARGET_PATH"
    ln -s "$TARGET_PATH" "$LINK_PATH"
done

echo "✅ Successfully applied dotfiles!