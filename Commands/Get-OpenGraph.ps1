function Get-OpenGraph 
{
    <#
    .SYNOPSIS
        Gets Open Graph metadata for a given URL.
    .DESCRIPTION
        Gets Open Graph metadata for a given URL.
        
        [Open Graph](https://ogp.me/) is a protocol that enables any web page to become a rich object in a social graph.

        It is used many social networks to display rich content when links are shared.
        
        This function retrieves the Open Graph metadata from a given URL and returns it as a custom object.
    .EXAMPLE        
        Get-OpenGraph -Url https://abc.com/
    .EXAMPLE        
        'https://thebulwark.com/' | Get-OpenGraph
    .EXAMPLE
        OpenGraph https://posh.pckt.blog/static-sites-are-simple-6u51kgj        
    #>
    [Alias('openGraph','ogp','Test-OpenGraph', 'Test-OGP')]
    [CmdletBinding(PositionalBinding=$false)]
    param(
    # A list of any arguments. 
    # This allows the command to take natural input.    
    [Parameter(ValueFromRemainingArguments)]
    [Alias('Argument','Arguments','Args')]
    [PSObject[]]
    $ArgumentList,
    
    # The URL that may contain Open Graph metadata 
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Url,

    # Any HTML that may contain open graph metadata.
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Html,

    # A dictionary of additional Open Graph metadata to include in the result
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $Data,

    # If set, forces the function to retrieve the Open Graph metadata even if it is already cached.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Force,

    # Any number of input objects
    [Parameter(ValueFromPipeline)]
    [Alias('Input')]
    [PSObject[]]
    $InputObject
    )

    begin {
        # Make a regex to match meta tags
        $metaRegex = [Regex]::new('<meta.+?/?>','IgnoreCase','00:00:00.1')
        if (-not $script:OpenGraphCache) {
            $script:OpenGraphCache = [Ordered]@{}
        }

        filter OpenGraphFromData {
            $data = $_ -as [Collections.IDictionary]
            $openGraphMetadata = [Ordered]@{PSTypeName='OpenGraph'}
            foreach ($key in $Data.Keys) {
                $openGraphMetadata[$key] = $Data[$key]
            }
            [PSCustomObject]$openGraphMetadata
        }

        filter OpenGraphFromUrl {
            $url = $_ -as [uri]            
            if ($script:OpenGraphCache[$url] -and -not $Force) {                
                return $script:OpenGraphCache[$url]
            }

            $script:OpenGraphCache[$url] = Invoke-RestMethod -Uri $Url | 
                OpenGraphFromHtml
            $script:OpenGraphCache[$url]
        }

        filter OpenGraphFromHtml {
            $text = "$_"
            $openGraphMetadata = [Ordered]@{PSTypeName='OpenGraph'}
            foreach ($match in $metaRegex.Matches($text)) {
                $matchXml = (
                    # close unclosed `<meta>` tags.
                    "$match" -replace '/?>$','/>'
                ) -as [xml]

                if ($matchXml.meta.property -and $matchXml.meta.content) {
                    $openGraphMetadata[$matchXml.meta.property] = $matchXml.meta.content
                }
            }
            [PSCustomObject]$openGraphMetadata
        }
    }

    process {
        # Turn any of our strongly bound parameters into arguments
        if ($Url) {$Url | OpenGraphFromUrl }
        # If any data was provided
        if ($Data) {$Data | OpenGraphFromData }

        if ($html) { $Html | OpenGraphFromHtml }
        
        if ($InputObject) {
            $ArgumentList = @($ArgumentList) + $InputObject
        }
        
        :nextArgument foreach ($argument in $argumentList) {
            # Declare an empty object to hold the Open Graph metadata            
            if (-not $argument) { continue }
            $openGraphMetadata = [Ordered]@{PSTypeName='OpenGraph'}            
            
            $openGraphMetadata = if ($argument -as [uri] -and 
                $argument -match '^https?://'
            ) {
                $argument -as [uri] | OpenGraphFromUrl
            } elseif ($argument -is [Collections.IDictionary]) {
                $argument | OpenGraphFromData
            } 
            elseif ($argument -is [string] -and 
                $argument -match '\<meta') {
                $argument | OpenGraphFromHtml
            }
            else {
                Write-Warning (
                    @(
                        "Unsupported argument:"
                        "[uri],[Collections.IDictionary], and [string]s matching <meta> are supported: $argument"
                    ) -join [Environment]::NewLine
                )
                continue nextArgument
            }
                    
            # If there was no metadata
            if (@($openGraphMetadata.psobject.properties).Count -le 1) {
                # output false (so `Test-` verb scenarios are met)
                $false
                # and continue to the next argument.
                continue nextArgument
            }

            $openGraphMetadata
        }

        $ArgumentList = @()
    }
}