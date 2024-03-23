function Test-TerraformExists
{
    [CmdletBinding()]
    param ()

    $terraformCommand = Get-Command terraform -ErrorAction Stop

    if ($terraformCommand -ne $null)
    {
        Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Success: Terraform found at: $( $terraformCommand.Source )"
    }
    else
    {
        throw "[$( $MyInvocation.MyCommand.Name )] Error: Terraform is not installed or not in PATH. Exiting."
    }
}
