@{
    RootModule        = 'AetherWindow.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a1b2c3d4-0002-aeth-win0-000000000002'
    Author            = 'andresharpe'
    Description       = 'Aether Window Conduit — Pixoo-64 visual display for dotbot event bus'
    PowerShellVersion = '7.0'
    FunctionsToExport = @(
        'Initialize-AetherWindow'
        'Find-AetherWindow'
        'Connect-AetherWindow'
        'Disconnect-AetherWindow'
        'Test-AetherWindow'
        'Invoke-AetherWindowEvent'
    )
    CmdletsToExport   = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
    PrivateData        = @{
        PSData = @{
            Tags       = @('aether', 'conduit', 'window', 'pixoo', 'dotbot')
            ProjectUri = 'https://github.com/andresharpe/dotbot-aether'
        }
    }
}
