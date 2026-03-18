@{
    RootModule = 'OpenGraph.psm1'
    ModuleVersion = '0.1.1'
    GUID = 'be4e4070-1ea6-4a2e-8b6a-c6b7755e5ace'
    Author = 'JamesBrundage'
    CompanyName = 'Start-Automating'
    Copyright = '(c) 2025 Start-Automating'
    Description = 'Get OpenGraph with PowerShell'
    FunctionsToExport = 'Get-OpenGraph'
    AliasesToExport = 'OpenGraph', 'ogp'
    TypesToProcess = 'OpenGraph.types.ps1xml'
    PrivateData = @{
        PSData = @{
            Tags = @('OpenGraph','SEO','Web','PoshWeb','OpenGraphProtocol')
            ProjectURI = 'https://github.com/PoshWeb/OpenGraph'
            LicenseURI = 'https://github.com/PoshWeb/OpenGraph/blob/main/LICENSE'
            ReleaseNotes = @'
## OpenGraph 0.1.1

* Simplified Module Scaffolding (#14)
* Supporting open or closed tags (#15)
* `Get-OpenGraph -Html` supports direct content (#16)
* `Get-OpenGraph -Url` is now positional and pipeable (#17)
* Improving README (#18)

---

Please: 

* [Like](https://github.com/PoshWeb/OpenGraph)
* [Share](https://github.com/PoshWeb/OpenGraph)
* [Subscribe](https://github.com/PoshWeb/)
* [Support](https://github.com/sponsors/StartAutomating)

Additional history found available in the [CHANGELOG.md](https://github.com/PoshWeb/OpenGraph/blob/main/CHANGELOG.md)
'@        
        }
    }
}

