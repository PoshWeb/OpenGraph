# OpenGraph
[![OpenGraph](https://img.shields.io/powershellgallery/dt/OpenGraph)](https://www.powershellgallery.com/packages/OpenGraph/)
## Get OpenGraph with PowerShell

## Installing and Importing

You can install OpenGraph from the [PowerShell gallery](https://powershellgallery.com/)

~~~PowerShell
Install-Module OpenGraph -Scope CurrentUser -Force
~~~

Once installed, you can import the module with:

~~~PowerShell
Import-Module OpenGraph -PassThru
~~~


You can also clone the repo and import the module locally:

~~~PowerShell
git clone https://github.com/PoshWeb/OpenGraph
cd ./OpenGraph
Import-Module ./ -PassThru
~~~

## Functions
OpenGraph has 1 function
### Get-OpenGraph
#### Gets Open Graph metadata for a given URL.
Gets Open Graph metadata for a given URL.

[Open Graph](https://ogp.me/) is a protocol that enables any web page to become a rich object in a social graph.

It is used many social networks to display rich content when links are shared.

This function retrieves the Open Graph metadata from a given URL and returns it as a custom object.
##### Parameters

|Name|Type|Description|
|-|-|-|
|ArgumentList|PSObject[]|A list of any arguments. <br/>This allows the command to take natural input.|
|Url|String|The URL that may contain Open Graph metadata|
|Html|String|Any HTML that may contain open graph metadata.|
|Data|IDictionary|A dictionary of additional Open Graph metadata to include in the result|
|Force|SwitchParameter|If set, forces the function to retrieve the Open Graph metadata even if it is already cached.|
|InputObject|PSObject[]|Any number of input objects|

##### Examples
###### Example 1
~~~PowerShell
Get-OpenGraph -Url https://abc.com/
~~~
###### Example 2
~~~PowerShell
'https://thebulwark.com/' | Get-OpenGraph
~~~
###### Example 3
~~~PowerShell
OpenGraph https://posh.pckt.blog/static-sites-are-simple-6u51kgj
~~~
## Types
### OpenGraph
#### Members
|Name|MemberType|
|-|-|
|[ToString](Types/OpenGraph/ToString.ps1)|ScriptMethod|
|[get_HTML](Types/OpenGraph/get_HTML.ps1)|ScriptProperty|
> (c) 2025-2026 Start-Automating

> [LICENSE](https://github.com/PoshWeb/OpenGraph/blob/main/LICENSE)
