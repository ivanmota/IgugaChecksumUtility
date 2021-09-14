
function Get-IgugaChecksum() {
	<#
    .SYNOPSIS
        Get the checksum info from a given file
    .DESCRIPTION
        Calculate the hash of specific file and return the checksum info
    .PARAMETER FilePath
        Sets the path to a given file
    .PARAMETER Algorithm
        Sets the hashing algorithm to be used. The allowed algotithms are: MD5, SHA1, SHA256, SHA384 and SHA512
    .PARAMETER AlternactiveFilePath
        Sets the alternactive path to use on the checksum file path
    .EXAMPLE
        PS> Get-IgugaChecksum -FilePath "C:\Test\File.txt" -Algorithm MD5
    .EXAMPLE
        # using an alternactive file path
        PS> Get-IgugaChecksum -FilePath "C:\Test\File.txt" -Algorithm MD5 -AlternactiveFilePath ".\File.txt"
    #>
    [OutputType([IgugaChecksum])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]
        $FilePath,

        [ValidateSet("MD5", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]
        $Algorithm = "SHA256",

        [string]
        [AllowEmptyString()]
        $AlternactiveFilePath = ""
    )

    $WindowsDirSep = [System.IO.Path]::DirectorySeparatorChar
    $LinuxDirSep = [System.IO.Path]::AltDirectorySeparatorChar

    $FileResults = Get-FileHash -LiteralPath $FilePath -Algorithm $Algorithm

    if ([string]::IsNullOrWhiteSpace($AlternactiveFilePath)) {
        $AlternactiveFilePath = $FileResults.Path
    }

    $AlternactiveFilePath = $AlternactiveFilePath.Replace($WindowsDirSep, $LinuxDirSep)

    if ($AlternactiveFilePath.StartsWith(".$LinuxDirSep")) {
        $AlternactiveFilePath = $AlternactiveFilePath.Substring(".$LinuxDirSep".Length)
    }

    $Checksum = $FileResults.Hash + "  " + $AlternactiveFilePath

    return [IgugaChecksum]::new($FileResults.Path.Replace($WindowsDirSep, $LinuxDirSep), $FileResults.Hash, $Checksum)
}
