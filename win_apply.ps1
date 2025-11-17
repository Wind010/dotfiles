param(
    [Parameter(Mandatory=$false)]
    [string]$GitRepoForDotfiles = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

$LinkMap = @{
    "$HOME\.wezterm.lua" = ".wezterm.lua";
    "$HOME\AppData\Local\nvim" = "nvim"
}

foreach ($entry in $LinkMap.GetEnumerator()) {
    $LinkPath = $entry.Key
    $TargetPath = Join-Path -Path $GitRepoForDotfiles -ChildPath $entry.Value

    if (Test-Path -Path $LinkPath) {
        Write-Host "$LinkPath already exists... removing"
        Remove-Item -Path $LinkPath -Force
    }

    Write-Host "Creating symlink for $TargetPath to $LinkPath" -ForegroundColor Cyan

    try {
        New-Item -ItemType SymbolicLink -Path $LinkPath -Target $TargetPath
    }
    catch {
        Write-Host "Error creating symbolic link: $($_.Exception.Message)"
        exit 1
    }
} 

Write-Host "Successfully applied dotfiles!" -ForegroundColor Green
