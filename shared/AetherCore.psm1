#Requires -Version 7.0

<#
.SYNOPSIS
    Aether Core — shared conduit base module.

.DESCRIPTION
    Provides the shared foundation for all Aether conduits:
    - Conduit lifecycle management (initialize, connect, disconnect, test)
    - Event envelope parsing and routing
    - Hardware discovery base patterns (LAN scan, ARP, N-UPnP)
    - Bond state persistence
    - Graceful degradation when hardware is unavailable

.NOTES
    Part of dotbot-aether — the Aether Conduit Plugin Collection.
    Consumed by individual conduit modules, not directly by dotbot.
#>

# Module-scoped state
$script:RegisteredConduits = @{}
$script:ConduitStates = @{}

#region Public Functions

function Register-AetherConduit {
    <#
    .SYNOPSIS
        Registers a conduit with the Aether core.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Name,

        [Parameter(Mandatory)]
        [ValidateSet('ambient', 'window', 'sonic', 'console', 'counter')]
        [string]$Type,

        [Parameter(Mandatory)]
        [hashtable]$Handlers
    )

    $script:RegisteredConduits[$Name] = @{
        Type     = $Type
        Handlers = $Handlers
        State    = 'registered'
    }

    Write-Verbose "Aether: Registered conduit '$Name' (type: $Type)"
}

function Get-AetherConduit {
    <#
    .SYNOPSIS
        Returns registered conduit(s).
    #>
    [CmdletBinding()]
    param(
        [string]$Name
    )

    if ($Name) {
        return $script:RegisteredConduits[$Name]
    }
    return $script:RegisteredConduits
}

function Invoke-AetherEvent {
    <#
    .SYNOPSIS
        Routes an event envelope to all registered conduits that subscribe to it.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [hashtable]$Event
    )

    $eventType = $Event.type
    if (-not $eventType) {
        Write-Warning "Aether: Event envelope missing 'type' property"
        return
    }

    foreach ($conduitName in $script:RegisteredConduits.Keys) {
        $conduit = $script:RegisteredConduits[$conduitName]
        if ($conduit.State -ne 'connected') { continue }

        try {
            $handler = $conduit.Handlers['InvokeEvent']
            if ($handler) {
                & $handler -Event $Event
            }
        }
        catch {
            Write-Warning "Aether: Conduit '$conduitName' failed to handle event '$eventType': $_"
        }
    }
}

function Read-AetherManifest {
    <#
    .SYNOPSIS
        Reads and parses a conduit.manifest.json file.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$Path
    )

    $manifestPath = Join-Path $Path 'conduit.manifest.json'
    if (-not (Test-Path $manifestPath)) {
        throw "Aether: Manifest not found at '$manifestPath'"
    }

    Get-Content $manifestPath -Raw | ConvertFrom-Json
}

function Read-ConduitDescriptor {
    <#
    .SYNOPSIS
        Reads and parses a conduit.json descriptor file.
    #>
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ConduitPath
    )

    $descriptorPath = Join-Path $ConduitPath 'conduit.json'
    if (-not (Test-Path $descriptorPath)) {
        throw "Aether: Conduit descriptor not found at '$descriptorPath'"
    }

    Get-Content $descriptorPath -Raw | ConvertFrom-Json
}

#endregion

Export-ModuleMember -Function @(
    'Register-AetherConduit'
    'Get-AetherConduit'
    'Invoke-AetherEvent'
    'Read-AetherManifest'
    'Read-ConduitDescriptor'
)
