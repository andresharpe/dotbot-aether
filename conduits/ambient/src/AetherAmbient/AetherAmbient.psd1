@{
    RootModule        = 'AetherAmbient.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a1b2c3d4-0001-aeth-amb0-000000000001'
    Author            = 'andresharpe'
    Description       = 'Aether Ambient Conduit — Philips Hue light control for dotbot event bus'
    PowerShellVersion = '7.0'
    FunctionsToExport = @(
        'Initialize-AetherAmbient'
        'Find-AetherAmbient'
        'Connect-AetherAmbient'
        'Disconnect-AetherAmbient'
        'Test-AetherAmbient'
        'Invoke-AetherAmbientEvent'
    )
    CmdletsToExport   = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
    PrivateData        = @{
        PSData = @{
            Tags       = @('aether', 'conduit', 'ambient', 'hue', 'dotbot')
            ProjectUri = 'https://github.com/andresharpe/dotbot-aether'
        }
    }
}
