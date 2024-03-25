
# Aliases
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Set-Alias -Name su -Value Start-AdminSession
Set-Alias -Name touch -Value New-File
Set-Alias -Name df -Value Get-Volume
Set-Alias -Name which -Value Show-Command
Set-Alias -Name ls -Value Get-ChildItemPretty
Set-Alias -Name ll -Value Get-ChildItemPretty
Set-Alias -Name la -Value Get-ChildItemPretty
Set-Alias -Name l -Value Get-ChildItemPretty
Set-Alias -Name vim -Value nvim
Set-Alias -Name vi -Value nvim
Set-Alias -Name cat -Value bat
Set-Alias -Name python2 -Value "$HOME\.pyenv\pyenv-win\versions\2.7\python.exe"
Set-Alias -Name python3 -Value python
Set-Alias -Name neovide -Value Neovide-Frameless
$Env:BAT_THEME = "gruvbox-dark"

# Functions 
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
function Neovide-Frameless {
   <#
    .SYNOPSIS
        Starts neovide with no frame as its ugly. Alias: neovide
   #>
    Start-Process neovide -ArgumentList '--frame none' @args
}

function Start-AdminSession {
    <#
    .SYNOPSIS
        Starts a new PowerShell session with elevated rights. Alias: su
    #>
    Start-Process wezterm -Verb runAs -WindowStyle Hidden -ArgumentList "start --cwd $PWD"
}

function New-File {
    <#
    .SYNOPSIS
        Creates a new file with the specified name and extension. Alias: touch
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Name
    )

    Write-Verbose "Creating new file '$Name'"
    New-Item -ItemType File -Name $Name -Path $PWD | Out-Null
}

function Show-Command {
    <#
    .SYNOPSIS
	Displays the definition of a command. Alias: which
    #>
    [CmdletBinding()]
    param (
	[Parameter(Mandatory = $true, Position = 0)]
	[string]$Name
    )
    Write-Verbose "Showing definition of '$Name'"
    Get-Command $Name | Select-Object -ExpandProperty Definition
}


function Get-ChildItemPretty {
    <#
    .SYNOPSIS
        Runs eza with a specific set of arguments. Plus some line breaks before and after the output.
        Alias: ls, ll, la, l
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, Position = 0)]
        [string]$Path = $PWD
    )

    Write-Host ""
    eza -a -l --header --icons --hyperlink --time-style relative $Path
    Write-Host ""
}

# Prompt
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Invoke-Expression (&starship init powershell)
Invoke-Expression (& { ( zoxide init powershell --cmd cd | Out-String ) })
Import-Module -Name Terminal-Icons
Set-PSReadLineOption -BellStyle None
Set-PSReadLineOption -PredictionSource History

# Fzf
Import-Module PSFzf
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'

