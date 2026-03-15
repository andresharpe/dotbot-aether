@{
    RootModule        = 'AetherConsole.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a1b2c3d4-0004-aeth-con0-000000000004'
    Author            = 'andresharpe'
    Description       = 'Aether Console Conduit — Stream Deck control surface for dotbot event bus'
    PowerShellVersion = '7.0'
    FunctionsToExport = @(
        'Initialize-AetherConsole'
        'Find-AetherConsole'
        'Connect-AetherConsole'
        'Disconnect-AetherConsole'
        'Test-AetherConsole'
        'Invoke-AetherConsoleEvent'
    )
    CmdletsToExport   = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
    PrivateData        = @{
        PSData = @{
            Tags       = @('aether', 'conduit', 'console', 'streamdeck', 'dotbot')
            ProjectUri = 'https://github.com/andresharpe/dotbot-aether'
        }
    }
}
