function Compare-IgugaFileHash {
    <#
    .SYNOPSIS
        Compare a file with a known hash
    .DESCRIPTION
        Perform a compare operation on a file with a known hash
    .PARAMETER FilePath
        Sets the path to a given file
    .PARAMETER Algorithm
        Sets the hashing algorithm to be used in the checksum validation. The allowed algotithms are: MD5, SHA1, SHA256, SHA384 and SHA512
    .PARAMETER Hash
        Sets the specific previously known hash
    .PARAMETER Silent
        Omitte the progress status
    .EXAMPLE
        # Perform a compare operation on a file with a known hash
        Compare-IgugaFileHash -Path "C:\Test\SHA512SUMS.txt" -Algorithm SHA512
    #>
    [OutputType([IgugaValidateResult])]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0, Mandatory = $true, HelpMessage = "The path to a given file")]
        [string]
        $FilePath,

        [ValidateSet("MD5", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]
        $Algorithm = "SHA256",

        [string]
        $Hash,

        [switch]
        $Silent
    )

    if (-not(Test-Path -LiteralPath $FilePath -PathType Leaf)) {
        throw [IgugaError]::PathNotFound($Script:LocalizedData.ErrorPathNotFound, $FilePath)
    }

    if ([string]::IsNullOrWhiteSpace($Hash)) {
        throw [IgugaError]::InvalidArgument($Script:LocalizedData.ErrorInvalidArgument, "Hash")
    }

    if (-not($Silent.IsPresent)) {
        Write-Progress -Activity $($Script:LocalizedData.CompareOpProgressMessage -f $FilePath) -Status $Script:LocalizedData.CompareOpProgressStatus
    }

    $Hash = $Hash.Trim().ToUpper()

    $Checksum = Get-IgugaChecksum -FilePath $FilePath -Algorithm $Algorithm

    $Result = if ($Hash.Equals($Checksum.Hash)) {
        [IgugaValidateResult]::new($Checksum.FilePath, "PASS", $Hash, $Checksum.Hash)
    } else {
        [IgugaValidateResult]::new($Checksum.FilePath, "FAIL", $Hash, $Checksum.Hash)
    }

    if (-not($Silent.IsPresent)) {
        Write-Progress -Activity $Script:LocalizedData.CompareOpProgressCompleted -Completed
    }

    return $Result
}