function IgugaChecksumUtility {
    <#
    .SYNOPSIS
        Generates and validate checksums for files or directories
    .DESCRIPTION
        Generates and validate checksum file hashes for a variety of algorithms
    .PARAMETER Mode
        Sets the operation mode
    .PARAMETER Path
        Sets the path to a given file or directory
    .PARAMETER Algorithm
        Sets the hashing algorithm to be used in the checksum operation. The allowed algotithms are: MD5, SHA1, SHA256, SHA384 and SHA512
    .PARAMETER Hash
        Use with Compare mode, sets the specific previously known hash
    .PARAMETER Filter
        Use with Generate mode when the path is a directory, specifies a filter to qualify the Path parameter. Example: '*.txt'
    .PARAMETER Exclude
        Use with Generate mode when the path is a directory, specifies an array of one or more string patterns to be matched as the cmdlet gets child items.
        Any matching item is excluded from the output. Enter a path element or pattern, such as *.txt or A*. Wildcard characters are accepted
    .PARAMETER Depth
        Use with Generate mode when the path is a directory, allow you to limit the recursion to X levels.
        For example, -Depth 2 includes the Path parameter's directory, first level of subdirectories, and second level of subdirectories.
    .PARAMETER OutFile
        Use with Generate mode, sets whether it will generate a checksum file or not
    .PARAMETER OutFilePath
        Use with Generate mode, sets the path of the generated checksum file.
        If this parameter is not provided the default name will be "{Algorithm}SUMS.txt" and will be stored on the Path directory
    .PARAMETER UseAbsolutePath
        Use with Generate mode, sets whether the checksum file path should be absolute or not
    .PARAMETER OutputFilePath
        Sets the file path to export the output. If the output file path is not provided the output will be printed to the console
    .PARAMETER Silent
        Omitte the progress status and the output will not be printed on the console
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
        # Perform a compare operation on a file with a known hash
        IgugaChecksumUtility -Mode Compare -Path C:\Test\File.docx -Algorithm SHA1 -Hash ED1B042C1B986743C1E34EBB1FAF758549346B24
    #>
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The the operation mode. The allowed modes are: Generate, Validate and Compare")]
        [ValidateSet("Generate", "Validate", "Compare")]
        [string]
        $Mode,

        [Parameter(Position = 1,
        Mandatory = $true,
        HelpMessage = "The path to a given file or directory")]
        [string]
        $Path,

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
        $Silent
    )

    $Script:TotalOfItems = 0
    $Script:ReportItemsGenerated = 0
    $Script:ReportItemsValid = 0
    $Script:ReportItemsInvalid = 0
    $Script:ReportItemsFileNotFound = 0

    if (-not(Test-Path -LiteralPath $Path -PathType Any)) {
        Write-IgugaColorOutput "[-] $($Script:LocalizedData.ErrorUtilityPathNotFound -f $Mode, $Path)" -ForegroundColor Red
        return;
    }

    Write-IgugaReporSummary -Mode $Mode -OutputFilePath $OutputFilePath -Algorithm $Algorithm -Path $Path -Verbose:($PSBoundParameters['Verbose'] -eq $true)

    if ($Mode -eq "Validate") {
        try {
            $Results = Test-IgugaChecksumFile -FilePath $Path -Algorithm $Algorithm -Silent:$Silent
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
                    default {}
                }
            }
        } catch {
            if ($_.CategoryInfo -eq [ErrorCategory]::ObjectNotFound) {
                Write-Error -Message "[-] $($Script:LocalizedData.ErrorUtilityPathNotValidFile -f $Mode, $Path)" -Category ObjectNotFound
            } else {
                Write-Error -Message "[-] $($_.Exception)"
            }
        }
    } elseif ($Mode -eq "Compare") {
        try {
            $Results = Compare-IgugaFileHash -FilePath $Path -Algorithm $Algorithm -Hash $Hash -Silent:$Silent
            $Script:TotalOfItems = 1
            switch ($Result.Status) {
                "PASS" {
                    $Script:ReportItemsValid++
                    Write-IgugaReportContent -Text $($Script:LocalizedData.ValidationPassed -f $Result.FilePath) -ForegroundColor Green -OutputFilePath $OutputFilePath -Silent:$Silent
                    break;
                }
                "FAIL" {
                    $Script:ReportItemsInvalid++
                    Write-IgugaReportContent -Text $($Script:LocalizedData.ValidationFailed -f $Result.FilePath, $Result.Hash, $Result.ExpectedHash) -ForegroundColor Green -OutputFilePath $OutputFilePath -Silent:$Silent
                    break;
                }
                default {}
            }
        } catch {
            if ($_.CategoryInfo -eq [ErrorCategory]::ObjectNotFound) {
                Write-Error -Message "[-] $($Script:LocalizedData.ErrorUtilityPathNotValidFile -f $Mode, $Path)" -Category ObjectNotFound
            } elseif ($_.CategoryInfo -eq [ErrorCategory]::InvalidArgument) {
                Write-Error -Message "[-] $($Script:LocalizedData.ErrorUtilityPathNotValidFile -f $Mode, 'Hash')" -Category InvalidArgument
            } else {
                Write-Error -Message "[-] $($_.Exception)"
            }
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
    }

    Write-IgugaReporSummary -Mode $Mode -OutputFilePath $OutputFilePath -Algorithm $Algorithm -Path $Path -Footer -Verbose:($PSBoundParameters['Verbose'] -eq $true)

    if (-not($Silent.IsPresent)) {
        Write-IgugaColorOutput "[+] $($Script:LocalizedData.OpCompleted)"
        if (-not($PSBoundParameters.ContainsKey("Verbose"))) {
            Write-IgugaColorOutput "[+] $($Script:LocalizedData.VerboseMoreInfo)"
        }
    }
}