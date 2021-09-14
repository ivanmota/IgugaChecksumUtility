function Get-IgugaMailerSetting {
    [OutputType([IgugaMailerSetting])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $SettingsFilePath
    )

    if (-not(Test-Path -LiteralPath $SettingsFilePath -PathType Leaf)) {
        throw [IgugaError]::PathNotFound($Script:LocalizedData.ErrorSettingsFileNotFound, $Path)
    }

    $Settings = [IgugaMailerSetting]::new()

    $Username = Get-IgugaSetting -Path $SettingsFilePath -Key "IgugaMailerUsername"
    $Password = Get-IgugaSetting -Path $SettingsFilePath -Key "IgugaMailerPassword" -ReturnSecureString

    $Settings.SMTPServer = Get-IgugaSetting -Path $SettingsFilePath -Key "IgugaMailerSMTPServer"
    $Settings.Port = Get-IgugaSetting -Path $SettingsFilePath -Key "IgugaMailerPort"
    $Settings.Encryption = Get-IgugaSetting -Path $SettingsFilePath -Key "IgugaMailerEncryption"

    if ($Username) {
        $Settings.Credential = (New-Object -TypeName PSCredential -ArgumentList $Username, $Password)
    }

    if ([string]::IsNullOrWhiteSpace($Settings.SMTPServer)) {
        throw [IgugaError]::InvalidSetting($Script:LocalizedData.ErrorInvalidSetting, "IgugaMailerSMTPServer")
    }

    return $Settings
}