@{
    RootModule        = 'AetherCounter.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a1b2c3d4-0005-aeth-cnt0-000000000005'
    Author            = 'andresharpe'
    Description       = 'Aether Counter Conduit — ESC/POS thermal printer for dotbot cost tallies and reckonings'
    PowerShellVersion = '7.0'
    FunctionsToExport = @(
        'Initialize-AetherCounter'
        'Find-AetherCounter'
        'Connect-AetherCounter'
        'Disconnect-AetherCounter'
        'Test-AetherCounter'
        'Invoke-AetherCounterEvent'
    )
    CmdletsToExport   = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
    PrivateData        = @{
        PSData = @{
            Tags       = @('aether', 'conduit', 'counter', 'printer', 'escpos', 'dotbot')
            ProjectUri = 'https://github.com/andresharpe/dotbot-aether'
        }
    }
}
