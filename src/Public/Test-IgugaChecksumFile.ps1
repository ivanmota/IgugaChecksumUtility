function Test-IgugaChecksumFile {
    <#
    .SYNOPSIS
        Validate checksum file
    .DESCRIPTION
        Validate a give checksum file
    .PARAMETER FilePath
        Sets the path to a given checksum file
    .PARAMETER Algorithm
        Sets the hashing algorithm to be used in the checksum validation. The allowed algotithms are: MD5, SHA1, SHA256, SHA384 and SHA512
    .PARAMETER Silent
        Omitte the progress status
    .EXAMPLE
        # Perform a validate operation on a checksum file
        Test-IgugaChecksumFile -Path C:\Test\SHA512SUMS.txt -Algorithm SHA512
    #>
    [OutputType([IgugaValidateResult[]])]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0,
        Mandatory = $true,
        HelpMessage = "The path to a given file checksum file")]
        [string]
        $FilePath,

        [ValidateSet("MD5", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]
        $Algorithm = "SHA256",

        [switch]
        $Silent
    )

    $Results = @();

    $WindowsDirSep = "\"
    $LinuxDirSep = "/"

    if (Test-Path -LiteralPath $FilePath -PathType Leaf) {
        $runningChar = "/"
        Get-Content -LiteralPath $FilePath | ForEach-Object {
            if (-not($Silent.IsPresent)) {
                $runningChar = if ($runningChar -eq "/") { "\" } else { "/" }
                Write-Progress -Activity $($Script:LocalizedData.ValidateOpProgressMessage -f $FilePath) -Status $($Script:LocalizedData.ValidateOpProgressStatus -f $runningChar);
            }

            $SplitChecksum = $_.Split("  ", 2);
            $CurrentStoredHash = $SplitChecksum[0].Trim().ToUpper();
            $CurrentStoredFilePath = $SplitChecksum[1].Trim();

            # Check if the file path is relative
            if (-not([System.IO.Path]::IsPathRooted($CurrentStoredFilePath))) {
                $DirectoryPath = (Get-Item -LiteralPath $FilePath).Directory.FullName;
                $CurrentStoredFilePath = Join-Path -Path $DirectoryPath -ChildPath $CurrentStoredFilePath;
            }

            $CurrentStoredFilePath = $CurrentStoredFilePath.Replace($WindowsDirSep, $LinuxDirSep).TrimEnd($LinuxDirSep)

            if (Test-Path -LiteralPath $CurrentStoredFilePath -PathType Leaf) {
                $ReturnedHash = (Get-IgugaChecksum -FilePath $CurrentStoredFilePath -Algorithm $Algorithm).Hash
                if ($ReturnedHash.Equals($CurrentStoredHash) ) {
                    $Results += [IgugaValidateResult]::new($CurrentStoredFilePath, "PASS", $CurrentStoredHash, $ReturnedHash)
                }
                else {
                    $Results += [IgugaValidateResult]::new($CurrentStoredFilePath, "FAIL", $CurrentStoredHash, $ReturnedHash);
                }
            } else {
                $Results += [IgugaValidateResult]::new($CurrentStoredFilePath, "NOT_FOUND")
            }
        }

        if (($Results.Length -gt 0) -and -not($Silent.IsPresent)) {
            Write-Progress -Activity $Script:LocalizedData.ValidateOpProgressCompleted -Completed;
        }
    } else {
        throw [IgugaError]::PathNotFound($Script:LocalizedData.ErrorPathNotFound, $FilePath)
    }

    Write-Output $Results -NoEnumerate
}