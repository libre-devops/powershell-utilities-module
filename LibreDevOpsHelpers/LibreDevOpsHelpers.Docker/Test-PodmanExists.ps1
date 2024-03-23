function Test-PodmanExists
{
    [CmdletBinding()]
    param ()

    $podmanCommand = Get-Command podman -ErrorAction Stop

    if ($podmanCommand -ne $null)
    {
        Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Success: Podman found at: $( $podmanCommand.Source )"
    }
    else
    {
        throw "[$( $MyInvocation.MyCommand.Name )] Error: Podman is not installed or not in PATH. Exiting."
    }
}
