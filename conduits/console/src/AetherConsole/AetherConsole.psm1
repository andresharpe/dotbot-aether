#Requires -Version 7.0

<#
.SYNOPSIS
    Aether Console Conduit — Stream Deck integration.

.DESCRIPTION
    Wraps the DotBot.Sidecar module with the standard Aether conduit interface.
    Translates event bus events into button state/icon updates and accepts
    button press input to invoke dotbot API actions:
      All events     → update button states/icons (running, complete, failed)
      button.pressed → invoke dotbot API (start task, whisper, approve, stop)
      Strip          → status bar (active process count, health)

    Migrates from polling-based to event-driven model.

.NOTES
    Upstream: github.com/andresharpe/StreamDeck (DotBot.Sidecar v0.1.0)
    Protocol: HTTP sidecar (port 7331) + Stream Deck SDK (WebSocket)
#>

$script:ModuleRoot = $PSScriptRoot

foreach ($scope in @('Public', 'Private')) {
    $path = Join-Path $script:ModuleRoot $scope
    if (Test-Path $path) {
        Get-ChildItem -Path $path -Filter '*.ps1' -Recurse | ForEach-Object {
            . $_.FullName
        }
    }
}

#region Conduit Interface

function Initialize-AetherConsole {
    [CmdletBinding()]
    param([hashtable]$Config)
    Write-Verbose "AetherConsole: Initializing..."
}

function Find-AetherConsole {
    [CmdletBinding()]
    param()
    Write-Verbose "AetherConsole: Scanning for Stream Deck..."
}

function Connect-AetherConsole {
    [CmdletBinding()]
    param()
    Write-Verbose "AetherConsole: Connecting..."
}

function Disconnect-AetherConsole {
    [CmdletBinding()]
    param()
    Write-Verbose "AetherConsole: Disconnecting..."
}

function Test-AetherConsole {
    [CmdletBinding()]
    param()
    Write-Verbose "AetherConsole: Testing..."
    return $true
}

function Invoke-AetherConsoleEvent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Event
    )
    Write-Verbose "AetherConsole: Handling event '$($Event.type)'"
}

#endregion

Export-ModuleMember -Function @(
    'Initialize-AetherConsole'
    'Find-AetherConsole'
    'Connect-AetherConsole'
    'Disconnect-AetherConsole'
    'Test-AetherConsole'
    'Invoke-AetherConsoleEvent'
)
