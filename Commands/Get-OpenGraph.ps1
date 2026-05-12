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
        'https://cnn.com/',
            'https://msnbc.com/',
                'https://fox.com/' |
                    Get-OpenGraph
    #>
    [Alias('openGraph','ogp')]
    [CmdletBinding(PositionalBinding=$false)]
    param(        
    # The URL that may contain Open Graph metadata 
    [Parameter(ValueFromPipelineByPropertyName)]
    [string]
    $Url,

    # A dictionary of additional Open Graph metadata to include in the result
    [Parameter(ValueFromPipelineByPropertyName)]
    [Collections.IDictionary]
    $Data,

    # If set, forces the function to retrieve the Open Graph metadata even if it is already cached.
    [Parameter(ValueFromPipelineByPropertyName)]
    [switch]
    $Force
    )

    begin {
        # Make a regex to match meta tags
        $metaRegex = [Regex]::new('<meta.+?/>','IgnoreCase','00:00:00.1')
        if (-not $script:OpenGraphCache) {
            $script:OpenGraphCache = [Ordered]@{}
        }
    }

    process {
        # Declare an empty object to hold the Open Graph metadata
        $openGraphMetadata = [Ordered]@{PSTypeName='OpenGraph'}
        if ($Url) {
            if ($script:OpenGraphCache[$url] -and -not $Force) {
                return ([PSCustomObject]$script:OpenGraphCache[$url])
            }
            $restResponse = Invoke-RestMethod -Uri $Url
            foreach ($match in $metaRegex.Matches("$restResponse")) {
                $matchXml = "$match" -as [xml]
                if ($matchXml.meta.property -and $matchXml.meta.content) {
                    $openGraphMetadata[$matchXml.meta.property] = $matchXml.meta.content
                }
            }
            $script:OpenGraphCache[$url] = $openGraphMetadata
        }
        if ($Data) {
            foreach ($key in $Data.Keys) {
                $openGraphMetadata[$key] = $Data[$key]
            }
        }
        
        if (-not $openGraphMetadata.Count) { return }

        [PSCustomObject]$openGraphMetadata                
    }
}