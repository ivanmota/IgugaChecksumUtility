function Remove-IgugaSetting {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [string]$Path
    )

    if (Test-Path -LiteralPath $Path) {
        $storedSettings = Import-Clixml -Path $Path

        $FunctionName = "Remove-IgugaSetting"
        $Message = "Performing the operation '{0}', removing the key '{1}'."

        if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, $Key), $Key, $FunctionName)) {
            $storedSettings.Remove($Key)
        }

        if ($storedSettings.Count -eq 0) {
            Remove-Item -Path $Path -WhatIf:$WhatIfPreference
        }
        else {
            $storedSettings | Export-Clixml -Path $Path
        }
    }
    else {
        throw [IgugaError]::PathNotFound($Script:LocalizedData.ErrorSettingsFileNotFound, $Path)
    }
}