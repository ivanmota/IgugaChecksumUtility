function Send-IgugaMailMessage {
    <#
    .SYNOPSIS
        Send an email using MailKit
    .DESCRIPTION
        Send an email using the implementing the Microsoft-recommended MailKit library. This function only have support for Powershell version 7 or higher
    .PARAMETER MailerSetting
        Sets the SMTP server host name to connect to
    .PARAMETER From
        Sets the addreess in the From header
    .PARAMETER ToList
        Sets the list of addresses in the To header
    .PARAMETER CcList
        Sets the list of addresses in the Cc header
    .PARAMETER BccList
        Sets the list of addresses in the Bcc header
    .PARAMETER Subject
        Sets the subject of the message
    .PARAMETER TextBody
        Sets the text body if it exists
    .PARAMETER HTMLBody
        Sets the html body if it exists
    .PARAMETER AttachmentList
        Sets the attachements file path list
    .EXAMPLE
        # How to send a simple email
        using module IgugaChecksumUtility
        $Credential = [PSCredential]::new("example@gmail.com", (ConvertTo-SecureString -String 'password-example' -AsPlainText -Force))
        $MailerSetting = [IgugaMailerSetting]::new("smtp.gmail.com", 587, $Credential)
        $From = [IgugaMailAddress]::new("My Name", "example@gmail.com")
        $ToList = @([IgugaMailAddress]::new("name@example.com"))
        Send-IgugaMailMessage -MailerSetting $MailerSetting -From $From -ToList $ToList -Subject "Email Subject" -TextBody "Email Body"
    #>
    param(
        [Parameter(Mandatory=$true)]
        [IgugaMailerSetting]
        $MailerSetting,

        [Parameter(Mandatory=$true)]
        [IgugaMailAddress]
        $From,

        [Parameter(Mandatory=$true)]
        [IgugaMailAddress[]]
        $ToList,

        [Parameter(Mandatory=$false)]
        [IgugaMailAddress[]]
        $CcList,

        [Parameter(Mandatory=$false)]
        [IgugaMailAddress[]]
        $BccList,

        [Parameter(Mandatory=$false)]
        [string]
        $Subject,

        [Parameter(Mandatory=$false)]
        [string]
        $TextBody,

        [Parameter(Mandatory=$false)]
        [string]
        $HTMLBody,

        [Parameter(Mandatory=$false)]
        [string[]]
        $AttachmentList
    )

    try {

        $ErrorActionPreference="Stop"

        if ($PSVersionTable.PSVersion.Major -lt 7) {
            throw [IgugaError]::PSVersionFunctionNotSupported($Script:LocalizedData.ErrorPSVersionFunctionNotSupported, "Send-IgugaMailMessage", "7.0");
        }

        #message
        $Message=[MimeKit.MimeMessage]::new()

        #from
        $Message.From.Add([MimeKit.MailboxAddress]::new($From.Name, $From.Address))

        #to
        foreach ($To in $ToList) {
            $Message.To.Add([MimeKit.MailboxAddress]::new($To.Name, $To.Address))
        }


        #cc
        if ($CcList.Count -gt 0) {
            foreach ($Cc in $CcList) {
                $Message.Cc.Add([MimeKit.MailboxAddress]::new($Cc.Name, $Cc.Address))
            }
        }

        #bcc
        if ($BccList.Count -gt 0) {
            foreach ($Bcc in $BccList) {
                $Message.Bcc.Add([MimeKit.MailboxAddress]::new($Bcc.Name, $Bcc.Address))
            }
        }

        #subject
        if (-not([string]::IsNullOrWhiteSpace($Message))) {
            $Message.Subject = $Subject
        }

        #body
        #$BodyBuilder=New-Object BodyBuilder
        $BodyBuilder=[MimeKit.BodyBuilder]::new()

        #text body
        if (-not([string]::IsNullOrWhiteSpace($TextBody))) {
            $BodyBuilder.TextBody = $TextBody
        }

        #html body
        if (-not ([string]::IsNullOrWhiteSpace($HTMLBody))) {
            #use [System.Web.HttpUtility]::HtmlDecode() in case there are html elements present that have been escaped
            $BodyBuilder.HtmlBody = [System.Web.HttpUtility]::HtmlDecode($HTMLBody)
        }

        #attachment(s)
        if ($AttachmentList.Count -gt 0) {
            $AttachmentList | ForEach-Object {
                $BodyBuilder.Attachments.Add($_) | Out-Null
            }
        }

        #add bodybuilder to message body
        $Message.Body = $BodyBuilder.ToMessageBody()

        #SecureSocketOptions
        switch ($MailerSetting.Encryption) {
            "None" {
                $Encryption = [MailKit.Security.SecureSocketOptions]::None
                break
            }
            "SslOnConnect" {
                $Encryption = [MailKit.Security.SecureSocketOptions]::SslOnConnect
                break
            }
            "StartTls" {
                $Encryption = [MailKit.Security.SecureSocketOptions]::StartTls
                break
            }
            "StartTlsWhenAvailable" {
                $Encryption = [MailKit.Security.SecureSocketOptions]::StartTlsWhenAvailable
                break
            }
            Default {
                $Encryption = [MailKit.Security.SecureSocketOptions]::Auto
            }
        }

        #smtp send
        $Client = New-Object MailKit.Net.Smtp.SmtpClient
        $Client.Connect($MailerSetting.SMTPServer, $MailerSetting.Port, $Encryption)

        if ($MailerSetting.Credential) {
            $Client.Authenticate($MailerSetting.Credential.UserName, ($MailerSetting.Credential.Password | ConvertFrom-SecureString -AsPlainText))
        }
        $Client.Send($Message)
    } catch {
        throw
    } finally {
        if ($Client.IsConnected)
        {
            $Client.Disconnect($true)
        }
    }
}