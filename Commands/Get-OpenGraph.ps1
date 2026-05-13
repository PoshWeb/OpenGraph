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
        $metaRegex = [Regex]::new('<meta.+?/>','IgnoreCase','00:00:00.1')
        if (-not $script:OpenGraphCache) {
            $script:OpenGraphCache = [Ordered]@{}
        }
    }

    process {
        # Turn any of our strongly bound parameters into arguments
        if ($Url) {
            $argumentList = @($argumentList) + $url
        }
        if ($Data) {
            $argumentList = @($argumentList) + $Data
        }
        if ($InputObject) {
            $ArgumentList = @($ArgumentList) + $InputObject
        }
        
        :nextArgument foreach ($argument in $argumentList) {
            # Declare an empty object to hold the Open Graph metadata            
            if (-not $argument) { continue }
            $openGraphMetadata = [Ordered]@{PSTypeName='OpenGraph'}
            $url, $data = $null, $null
            
            if ($argument -as [uri]) {
                $url = $argument -as [uri]
            } elseif ($argument -is [Collections.IDictionary]) {
                $data = $argument
            } else {
                Write-Warning "Only [uri] and [Collections.IDictionary] supported: $argument"
                continue nextArgument
            }

            if ($Url) {
                if ($script:OpenGraphCache[$url] -and -not $Force) {
                    foreach ($key in $script:OpenGraphCache[$url].Keys) {
                        $openGraphMetadata[$key] =
                            $script:OpenGraphCache[$url][$key]
                    }
                    ([PSCustomObject]$script:OpenGraphCache[$url])
                    continue nextArgument
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
            
            # If there was no metadata
            if (-not $openGraphMetadata.Count) {
                # output false (so `Test-` verb scenarios are met)
                $false
                # and continue to the next argument.
                continue nextArgument
            }

            [PSCustomObject]$openGraphMetadata
        }
    }
}