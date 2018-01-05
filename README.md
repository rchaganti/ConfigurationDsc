# DSC configuration resources
A set of resources to work with DSC configurations in an Infrastructure as Code (IaC) deployment pipeline.

#Resources in this module#
This resource module contains the following resources:

|Resource Name       |Description|
|--------------------|-----------|
|[ConfigurationVersion](https://github.com/rchaganti/ConfigurationDsc/tree/master/DscResources/ConfigurationVersion)|This resource can be used to specify the version of the configuration that is enacted on a node. Refer to <PSMAG> post for more information and background.|

#Examples#
##ConfigurationVersion##
The following example shows how to use the `ConfigurationVerison` DSC resource.

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
