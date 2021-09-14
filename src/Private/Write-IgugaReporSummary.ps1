function Write-IgugaReporSummary() {
    param(
        # Mode - sets the operation mode.
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateSet("Generate", "Validate", "Compare", "SetMailerSetting", "RemoveMailerSetting", "ShowMailerSetting")]
        [string]
        $Mode,

        # OutputFilePath - sets the file path to export the summary
        [Parameter(Position = 1, Mandatory = $true)]
        [AllowEmptyString()]
        [string]
        $OutputFilePath,

        # Sets the hashing algorithm to be used in the checksum operation. (Default: SHA256)
        [ValidateSet("MD5", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]
        $Algorithm = "SHA256",

        # Path - sets the path to a given file or directory
        [string]
        $Path,

        # Footer - indicates whether this is the footer summary or not
        [switch]
        $Footer
    )

    $HasOutput = $false
    $OutputFileExists = $false
    if (-not([string]::IsNullOrWhiteSpace($OutputFilePath))) {
        $OutputFileExists = Test-Path -LiteralPath $OutputFilePath -PathType Leaf
        $OutputFilePath = if ($OutputFileExists) {
            Get-IgugaCanonicalPath -Path $OutputFilePath
        } else {
            Get-IgugaCanonicalPath -Path $OutputFilePath -NonExistentPath
        }
        $HasOutput = $true
    }

    if ($Footer.IsPresent) {
        $FooterNotes = @(
            "",
            "$($Script:LocalizedData.ReportSummaryEndedAt -f $(Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))",
            "$($Script:LocalizedData.ReportSummaryOperationMode -f $Mode)"
        )

        if ($Mode -eq "Compare") {
            $FooterNotes = @(
                "",
                "$($Script:LocalizedData.ReportSummaryEndedAt -f $(Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))",
                "$($Script:LocalizedData.ReportSummaryOperationMode -f $Mode)",
                "$($Script:LocalizedData.ReportSummaryFilePath -f $Path)",
                "$($Script:LocalizedData.ReportSummaryChecksumAlgorithm -f $Algorithm)"
            )
        } elseif ($Mode -eq "Generate") {
            $FooterNotes = @(
                "",
                "$($Script:LocalizedData.ReportSummaryEndedAt -f $(Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))",
                "$($Script:LocalizedData.ReportSummaryOperationMode -f $Mode)",
                "$($Script:LocalizedData.ReportSummaryTotalOfItems -f $Script:TotalOfItems)",
                "$($Script:LocalizedData.ReportSummaryTotalGenerated -f $Script:ReportItemsGenerated)",
                "$($Script:LocalizedData.ReportSummaryTotalFileNotFound -f $Script:ReportItemsFileNotFound)",
                "$($Script:LocalizedData.ReportSummaryPath -f $Path)",
                "$($Script:LocalizedData.ReportSummaryChecksumAlgorithm -f $Algorithm)"
            )
        } elseif ($Mode -eq "Validate") {
            $FooterNotes = @(
                "",
                "$($Script:LocalizedData.ReportSummaryEndedAt -f $(Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))",
                "$($Script:LocalizedData.ReportSummaryOperationMode -f $Mode)",
                "$($Script:LocalizedData.ReportSummaryTotalOfItems -f $Script:TotalOfItems)",
                "$($Script:LocalizedData.ReportSummaryTotalPassed -f $Script:ReportItemsValid)",
                "$($Script:LocalizedData.ReportSummaryTotalFailed -f $Script:ReportItemsInvalid)",
                "$($Script:LocalizedData.ReportSummaryTotalFileNotFound -f $Script:ReportItemsFileNotFound)",
                "$($Script:LocalizedData.ReportSummaryChecksumFilePath -f $Path)",
                "$($Script:LocalizedData.ReportSummaryChecksumAlgorithm -f $Algorithm)"
            )
        }

        if ($HasOutput) {
            $FooterNotes += "$($Script:LocalizedData.ReportSummaryOutputFilePath -f $OutputFilePath)"
        }

        for ($i = 0; $i -lt $FooterNotes.Count; $i++) {
            if ($HasOutput) {
                Add-Content -LiteralPath $OutputFilePath -Value $FooterNotes[$i]
            }

            if (-not([string]::IsNullOrWhiteSpace($FooterNotes[$i]))) {
                Write-Verbose $FooterNotes[$i];
            }
        }

        return;
    }

    $HeaderNotes = @(
        "$($Script:LocalizedData.ReportSummaryAgent -f $MyInvocation.MyCommand.Module.Name)",
        "$($Script:LocalizedData.ReportSummaryVersion -f $MyInvocation.MyCommand.Module.Version.ToString())",
        "$($Script:LocalizedData.ReportSummaryDescription -f $MyInvocation.MyCommand.Module.Description)",
        "$($Script:LocalizedData.ReportSummaryProjectUrl -f $MyInvocation.MyCommand.Module.ProjectUri)",
        "$($Script:LocalizedData.ReportSummaryAuthor -f $MyInvocation.MyCommand.Module.Author)",
        "$($Script:LocalizedData.ReportSummaryStartedAt -f $(Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))",
        ""
    )

    if ($HasOutput -and -not($OutputFileExists)) {
        $null = New-Item -Path $OutputFilePath -ItemType File;
    }

    for ($i = 0; $i -lt $HeaderNotes.Count; $i++) {
        if ($HasOutput) {
            if ($i -eq 0) {
                Set-Content -LiteralPath $OutputFilePath -Value $HeaderNotes[$i]
                continue;
            }
            Add-Content -LiteralPath $OutputFilePath -Value $HeaderNotes[$i]
        }

        if (-not([string]::IsNullOrWhiteSpace($HeaderNotes[$i]))) {
            Write-Verbose $HeaderNotes[$i]
        }
    }
}