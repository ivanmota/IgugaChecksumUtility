function IgugaChecksumUtility {
    <#
    .SYNOPSIS
        Generates and validate checksums for files or directories
    .DESCRIPTION
        Generates and validate checksum file hashes for a variety of algorithms
    .PARAMETER Mode
        Sets the operation mode.
        The allowed modes are: Generate, Validate, Compare, SetMailerSetting, RemoveMailerSetting, ShowMailerSetting
    .PARAMETER Path
        Sets the path to a given file or directory
    .PARAMETER BasePath
        Used with Validate mode, sets the base path. This parameter is usefull when the paths inside of the checksum file are
        relative and the file being validated is located in a not related path.
    .PARAMETER Algorithm
        Sets the hashing algorithm to be used in the checksum operation. The allowed algotithms are: MD5, SHA1, SHA256, SHA384 and SHA512
    .PARAMETER Hash
        Used with Compare mode, sets the specific previously known hash
    .PARAMETER Filter
        Used with Generate mode when the path is a directory, specifies a filter to qualify the Path parameter. Example: '*.txt'
    .PARAMETER Exclude
        Used with Generate mode when the path is a directory, specifies an array of one or more string patterns to be matched as the cmdlet gets child items.
        Any matching item is excluded from the output. Enter a path element or pattern, such as *.txt or A*. Wildcard characters are accepted
    .PARAMETER Depth
        Used with Generate mode when the path is a directory, allow you to limit the recursion to X levels.
        For example, -Depth 2 includes the Path parameter's directory, first level of subdirectories, and second level of subdirectories.
    .PARAMETER OutFile
        Used with Generate mode, sets whether it will generate a checksum file or not
    .PARAMETER OutFilePath
        Used with Generate mode, sets the path of the generated checksum file.
        If this parameter is not provided the default name will be "{Algorithm}SUMS.txt" and will be stored on the Path root directory
    .PARAMETER UseAbsolutePath
        Used with Generate mode, sets whether the checksum file path should be absolute or not
    .PARAMETER OutputFilePath
        Sets the file path to export the output. If the output file path is not provided the output will be printed to the console
    .PARAMETER Silent
        Omitte the progress status and the output will not be printed on the console
    .PARAMETER SendEmailNotification
        Used with Validate mode, indicates in which condition a notification email should be sent after the validation process.
        Please note that the email notification only supported Powershell version 7 or higher.
        The allowed values are: None, Always, Success, NotSuccess.
        'None' means no notification mail will be sent.
        'Always' means a notification will be sent after each validation process.
        'Success' means a notification mail will be sent only if all file validation passed.
        'NotSuccess' means a notification mail will be sent if at least one file validation failed or not found.
    .PARAMETER MailerSetting
        Used with SetMailerSetting mode, sets the mailer settings
    .PARAMETER From
        Used with the parameter SendEmailNotification, sets the from mail address
    .PARAMETER ToList
        Used with the parameter SendEmailNotification, sets the to list mail addresses
    .PARAMETER CcList
        Used with the parameter SendEmailNotification, sets the cc list mail addresses
    .PARAMETER BccList
        Used with the parameter SendEmailNotification, sets the bcc list mail addresses
    .EXAMPLE
        # Checksum a single file, and output to console
        IgugaChecksumUtility -Mode Generate -Path C:\Test\File.docx
    .EXAMPLE
        # Checksum an entire directory using the SHA512 algorithm and create a checksum file
        IgugaChecksumUtility -Mode Generate -Path C:\Test\ -Algorithm SHA512 -OutFile
    .EXAMPLE
        # Perform a validate operation on a checksum file
        IgugaChecksumUtility -Mode Validate -Path C:\Test\SHA512SUMS.txt -Algorithm SHA512
    .EXAMPLE
        # Perform a validate operation on a checksum file when the paths inside the file being validated is located on a different path and send an email notification (only supported on PS 7 or higher) if there is any failed validation or file not found
        # First we need to set the Mailer settings. We just need to do this once. All this info will be stored on the user local computer.
        using module IgugaChecksumUtility
        $Credential = [PSCredential]::new("my.name@gmail.com", (ConvertTo-SecureString -String 'my-password' -AsPlainText -Force))
        $MailerSetting = [IgugaMailerSetting]::new("smtp.gmail.com", 587, $Credential)
        IgugaChecksumUtility -Mode SetMailerSetting -MailerSetting $MailerSetting
        # You can see all the Mailer settings and where the data is located if you run the following PS command line
        IgugaChecksumUtility -Mode ShowMailerSetting
        # If you wich to remove the Mailer setting, then run the follow PS command line
        IgugaChecksumUtility -Mode RemoveMailerSetting
        # Then, define the sender(From) and the recipents (ToList) and run the validation
        $From = [IgugaMailAddress]::new("My Name", "my.name@gmail.com");
        $ToList = @([IgugaMailAddress]::new("name1@example.com"), [IgugaMailAddress]::new("name2@example.com"));
        IgugaChecksumUtility -Mode Validate -Path "\\server1\checksums\apps\SHA256SUMS.txt" -BasePath "C:\Apps" -Algorithm SHA512 -SendMailNotification NotSuccess -From $From -ToList $ToList
    .EXAMPLE
        # Perform a compare operation on a file with a known hash
        IgugaChecksumUtility -Mode Compare -Path C:\Test\File.docx -Algorithm SHA1 -Hash ED1B042C1B986743C1E34EBB1FAF758549346B24
    #>
    [CmdletBinding(SupportsShouldProcess)]
    Param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The the operation mode. The allowed modes are: Generate, Validate, Compare, SetMailerSetting, RemoveMailerSetting and ShowMailerSetting")]
        [ValidateSet("Generate", "Validate", "Compare", "SetMailerSetting", "RemoveMailerSetting", "ShowMailerSetting")]
        [string]
        $Mode,

        [string]
        $Path,

        [string]
        $BasePath,

        [ValidateSet("MD5", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]
        $Algorithm = "SHA256",

        [string]
        $Hash,

        [string]
        $Filter,

        [string[]]
        $Exclude,

        [int]
        $Depth,

        [Switch]
        $OutFile,

        [string]
        $OutFilePath,

        [Switch]
        $UseAbsolutePath,

        [AllowEmptyString()]
        [string]
        $OutputFilePath,

        [Switch]
        $Silent,

        [string]
        [ValidateSet("None", "Always", "Success", "NotSuccess")]
        $SendEmailNotification = "None",

        [IgugaMailerSetting]
        $MailerSetting,

        [IgugaMailAddress]
        $From,

        [IgugaMailAddress[]]
        $ToList,

        [IgugaMailAddress[]]
        $CcList,

        [IgugaMailAddress[]]
        $BccList
    )

    $Script:TotalOfItems = 0
    $Script:ReportItemsGenerated = 0
    $Script:ReportItemsValid = 0
    $Script:ReportItemsInvalid = 0
    $Script:ReportItemsFileNotFound = 0

    $SettingsFilePath = [Environment]::GetFolderPath([System.Environment+SpecialFolder]::ApplicationData)
    $SettingsFilePath = Join-Path -Path $SettingsFilePath -ChildPath "$($MyInvocation.MyCommand.Module.Name)\Settings.clixml"

    if ($Mode -notin @("SetMailerSetting", "RemoveMailerSetting", "ShowMailerSetting")) {

        if ([string]::IsNullOrWhiteSpace($Path)) {
            Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorUtilityParameterRequiredMode -f $Mode, 'Path')" -ForegroundColor Red
            return;
        }

        if (-not(Test-Path -LiteralPath $Path -PathType Any)) {
            Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorUtilityPathNotFound -f $Mode, $Path)" -ForegroundColor Red
            return;
        }
    }

    $OutputFilePathDefinedByUser = $true;
    if ([string]::IsNullOrWhiteSpace($OutFilePath)) {
        $OutputFilePathDefinedByUser = $false;
    }

    if (-not($SendEmailNotification -eq "None")) {
        if ($PSVersionTable.PSVersion.Major -lt 7) {
            Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorPSVersionFunctionNotSupported -f 'Send-IgugaMailMessage', '7.0')" -ForegroundColor Red
            return
        }

        if (-not(Test-Path -LiteralPath $SettingsFilePath -PathType Leaf)) {
            Write-IgugaColorOutput -Message "[-] $($Script:LocalizedData.ErrorUtilitySettingsFileDoesNotExists -f 'SendEmailNotification', 'SetMailerSetting')" -ForegroundColor Red
            return;
        }

        if ($null -eq $From) {
            Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorUtilityParameterRequired -f 'SendEmailNotification', 'From')" -ForegroundColor Red
            return
        }

        if ($ToList.Count -eq 0) {
            Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorUtilityParameterRequired -f 'SendEmailNotification', 'ToList')" -ForegroundColor Red
            return
        }

        if (-not($OutputFilePathDefinedByUser)) {
            $OutputFilePath = Join-Path -Path $([System.IO.Path]::GetTempPath()) -ChildPath "IgugaChecksumReport.$(Get-Random).txt"
        }
    }

    Write-IgugaReporSummary -Mode $Mode -OutputFilePath $OutputFilePath -Algorithm $Algorithm -Path $Path -Verbose:($PSBoundParameters['Verbose'] -eq $true)

    if ($Mode -eq "Validate") {
        try {
            $Results = Test-IgugaChecksumFile -FilePath $Path -BasePath $BasePath -Algorithm $Algorithm -Silent:$Silent
            $Script:TotalOfItems = $Results.Length
            foreach ($Result in $Results) {
                switch ($Result.Status) {
                    "PASS" {
                        $Script:ReportItemsValid++
                        Write-IgugaReportContent -Text $($Script:LocalizedData.ValidationPassed -f $Result.FilePath) -ForegroundColor Green -OutputFilePath $OutputFilePath -Silent:$Silent
                        break;
                    }
                    "FAIL" {
                        $Script:ReportItemsInvalid++
                        Write-IgugaReportContent -Text $($Script:LocalizedData.ValidationFailed -f $Result.FilePath, $Result.Hash, $Result.ExpectedHash) -ForegroundColor Red -OutputFilePath $OutputFilePath -Silent:$Silent
                        break;
                    }
                    "NOT_FOUND" {
                        $Script:ReportItemsFileNotFound++
                        Write-IgugaReportContent -Text "[-] $($Script:LocalizedData.ErrorUtilityValidateFileNotFound -f $Result.FilePath)" -ForegroundColor Red -OutputFilePath $OutputFilePath -Silent:$Silent
                        break;
                    }
                }
            }
        } catch {
            Write-IgugaColorOutput "[-] $($_.Exception)" -ForegroundColor Red
            return
        }
    } elseif ($Mode -eq "Compare") {
        try {
            $Result = Compare-IgugaFileHash -FilePath $Path -Algorithm $Algorithm -Hash $Hash -Silent:$Silent
            $Script:TotalOfItems = 1
            switch ($Result.Status) {
                "PASS" {
                    $Script:ReportItemsValid++
                    Write-IgugaReportContent -Text $($Script:LocalizedData.ValidationPassed -f $Result.FilePath) -ForegroundColor Green -OutputFilePath $OutputFilePath -Silent:$Silent
                    break;
                }
                "FAIL" {
                    $Script:ReportItemsInvalid++
                    Write-IgugaReportContent -Text $($Script:LocalizedData.ValidationFailed -f $Result.FilePath, $Result.Hash, $Result.ExpectedHash) -ForegroundColor Red -OutputFilePath $OutputFilePath -Silent:$Silent
                    break;
                }
            }
        } catch {
            if ($_.CategoryInfo -eq [ErrorCategory]::ObjectNotFound) {
                Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorUtilityPathNotValidFile -f $Mode, $Path)" -ForegroundColor Red
            } elseif ($_.CategoryInfo -eq [ErrorCategory]::InvalidArgument) {
                Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorUtilityPathNotValidFile -f $Mode, 'Hash')" -ForegroundColor Red
            } else {
                Write-IgugaColorOutput "[-] $($_.Exception)" -ForegroundColor Red
            }
            return
        }
    } elseif ($Mode -eq "Generate") {
        $Parameters = @{
            Path = $Path
            Algorithm = $Algorithm
            UseAbsolutePath = $UseAbsolutePath.IsPresent
            Silent = $Silent.IsPresent
        }

        if ($PSBoundParameters.ContainsKey("Filter")) {
            $Parameters.Filter = $Filter
        }

        if ($PSBoundParameters.ContainsKey("Exclude")) {
            $Parameters.Exclude = $Exclude
        }

        if ($PSBoundParameters.ContainsKey("Depth")) {
            $Parameters.Depth = $Depth
        }

        $Checksums = Get-IgugaPathChecksum @Parameters

        $OutFileName = ""
        # If OutFile is to be generated, then set the outfile name to match the algorithm
        if ($OutFile.IsPresent) {
            $OutFileName = $Algorithm.ToUpper() + "SUMS.txt"
        }

        if ($OutFile.IsPresent) {
            if ([string]::IsNullOrWhiteSpace($OutFilePath)) {
                $OutFilePath = Join-Path -Path $Path -ChildPath $OutFileName
            }
            if (Test-Path -LiteralPath $OutFilePath -PathType Leaf) {
                Remove-Item $OutFilePath;
            }
        }

        if (-not($Silent.IsPresent))
        {
            Write-Progress -Activity $Script:LocalizedData.PrintChecksumProgressMessage -Status $Script:LocalizedData.PrintChecksumProgressStatus;
        }

        $Script:TotalOfItems = $Checksums.Length;

        foreach ($Checksum in $Checksums) {
            $Script:ReportItemsGenerated++;
            if ($OutFile.IsPresent) {
                Add-Content $OutFilePath $Checksum.Checksum
            }
            Write-IgugaReportContent -Text $Checksum.Checksum -ForegroundColor Green -OutputFilePath $OutputFilePath -Silent:$Silent
        }

        if (-not($Silent.IsPresent))
        {
            Write-Progress -Activity $Script:LocalizedData.PrintChecksumProgressCompleted -Completed
        }
    } elseif ($Mode -eq "SetMailerSetting") {
        if ($null -eq $MailerSetting) {
            Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorUtilityParameterRequiredMode -f $Mode, 'MailerSetting')" -ForegroundColor Red
            return
        } else {
            try {
                if ($PSCmdlet.ShouldProcess("MailerSetting", "SetMailerSetting")) {
                    Set-IgugaMailerSetting -Settings $MailerSetting -SettingsFilePath $SettingsFilePath -WhatIf:$WhatIfPreference
                    Write-IgugaReportContent -Text $($Script:LocalizedData.SetSettingSuccess -f 'MailerSetting') -ForegroundColor Green -OutputFilePath $OutputFilePath -Silent:$Silent
                }
            } catch {
                Write-IgugaColorOutput "[-] $($_.Exception)" -ForegroundColor Red
            }
        }
    } elseif ($Mode -eq "ShowMailerSetting") {
        try {
            $settings = Get-IgugaMailerSetting -SettingsFilePath $SettingsFilePath
            Write-IgugaColorOutput ""
            Write-IgugaColorOutput "$($Script:LocalizedData.ShowMailerSettingSmtpServer -f $settings.SMTPServer)"
            Write-IgugaColorOutput "$($Script:LocalizedData.ShowMailerSettingPort -f $settings.Port)"
            if ($settings.Credential) {
                Write-IgugaColorOutput "$($Script:LocalizedData.ShowMailerSettingUsername -f $settings.Credential.Username)"
                Write-IgugaColorOutput "$($Script:LocalizedData.ShowMailerSettingPassword -f '****************')"
            }
            Write-IgugaColorOutput "$($Script:LocalizedData.ShowMailerSettingEncryption -f $settings.Encryption)"
            Write-IgugaColorOutput "$($Script:LocalizedData.ShowMailerSettingFilePath -f $SettingsFilePath)"
            Write-IgugaColorOutput ""
        } catch {
            if ($_.FullyQualifiedErrorId -eq 'PathNotFound') {
                Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorUtilitySettingsFileDoesNotExistsMode -f $Mode, 'SetMailerSetting')" -ForegroundColor Red
                return
            } else {
                Write-IgugaColorOutput "[-] $($_.Exception)" -ForegroundColor Red
                return
            }
        }
    } elseif ($Mode -eq "RemoveMailerSetting") {
        try {
            if ($PSCmdlet.ShouldProcess("MailerSetting", "RemoveMailerSetting")) {
                Remove-IgugaMailerSetting -SettingsFilePath $SettingsFilePath -WhatIf:$WhatIfPreference
                Write-IgugaReportContent -Text $($Script:LocalizedData.RemoveSettingSuccess -f 'MailerSetting') -ForegroundColor Green -OutputFilePath $OutputFilePath -Silent:$Silent
            }
        } catch {
            if ($_.FullyQualifiedErrorId -eq 'PathNotFound') {
                Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorUtilitySettingsFileDoesNotExistsMode -f $Mode, 'SetMailerSetting')" -ForegroundColor Red
                return
            } else {
                Write-IgugaColorOutput "[-] $($_.Exception)" -ForegroundColor Red
                return
            }
        }
    }

    Write-IgugaReporSummary -Mode $Mode -OutputFilePath $OutputFilePath -Algorithm $Algorithm -Path $Path -Footer -Verbose:($PSBoundParameters['Verbose'] -eq $true)

    if (-not($SendEmailNotification -eq "None")) {
        $SendNotification = $false
        if (($SendEmailNotification -eq "Success") -and ($Script:TotalOfItems -eq $Script:ReportItemsValid)) {
            $SendNotification = $true
        } elseif (($SendEmailNotification -eq "NotSuccess") -and ($Script:TotalOfItems -ne $Script:ReportItemsValid)) {
            $SendNotification = $true
        } elseif ($SendEmailNotification -eq "Always") {
            $SendNotification = $true
        }

        if (($Mode -eq 'Validate') -and $SendNotification) {
            $MailerSetting = Get-IgugaMailerSetting -SettingsFilePath $SettingsFilePath

            $TextBody = "$($Script:LocalizedData.ValidationEmailNotificationGreetings)`n"
            $TextBody += "`n"
            $TextBody += "$($Script:LocalizedData.ValidationEmailNotificationInstructions)`n"
            $TextBody += "$($Script:LocalizedData.ValidationEmailNotificationTotalItems -f $Script:TotalOfItems)`n"
            $TextBody += "$($Script:LocalizedData.ValidationEmailNotificationTotalPassed -f $Script:ReportItemsValid)`n"
            $TextBody += "$($Script:LocalizedData.ValidationEmailNotificationTotalFailed -f $Script:ReportItemsInvalid)`n"
            $TextBody += "$($Script:LocalizedData.ValidationEmailNotificationTotalFileNotFound -f $Script:ReportItemsFileNotFound)`n"
            $TextBody += "`n"
            $TextBody += "$($Script:LocalizedData.ValidationEmailNotificationMoreInfo)`n"
            $TextBody += "`n"
            $TextBody += "---`n"
            $TextBody += "$($Script:LocalizedData.ValidationEmailNotificationSignature -f $MyInvocation.MyCommand.Module.Name)`n"

            $Parameters = @{
                MailerSetting = $MailerSetting
                From = $From
                ToList = $ToList
                CcList = $CcList
                BccList = $BccList
                Subject = "$($Script:LocalizedData.ValidationEmailNotificationSubject -f $MyInvocation.MyCommand.Module.Name)"
                TextBody = $TextBody
                AttachmentList = @($OutputFilePath)
            }

            Send-IgugaMailMessage @Parameters
            Write-IgugaColorOutput "[+] $($Script:LocalizedData.EmailNotificationSentWithSuccess)"
        }

        if (-not($OutputFilePathDefinedByUser) -and (Test-Path -LiteralPath $OutputFilePath -PathType Leaf)) {
            Remove-Item $OutputFilePath
        }
    }

    if (-not($Silent.IsPresent)) {
        Write-IgugaColorOutput "[+] $($Script:LocalizedData.OpCompleted)"
        if (-not($PSBoundParameters.ContainsKey("Verbose"))) {
            Write-IgugaColorOutput "[+] $($Script:LocalizedData.VerboseMoreInfo)"
        }
    }
}