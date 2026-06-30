
# GO
export PATH="$HOME/go/bin:$PATH"
### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/wind/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# Secrets
if [ -f "$HOME/.secrets" ]; then
    source "$HOME/.secrets"
fi

# Aliases
alias vi='nvim'
alias vim='nvim'
alias python='python3'
alias activate='source .venv/bin/activate'
alias createvenv='python -m venv .venv'
alias ls="eza --icons=always"
alias ll="eza -lh --icons=always"

# Initialize tools
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# FD
# brew install fd
# Define the default fallback command for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
# Feed Ctrl+T (File Search) with the exact same fast fd command
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Feed Alt+C (Directory Search) with fd, filtering down to only directories
export FZF_ALT_C_COMMAND='fd --type d --strip-cwd-prefix --hidden --follow --exclude .git'

# RipGrep (rg)
# brew install ripgrep

# brew install atuin

# FZF
# brew install fzf


# history setup
HISTFILE=$HOME/.zhistory
SAVEHIST=10000
HISTSIZE=10000
setopt share_history         # Share history across sessions
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify
setopt APPEND_HISTORY         # Append to history file, don't overwrite
setopt INC_APPEND_HISTORY     # Write to the history file immediately


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# OMZ libraries - each one earns its spot
zinit snippet OMZL::git.zsh          # Git aliases and functions
zinit snippet OMZL::directories.zsh  # .. / ... / take (mkdir + cd)
zinit snippet OMZL::theme-and-appearance.zsh  # Terminal title, ls colors
zinit snippet OMZL::async_prompt.zsh # Non-blocking git status in prompt
zinit blockf for zsh-users/zsh-completions # completion configurations 

# Load completions efficiently (after prompt is ready)
autoload -Uz compinit && compinit # Run compinit to start Zsh's completion engine

zinit light Aloxaf/fzf-tab # Replaces standard Tab menu with an interactive FZF menu
zinit light zsh-users/zsh-autosuggestions # Asynchronous inline text suggestions based on history
zinit light zdharma-continuum/fast-syntax-highlighting # Feature-rich, highly-optimized Zsh syntax highlighting


# Atuin history
zinit ice wait lucid as"command" from"gh-r" bpick"atuin-*.tar.gz~*server*" mv"atuin*/atuin -> atuin" atclone"./atuin init zsh > init.zsh; ./atuin gen-completions --shell zsh > _atuin" atpull"%atclone" src"init.zsh"
zinit light atuinsh/atuin


# Fzf-tab
# Give fzf-tab a clean, modern boundary layout
zstyle ':fzf-tab:*' fzf-flags --preview-window=hidden:wrap

# Show a quick file/directory preview when using 'cd' or 'ls'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'ls --color=always $realpath'

# Show brief command descriptions/help rules when picking flags
zstyle ':fzf-tab:complete:*:options' fzf-preview 

# eza config - must be set BEFORE loading the plugin
zstyle ':omz:plugins:eza' 'dirs-first' yes
zstyle ':omz:plugins:eza' 'git-status' yes
zstyle ':omz:plugins:eza' 'header' yes
zstyle ':omz:plugins:eza' 'icons' yes

# OMZ plugins
zinit snippet OMZP::git    # 150+ git aliases (gst, gco, gp, etc.)
zinit snippet OMZP::brew   # Homebrew completions
zinit snippet OMZP::direnv # Auto-load .envrc files
zinit snippet OMZP::eza    # ls replacement with icons/git status

# Atuin - synced shell history (load last)
eval "$(atuin init zsh)" # Installed from Homebrew


