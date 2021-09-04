function Test-IgugaLikeAny
{
    [OutputType([bool])]
    [CmdletBinding()]
    param( [string] $value, [string[]] $patterns )
    foreach( $pattern in $patterns )
    {
        if( $value -like $pattern )
        {
            return $true
        }
    }
    return $false
}