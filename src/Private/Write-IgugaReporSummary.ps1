function Write-IgugaReporSummary() {
    param(
        # Mode - sets the operation mode.
        [Parameter(Position = 0, Mandatory = $true)]
        [ValidateSet("Generate", "Validate", "Compare")]
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

    $HasOutput = $false;
    $OutputFileExists = $false;
    if (-not([string]::IsNullOrWhiteSpace($OutputFilePath))) {
        $OutputFileExists = Test-Path -LiteralPath $OutputFilePath -PathType Leaf;
        $OutputFilePath = Get-IgugaCanonicalPath -Path $OutputFilePath -NonExistentPath:$(-not($OutputFileExists));
        $HasOutput = $true;
    }

    if ($Footer.IsPresent) {
        $FooterNotes = @(
            "",
            "Ended at: $((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))",
            "Operation Mode: $Mode",
            "File Path: $Path",
            "Checksum Algorithm: $Algorithm"
        );

        if ($Mode -eq "Generate") {
            $FooterNotes = @(
                ""
                "Ended at: $((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))",
                "Operation Mode: $Mode",
                "Total of Items: $($Script:TotalOfItems)",
                "Generated: $($Script:ReportItemsGenerated)",
                "FileNotFound: $($Script:ReportItemsFileNotFound)",
                "Path: $Path",
                "Checksum Algorithm: $Algorithm"
            );
        } elseif ($Mode -eq "Validate") {
            $FooterNotes = @(
                ""
                "Ended at: $((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))",
                "Operation Mode: $Mode",
                "Total of Items: $($Script:TotalOfItems)",
                "Passed: $($Script:ReportItemsValid)",
                "Failed: $($Script:ReportItemsInvalid)",
                "FileNotFound: $($Script:ReportItemsFileNotFound)",
                "Checksum File Path: $Path",
                "Checksum Algorithm: $Algorithm"
            );
        }

        if ($HasOutput) {
            $FooterNotes += "Output File Path: $OutputFilePath";
        }

        for ($i = 0; $i -lt $FooterNotes.Count; $i++) {
            if ($HasOutput) {
                Add-Content -LiteralPath $OutputFilePath -Value $FooterNotes[$i];
            }

            if (-not([string]::IsNullOrWhiteSpace($FooterNotes[$i]))) {
                Write-Verbose $FooterNotes[$i];
            }
        }

        return;
    }

    $HeaderNotes = @(
        "Agent: $($MyInvocation.MyCommand.Module.Name)",
        "Version: $($MyInvocation.MyCommand.Module.Version.ToString())",
        "Description: $($MyInvocation.MyCommand.Module.Description)",
        "Project Url: $($MyInvocation.MyCommand.Module.ProjectUri)",
        "Author: $($MyInvocation.MyCommand.Module.Author)",
        "Started at:  $((Get-Date).ToString("yyyy-dd-MM HH:mm:ss"))",
        ""
    );

    if ($HasOutput -and -not($OutputFileExists)) {
        $null = New-Item -Path $OutputFilePath -ItemType File;
    }

    for ($i = 0; $i -lt $HeaderNotes.Count; $i++) {
        if ($HasOutput) {
            if ($i -eq 0) {
                Set-Content -LiteralPath $OutputFilePath -Value $HeaderNotes[$i];
                continue;
            }
            Add-Content -LiteralPath $OutputFilePath -Value $HeaderNotes[$i];
        }

        if (-not([string]::IsNullOrWhiteSpace($HeaderNotes[$i]))) {
            Write-Verbose $HeaderNotes[$i];
        }
    }
}