#region helper modules
$modulePath = Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -ChildPath 'Modules'

Import-Module -Name (Join-Path -Path $modulePath `
                               -ChildPath (Join-Path -Path 'ConfigurationDsc.Helper' `
                                                     -ChildPath 'ConfigurationDsc.Helper.psm1'))
#endregion

#region localizeddata
if (Test-Path "${PSScriptRoot}\${PSUICulture}")
{
    Import-LocalizedData -BindingVariable localizedData -filename ConfigurationVersion.psd1 `
                         -BaseDirectory "${PSScriptRoot}\${PSUICulture}"
} 
else
{
    #fallback to en-US
    Import-LocalizedData -BindingVariable localizedData -filename ConfigurationVersion.psd1 `
                         -BaseDirectory "${PSScriptRoot}\en-US"
}
#endregion

<#
.SYNOPSIS
Gets the current state of the ConfigurationVersion resource.

.DESCRIPTION
Gets the current state of the ConfigurationVersion resource.

.PARAMETER Version
Specifies the version string for the configuration that is enacted on the node.

.PARAMETER Name
Specifies the name of the configuration that is being enacted on the node.
#>
function Get-TargetResource
{
    [OutputType([System.Collections.Hashtable])]
    param
    (        
        [Parameter(Mandatory)]
        [String] $Version,

        [Parameter(Mandatory)]
        [String] $Name
    )
    
    Write-Verbose -Message $localizedData.CheckCacheLocation
    $cache = Get-DscResourceCacheLocation -ResourceName 'ConfigurationVersion' -ConfigurationName $Name -Verbose

    $configuration = @{
        Version = $Version
        Name = $Name
        CachePath = $cache.CachePath
        CacheFile = $cache.CacheFile
        CachePathExists = $cache.CachePathExists
        CacheFileExists = $cache.CacheFileExists
    }
     
    return $configuration
}

<#
.SYNOPSIS
Sets the ConfigurationVersion resource to the specified desired state.

.DESCRIPTION
Sets the ConfigurationVersion resource to the specified desired state.

.PARAMETER Verson
Specifies the version string for the configuration that is enacted on the node.

.PARAMETER Name
Specifies the name of the configuration that is being enacted on the node.
#>
function Set-TargetResource
{
    param
    (
        [Parameter(Mandatory)]
        [String] $Version,

        [Parameter(Mandatory)]
        [String] $Name
    )

    Write-Verbose -Message $localizedData.CheckCacheLocation
    $cache = Get-DscResourceCacheLocation -ResourceName 'ConfigurationVersion' -ConfigurationName $Name -Verbose

    if ($cache.CachePathExists)
    {
        Write-Verbose -Message $localizedData.CheckCacheFile

        #Check if the .cache file exists and verify the version value
        if ($cache.CacheFileExists)
        {
            Write-Verbose -Message $localizedData.CheckConfigurationVersion

            #Check the content and match the version
            $configurationVersion = Get-Content -Path $cache.CacheFile

            if ($configurationVersion -ne $Version)
            {
                Write-Verbose -Message $localizedData.SetConfigurationVersion                
                Set-Content -Path $cache.CacheFile -Value $Version -Verbose
            }
        }
        else
        {
            Write-Verbose -Message $localizedData.CreateCacheFile
            $cacheFilePath = Join-Path -Path $cache.CachePath -ChildPath "${Name}.cache"
            Set-Content -Path $cacheFilePath -Value $Version -Verbose
        }
    }
    else
    {
        Write-Verbose -Message $localizedData.CreateCachePath
        $null = New-Item -Path $cache.CachePath -ItemType Directory -Force

        Write-Verbose -Message $localizedData.SetConfigurationVersion 
        $cacheFilePath = Join-Path -Path $cache.CachePath -ChildPath "${Name}.cache"
        Set-Content -Path $cacheFilePath -Value $Version -Verbose
    }    
}

<#
.SYNOPSIS
Sets the ConfigurationVersion resource to the specified desired state.

.DESCRIPTION
Sets the ConfigurationVersion resource to the specified desired state.

.PARAMETER Verson
Specifies the version string for the configuration that is enacted on the node.

.PARAMETER Name
Specifies the name of the configuration that is being enacted on the node.
#>
function Test-TargetResource
{
    [OutputType([System.Boolean])]
    param
    (              
        [Parameter(Mandatory)]
        [String] $Version,

        [Parameter(Mandatory)]
        [String] $Name
    )

    Write-Verbose -Message $localizedData.CheckCacheLocation
    $cache = Get-DscResourceCacheLocation -ResourceName 'ConfigurationVersion' -ConfigurationName $Name -Verbose

    if ($cache.CachePathExists)
    {
        Write-Verbose -Message $localizedData.CheckCacheFile

        #Check if the .cache file exists and verify the version value
        if ($cache.CacheFileExists)
        {
            Write-Verbose -Message $localizedData.CheckConfigurationVersion

            #Check the content and match the version
            $configurationVersion = Get-Content -Path $cache.CacheFile

            if ($configurationVersion -eq $Version)
            {
                Write-Verbose -Message $localizedData.ConfigurationVersionMatch
                return $true
            }
            else
            {
                Write-Verbose -Message $localizedData.ConfigurationVersionMismatch
                return $false
            }
        }
        else
        {
            Write-Verbose -Message $localizedData.CreateCacheFile
            return $false
        }
    }
    else
    {
        Write-Verbose -Message $localizedData.CreateCachePath
        return $false
    }
}

Export-ModuleMember -Function *-TargetResource
