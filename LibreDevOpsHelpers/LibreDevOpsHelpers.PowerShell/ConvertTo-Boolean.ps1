function ConvertTo-Boolean {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$value
    )

    $valueLower = $value.ToLower()
    switch ($valueLower) {
        "true" { return $true }
        "false" { return $false }
        default {
            throw "[$( $MyInvocation.MyCommand.Name )] Error: Invalid value - $value. Must be either 'true' or 'false'."
        }
    }
}
