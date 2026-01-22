# OH-MY-POSH stuff here.
# winget install JanDeDobbeleer.OhMyPosh --source winget
oh-my-posh init pwsh --config 'powerlevel10k_rainbow' | Invoke-Expression

#Install-Module posh-git -Scope CurrentUser -Force
Import-Module posh-git

# Install-Module -Name Terminal-Icons -Repository PSGallery -Force
Import-Module Terminal-Icons

# Install-Module -Name Z -Force
Import-Module Z

# Install-Module -Name PSReadLine -AllowPrerelease -Scope CurrentUser -Force -SkipPublisherCheck
Set-PSReadLineOption -PredictionSource History

# Install-Module -Name PSFzf -Scope CurrentUser -Force
Set-PsFzfOption -PsReadLineChordProvider 'Ctrl+f' -PSReadLineChordReverseHistory 'Ctrl+r'

# Aliases
Set-Alias vim nvim
Set-Alias vi nvim
Set-Alias grep findstr
Set-Alias k kubectl
Set-Alias createvenv "python3 -m venv .venv"
Set-Alias activate .\.venv\Scripts\Activate.ps1

# Utilities
function which ($command) {
    Get-Command -Name $command -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty Path -ErrorAction SilentlyContinue
}
