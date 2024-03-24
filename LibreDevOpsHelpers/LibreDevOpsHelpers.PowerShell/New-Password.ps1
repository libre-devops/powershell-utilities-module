function New-Password
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false)]
        [int] $partLength = 5, # Length of each part of the password

        [Parameter(Mandatory = $false)]
        [string] $alphabet = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+<>,.?/:;~`-=',

        [Parameter(Mandatory = $false)]
        [string] $upper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ',

        [Parameter(Mandatory = $false)]
        [string] $lower = 'abcdefghijklmnopqrstuvwxyz',

        [Parameter(Mandatory = $false)]
        [string] $numbers = '0123456789',

        [Parameter(Mandatory = $false)]
        [string] $special = '!@#$%^&*()_+<>,.?/:;~`-='
    )

    # Helper function to generate a random sequence from the alphabet
    function New-RandomSequence
    {
        param (
            [int] $length,
            [string] $alphabet
        )

        $sequence = New-Object char[] $length
        for ($i = 0; $i -lt $length; $i++) {
            $randomIndex = Get-Random -Minimum 0 -Maximum $alphabet.Length
            $sequence[$i] = $alphabet[$randomIndex]
        }

        return -join $sequence
    }

    # Ensure each part has at least one character of each type
    $minLength = 4
    if ($partLength -lt $minLength)
    {
        $errorMessage = "[$( $MyInvocation.MyCommand.Name )] Error: Each part of the password must be at least $minLength characters to ensure complexity."
        Write-Error $errorMessage
        throw $errorMessage
    }

    Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Generating password parts with length of $partLength characters each."

    $part1 = New-RandomSequence -length $partLength -alphabet $alphabet
    $part2 = New-RandomSequence -length $partLength -alphabet $alphabet
    $part3 = New-RandomSequence -length $partLength -alphabet $alphabet

    # Ensuring at least one character from each category in each part
    $part1 = $upper[(Get-Random -Maximum $upper.Length)] + $part1.Substring(1)
    $part2 = $lower[(Get-Random -Maximum $lower.Length)] + $part2.Substring(1)
    $part3 = $numbers[(Get-Random -Maximum $numbers.Length)] + $special[(Get-Random -Maximum $special.Length)] + $part3.Substring(2)

    # Concatenate parts with separators
    $password = "$part1-$part2-$part3"

    Write-Verbose "[$( $MyInvocation.MyCommand.Name )] Info: Password generated successfully."
    return $password
}
