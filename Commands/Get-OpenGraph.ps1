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
    .LINK
        https://ogp.me/        
    #>
    [Alias('openGraph','ogp')]
    [CmdletBinding(PositionalBinding=$false)]
    param(        
    # The URL that may contain Open Graph metadata 
    [Parameter(Position=0,ValueFromPipeline,ValueFromPipelineByPropertyName)]
    [Uri]
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
    $Force
    )

    begin {
        # Make a regex to match meta tags
        # We will match both open and closed tags.
        $metaRegex = [Regex]::new('<meta.+?/?>','IgnoreCase','00:00:00.1')
        # If we do not have a cache
        if (-not $script:Cache) {
            # create one.
            $script:Cache = [Ordered]@{}
        }        
    }

    process {
        # Declare an empty object to hold the Open Graph metadata
        $openGraphMetadata = [Ordered]@{PSTypeName='OpenGraph'}
        if ($Url -and -not $PSBoundParameters['html']) {
            # If the url is an absolute url with a scheme or http or https.
            if ($url.Scheme -in 'http', 'https') {
                # Get the url (if it is not cached).
                if (-not $script:Cache[$url] -or $Force) {
                    $script:Cache[$url] =try { 
                            Invoke-RestMethod -Uri $Url
                        } catch { $_ }                
                }
                $html = $script:Cache[$url]
            } 
            # Otherwise, see if the path exists
            elseif (Test-Path $url)
            {
                # and get content from that path.
                $html = Get-Content "$url" -Raw
            }
        }

        # If we had any html,
        if ($html) {
            # find all of the `<meta>` tags.
            foreach ($match in $metaRegex.Matches($html)) {
                # Try to make them XML
                $matchXml = "$match" -as [xml]
                # If that fails,
                if (-not $matchXml) {
                    # try once more after explicitly closing the end tag.
                    $matchXml = $match -replace '>$', '/>' -as [xml]
                }
                # If the meta tag contained a property and content,
                if ($matchXml.meta.property -and $matchXml.meta.content) {
                    # we will add it to our openGraph metadata.
                    $openGraphMetadata[
                        $matchXml.meta.property
                    ] = $matchXml.meta.content
                }
            }
        }

        # If any data was provided
        if ($Data) {
            # copy it into open graph metadata
            foreach ($key in $Data.Keys) {
                $openGraphMetadata[$key] = $Data[$key]
            }
        }
        
        # If there was no open graph metadata, return nothing.
        if (-not $openGraphMetadata.Count) { return }

        # Otherwise, return our OpenGraph metadata
        [PSCustomObject]$openGraphMetadata                
    }
}