function Set-IgugaMailerSetting {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true)]
        [IgugaMailerSetting]
        $Settings,

        [Parameter(Mandatory = $true)]
        [string]
        $SettingsFilePath
    )

    $FunctionName = "Set-IgugaMailerSetting"
    $Message = "Performing the operation '{0}', setting the key '{1}'."

    if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, "IgugaMailerSMTPServer"), "IgugaMailerSMTPServer", $FunctionName)) {
        Set-IgugaSetting -Key "IgugaMailerSMTPServer" -Value $Settings.SMTPServer -Path $SettingsFilePath
    }

    if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, "IgugaMailerPort"), "IgugaMailerPort", $FunctionName)) {
        Set-IgugaSetting -Key "IgugaMailerPort" -Value $Settings.Port -Path $SettingsFilePath
    }

    if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, "IgugaMailerEncryption"), "IgugaMailerEncryption", $FunctionName)) {
        Set-IgugaSetting -Key "IgugaMailerEncryption" -Value $Settings.Encryption -Path $SettingsFilePath
    }

    if ($Settings.Credential) {
        if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, "IgugaMailerUsername"), "IgugaMailerUsername", $FunctionName)) {
            Set-IgugaSetting -Key "IgugaMailerUsername" -Value $Settings.Credential.Username -Path $SettingsFilePath
        }

        if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, "IgugaMailerPassword"), "IgugaMailerPassword", $FunctionName)) {
            Set-IgugaSetting -Key "IgugaMailerPassword" -Value $Settings.Credential.Password -Path $SettingsFilePath
        }
    }
}