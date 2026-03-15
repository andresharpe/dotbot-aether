@{
    RootModule        = 'AetherSonic.psm1'
    ModuleVersion     = '1.0.0'
    GUID              = 'a1b2c3d4-0003-aeth-snc0-000000000003'
    Author            = 'andresharpe'
    Description       = 'Aether Sonic Conduit — JBL PartyBox light + sound for dotbot event bus'
    PowerShellVersion = '7.0'
    FunctionsToExport = @(
        'Initialize-AetherSonic'
        'Find-AetherSonic'
        'Connect-AetherSonic'
        'Disconnect-AetherSonic'
        'Test-AetherSonic'
        'Invoke-AetherSonicEvent'
    )
    CmdletsToExport   = @()
    VariablesToExport  = @()
    AliasesToExport    = @()
    PrivateData        = @{
        PSData = @{
            Tags       = @('aether', 'conduit', 'sonic', 'jbl', 'partybox', 'dotbot')
            ProjectUri = 'https://github.com/andresharpe/dotbot-aether'
        }
    }
}
