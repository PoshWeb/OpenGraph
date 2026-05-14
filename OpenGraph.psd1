@{
    RootModule = 'OpenGraph.psm1'
    ModuleVersion = '0.1.1'
    GUID = 'be4e4070-1ea6-4a2e-8b6a-c6b7755e5ace'
    Author = 'James Brundage'
    CompanyName = 'Start-Automating'
    Copyright = '(c) 2025-2026 Start-Automating'
    Description = 'Get OpenGraph with PowerShell'
    FunctionsToExport = 'Get-OpenGraph'
    AliasesToExport = 'OpenGraph', 'ogp', 'Test-OpenGraph', 'Test-OGP'
    TypesToProcess = 'OpenGraph.types.ps1xml'
    PrivateData = @{
        PSData = @{
            Tags = @('OpenGraph','SEO','Web','PowerShellWeb' )
            ProjectURI = 'https://github.com/PowerShellWeb/OpenGraph'
            LicenseURI = 'https://github.com/PowerShellWeb/OpenGraph/blob/main/LICENSE'
            ReleaseNotes = @'
> Like It? [Star It](https://github.com/PowerShellWeb/OpenGraph)
> Love It? [Support It](https://github.com/sponsors/StartAutomating)

## OpenGraph 0.1.1

* `Get-OpenGraph` now supports unclosed `<meta>` tags (#23)
* `Test-OpenGraph` and `Test-OGP` are aliases of `Get-OpenGraph` (#22).
  * Additionally, `Get-OpenGraph` now outputs `$false` when no OpenGraph tags are found.
* `Get-OpenGraph` now accepts any pipeline input and number of arguments (#21)
* `Get-OpenGraph` correctly outputs cached results (#20)

---

Additional release notes can be found at [CHANGELOG.md](https://github.com/PowerShellWeb/OpenGraph/blob/main/CHANGELOG.md)
'@        
        }
    }
}

