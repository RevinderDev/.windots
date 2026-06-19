#Requires -RunAsAdministrator

$symlinks = @{
	$PROFILE.CurrentUserAllHosts	   = ".\Profile.ps1"
	"$HOME\AppData\Local\nvim"   	   = ".\nvim"
	"$HOME\.gitconfig"            	   = ".\.gitconfig"
	"$HOME\AppData\Roaming\lazygit"    = ".\lazygit"
	"$HOME\.config\wezterm"            = ".\wezterm"
	"$HOME\.config\starship.toml"	   = ".\starship.toml"
	"$HOME\.config\mise"               = ".\mise"
	"$HOME\AppData\Roaming\alacritty\" = ".\alacritty"
	"$HOME\.config\zellij"		   = ".\zellij"
}

# Set Working directory
Set-Location $PSScriptRoot
[Environment]::CurrentDirectory = $PSScriptRoot


Write-Host "Creating symbolic links"

foreach ($symlink in $symlinks.GetEnumerator()) {
	Get-Item -Path $symlink.Key -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
	New-Item -ItemType SymbolicLink -Path $symlink.Key -Target (Resolve-Path $symlink.Value) -Force | Out-Null
}



$wingetDeps = @(
    "Chocolatey.Chocolatey"
    "Git.Git"
    "GitHub.Cli"
    "JanDeDobbeleer.OhMyPosh"
    "alacritty"
)

$chocoDeps = @(
    "fd"
    "nerd-fonts-jetbrainsmono"
    "nerd-fonts-iosevka"
)

$psModules = @(
    "ps-color-scripts"
    "PSScriptAnalyzer"
    "CompletionPredictor"
    "PSFzf"
    "PSReadLine"
)


Write-Host "Installing missing dependencies..."
$installedWingetDeps = winget list | Out-String
foreach ($wingetDep in $wingetDeps) {
    if ($installedWingetDeps -notmatch $wingetDep) {
        winget install -e --id $wingetDep
    }
}

# Path Refresh
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")

$installedChocoDeps = (choco list --limit-output --id-only).Split("`n")
foreach ($chocoDep in $chocoDeps) {
    if ($installedChocoDeps -notcontains $chocoDep) {
        choco install $chocoDep -y
    }
}

# # Install PS Modules
foreach ($psModule in $psModules) {
    if (!(Get-Module -ListAvailable -Name $psModule)) {
        Install-Module -Name $psModule -Force -AcceptLicense -Scope CurrentUser
    }
}
