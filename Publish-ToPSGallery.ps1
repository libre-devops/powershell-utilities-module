# Set the name of your module
$moduleName = "LibreDevOpsHelpers"
# Set the path to the directory containing your module's .psd1 file
$modulePath = ".\LibreDevOpsHelpers"
# Get your NuGet API Key from an environment variable
$nugetToken = $Env:NUGET_API_KEY

# If you need to dynamically update the manifest (Optional and should be used with caution)
# Ensure your module's commands are loaded into the current session for this to work
# Import-Module -Name $modulePath -Force
# Update-ModuleManifest -Path "$modulePath\$moduleName.psd1" -FunctionsToExport (Get-Command -Module $moduleName).Name

# Publish the module using the path to the module directory
Publish-Module -Path $modulePath -NuGetApiKey $nugetToken -Force -Verbose
