Configuration VersionedConfiguration
{
    param
    (
        [Parameter(Mandatory = $true)]
        [String] $ConfigurationName,

        [Parameter(Mandatory = $true)]
        [String] $ConfigurationVersion
    )

    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName ConfigurationDsc -ModuleVersion 1.0.0.0

    ConfigurationVersion WebServerConfiguration
    {
        Name = $ConfigurationName
        Version = $ConfigurationVersion
    }

    WindowsFeature WebServer
    {
        Name = 'Web-Server'
        IncludeAllSubFeature = $true
        Ensure = 'Present'
    }
}

VersionedConfiguration -ConfigurationName 'WebServerConfig' -ConfigurationVersion '1.0.0.0'
