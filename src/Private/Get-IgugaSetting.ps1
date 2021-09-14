function Get-IgugaSetting {
    param(
        [Parameter(Mandatory)]
        [string]$Key,

        [Parameter(Mandatory)]
        [string]$Path,

        [switch]$ReturnSecureString
    )

    if (Test-Path -LiteralPath $Path) {
        $securedSettings = Import-Clixml -Path $Path
        if ($securedSettings.$Key) {
            switch ($securedSettings.$Key[0]) {
                'securestring' {
                    $value = $securedSettings.$Key[1] | ConvertTo-SecureString
                    if ($ReturnSecureString.IsPresent) {
                        $value
                    } else {
                        $cred = (New-Object -TypeName PSCredential -ArgumentList 'jpgr', $value)
                        $cred.GetNetworkCredential().Password
                    }
                    break
                }
                default {
                    $securedSettings.$Key[1]
                }
            }
        }
    }
}