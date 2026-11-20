#Requires -RunAsAdministrator

$symlinks = @{
    $PROFILE.CurrentUserAllHosts       = ".\Profile.ps1"
    "$HOME\AppData\Local\nvim"         = ".\nvim"
    "$HOME\.gitconfig"                 = ".\.gitconfig"
    "$HOME\AppData\Roaming\lazygit"    = ".\lazygit"
    "$HOME\.config\wezterm"            = ".\wezterm"
    "$HOME\.config\starship.toml"      = ".\starship.toml"
    "$HOME\.config\mise"               = ".\mise"
    "$HOME\AppData\Roaming\alacritty"  = ".\alacritty"
    "$HOME\.config\zellij"             = ".\zellij"
    "$HOME\.pi"                        = ".\.pi"
    "$HOME\.claude"                    = ".\.claude"
}

# Set working directory
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot

Write-Host "Creating symbolic links..." -ForegroundColor Cyan

foreach ($entry in $symlinks.GetEnumerator()) {
    $linkPath   = $entry.Key
    $targetPath = Join-Path $PSScriptRoot $entry.Value

    # Delete existing link or file directly (handles dangling links)
    Remove-Item -LiteralPath $linkPath -Force -Recurse -ErrorAction SilentlyContinue

    # Create new symbolic link
    if (Test-Path -LiteralPath $targetPath) {
        New-Item -ItemType SymbolicLink -Path $linkPath -Target $targetPath -Force | Out-Null
        Write-Host "Successfully linked: $linkPath -> $targetPath" -ForegroundColor Green
    } else {
        Write-Warning "Target path does not exist: $targetPath"
    }
}
