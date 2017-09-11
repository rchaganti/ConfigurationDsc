#region localizeddata
if (Test-Path "${PSScriptRoot}\${PSUICulture}")
{
    Import-LocalizedData -BindingVariable LocalizedData -filename ConfigurationDsc.Helper.psd1 `
                         -BaseDirectory "${PSScriptRoot}\${PSUICulture}"
} 
else
{
    #fallback to en-US
    Import-LocalizedData -BindingVariable LocalizedData -filename ConfigurationDsc.Helper.psd1 `
                         -BaseDirectory "${PSScriptRoot}\en-US"
}
#endregion

function Get-DscResourceCacheLocation
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [String] $ResourceName,

        [Parameter(Mandatory)]
        [String] $ConfigurationName
    )

    $cachePath = "${env:ProgramData}\Microsoft\Windows\PowerShell\Configuration\BuiltinProvCache\${ResourceName}"

    $cacheObject = @{
        CachePath = $cachePath
    }

    if (Test-Path -Path $cachePath)
    {
        Write-Verbose -Message $localizedData.CachePathExists
        $cacheObject.Add('CachePathExists', $true)

        $cacheFile = Get-ChildItem $cachePath -Filter "${ConfigurationName}.cache"
        if ($cacheFile)
        {
            Write-Verbose -Message $localizedData.CacheFileExists
            $cacheObject.Add('CacheFileExists',$true)
            $cacheObject.Add('CacheFile',$cacheFile.FullName)
        }
        else
        {
            Write-Verbose -Message $localizedData.NoCacheFile
            $cacheObject.Add('CacheFileExists',$false)
        }
    }
    else
    {
        Write-Verbose -Message $localizedData.NoCachePath
        $cacheObject.Add('CachePathExists', $false)
    }

    return $cacheObject
}

Export-ModuleMember -Function *
