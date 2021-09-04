function Get-IgugaPathChecksum {
    <#
    .SYNOPSIS
        Get the checksums for files or directories
    .DESCRIPTION
        Get the checksums hashes for a variety of algorithms for the purposes of file validation
    .PARAMETER Path
        Sets the path to a given file or directory
    .PARAMETER Algorithm
        Sets the hashing algorithm to be used in the checksum operation. The allowed algotithms are: MD5, SHA1, SHA256, SHA384 and SHA512
    .PARAMETER Filter
        When the path is a directory, specifies a filter to qualify the Path parameter. Example: '*.txt'
    .PARAMETER Exclude
        When the path is a directory, specifies an array of one or more string patterns to be matched as the cmdlet gets child items.
        Any matching item is excluded from the output. Enter a path element or pattern, such as *.txt or A*. Wildcard characters are accepted
    .PARAMETER Depth
        When the path is a directory, allow you to limit the recursion to X levels.
        For example, -Depth 2 includes the Path parameter's directory, first level of subdirectories, and second level of subdirectories.
    .PARAMETER UseAbsolutePath
        Sets whether the checksum file path should be absolute or not
    .PARAMETER Silent
        Omitte the progress status
    .EXAMPLE
        # Get the checksum info for a single file
        Get-IgugaPathChecksum -Path "C:\Test\File.docx"
    .EXAMPLE
        # Get the checksums of an entire directory using the SHA512 algorithm
        Get-IgugaPathChecksum -Path "C:\Test\" -Algorithm SHA512
    #>
    [OutputType([IgugaChecksum[]])]
    [CmdletBinding()]
    Param(
        [Parameter(Position = 0,
        Mandatory = $true,
        HelpMessage = "The path to a given file or directory")]
        [string]
        $Path,

        [ValidateSet("MD5", "SHA1", "SHA256", "SHA384", "SHA512")]
        [string]
        $Algorithm = "SHA256",

        [string]
        $Filter,

        [string[]]
        $Exclude,

        [int]
        $Depth,

        [Switch]
        $UseAbsolutePath,

        [Switch]
        $Silent
    )

    $Checksums = @()

    $Path = Get-IgugaCanonicalPath -Path $Path;

    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        if (-not($Silent.IsPresent))
        {
            Write-Progress -Activity $Script:LocalizedData.GenerateOpProgressMessage -Status $Script:LocalizedData.GenerateOpProgressStatus;
        }

        $AlternactiveFilePath = "";
        $DirectoryPath = (Get-Item -LiteralPath $Path).Directory.FullName;
        if (-not($UseAbsolutePath.IsPresent)) {
            $AlternactiveFilePath = Get-IgugaRelativePath -RelativeTo $DirectoryPath -Path $Path;
        }

        $Checksums += Get-IgugaChecksum -FilePath $Path -Algorithm $Algorithm -AlternactiveFilePath $AlternactiveFilePath;

        if (-not($Silent.IsPresent))
        {
            Write-Progress -Activity $Script:LocalizedData.GenerateOpProgressCompleted -Completed;
        }
    } else {
        if (-not($Silent.IsPresent))
        {
            Write-Progress -Activity $($Script:LocalizedData.DiscoveringFilesProgressMessage -f $Path) -Status $Script:LocalizedData.DiscoveringFilesProgressStatus;
        }

        $Parameters = @{
            LiteralPath = $Path
            Filter = $Filter
            File = $true
        }

        if ($PSBoundParameters.ContainsKey("Depth") -and $Depth -and ($Depth -ge 0)) {
            $Parameters.Depth = $Depth
        } else {
            $Parameters.Recurse = $true
        }

        $Files = if ($PSVersionTable.PSVersion.Major -le 5 -and $Exclude) {
            #on PS 5 the exclude does not work as expected
            Get-ChildItem @Parameters | Where-Object { -not(Test-IgugaLikeAny $_.Name $Exclude) } | Sort-Object {$_.FullName}
        } else {
            $Parameters.Exclude = $Exclude
            Get-ChildItem @Parameters | Sort-Object {$_.FullName}
        }

        if (-not($Silent.IsPresent))
        {
            Write-Progress -Activity $Script:LocalizedData.DiscoveringFilesProgressCompleted -Completed;
        }

        $i = 1;
        foreach ($File in $Files) {
            if (Test-Path -LiteralPath $File.FullName -PathType Leaf) {
                $AlternactiveFilePath = "";
                if (-not($UseAbsolutePath.IsPresent)) {
                    $AlternactiveFilePath = Get-IgugaRelativePath -RelativeTo $Path -Path $File.FullName;
                }

                $Checksums += Get-IgugaChecksum -FilePath $File.FullName -Algorithm $Algorithm -AlternactiveFilePath $AlternactiveFilePath;

                if (-not($Silent.IsPresent))
                {
                    Write-Progress -Activity $($Script:LocalizedData.GenerateOpProgressMessage -f $File.FullName) -Status $($Script:LocalizedData.GenerateOpCounterProgressStatus -f $i, $Files.Count) -PercentComplete (($i / $Files.Count) * 100);
                    $i++
                }
            }
        }
    }

    Write-Output $Checksums -NoEnumerate
}