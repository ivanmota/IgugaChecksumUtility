function Remove-IgugaMailerSetting {
    [CmdletBinding(SupportsShouldProcess)]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $SettingsFilePath
    )

    $FunctionName = "Remove-IgugaMailerSetting"
    $Message = "Performing the operation '{0}', removing the key '{1}'."

    if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, "IgugaMailerUsername"), "IgugaMailerUsername", $FunctionName)) {
        Remove-IgugaSetting -Path $SettingsFilePath -Key "IgugaMailerUsername"
    }

    if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, "IgugaMailerPassword"), "IgugaMailerPassword", $FunctionName)) {
        Remove-IgugaSetting -Path $SettingsFilePath -Key "IgugaMailerPassword"
    }

    if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, "IgugaMailerSMTPServer"), "IgugaMailerSMTPServer", $FunctionName)) {
        Remove-IgugaSetting -Path $SettingsFilePath -Key "IgugaMailerSMTPServer"
    }

    if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, "IgugaMailerPort"), "IgugaMailerPort", $FunctionName)) {
        Remove-IgugaSetting -Path $SettingsFilePath -Key "IgugaMailerPort"
    }

    if ($PSCmdlet.ShouldProcess($($Message -f $FunctionName, "IgugaMailerEncryption"), "IgugaMailerEncryption", $FunctionName)) {
        Remove-IgugaSetting -Path $SettingsFilePath -Key "IgugaMailerEncryption"
    }
}