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

    Configuration DemoConfiguraton
    {
        Import-DscResource -ModuleName ConfigurationDsc
    
        ConfigurationVersion NewBuildConfig
        {
            Version = '10.0.0.1'
            ConfigurationName = 'DemoConfiguration'
        }
    }