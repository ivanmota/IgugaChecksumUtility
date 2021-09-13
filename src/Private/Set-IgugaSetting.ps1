function Set-IgugaSetting {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [string]$Path,

        [Parameter(Mandatory)]
        [ValidateNotNull()]
        [object]$Value
    )

    if (Get-IgugaSetting -Key $Key -Path $Path) {
        Remove-IgugaSetting -Key $Key -Path $Path -WhatIf:$WhatIfPreference
    }

    $FunctionName = "Set-IgugaSetting"
    $Message = "Performing the operation '{0}', adding the key '{1}'."

    if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, $Key), $Key, $FunctionName)) {
        Add-IgugaSetting -Key $Key -Value $Value -Path $Path
    }
}