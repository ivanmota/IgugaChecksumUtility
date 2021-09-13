function Get-IgugaCanonicalPath() {
    <#
    .SYNOPSIS
        Return the canonical path of a given file or directory
    .DESCRIPTION
        Return the canonical path of a given file or directory using the linux directory separator.
    .PARAMETER Path
        The path to a given file or directory
    .PARAMETER NonExistentPath
        Indicates whether path does not exists or not
    .EXAMPLE
        PS> Get-IgugaCanonicalPath -Path "C:\Test\File.txt"
    .EXAMPLE
        # Get the cannonical path of a non existent path
        PS> Get-IgugaCanonicalPath -Path "C:\Test\This-File-Does-Not-Exists.txt" -NonExistentPath
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        # Path - the path to a given file or directory
        [Parameter(Mandatory=$true)]
        [string]
        $Path,

        # NonExistentPath - indicates whether path does not exists or not
        [switch]
        $NonExistentPath
    )

    # In order to convert the path to a canonical path with need to be sure that the path is not relative
    if (-not([System.IO.Path]::IsPathRooted($Path))) {
        if ($NonExistentPath.IsPresent) {
            # In this case will not use Resolve-path because it requires that the path exists
            $Path = Join-Path -Path (Get-Location).Path -ChildPath $Path
            $Path = Join-Path -Path $Path -ChildPath '.'
            $Path  = [System.IO.Path]::GetFullPath($Path)
        } else {
            if (-not(Test-Path -LiteralPath $Path -PathType Any)) {
                throw [IgugaError]::PathNotFound($Script:LocalizedData.ErrorPathNotFound, $Path)
            }
            $Path = Resolve-Path -LiteralPath $Path
        }
    } else {
        if (-not($NonExistentPath.IsPresent) -and -not(Test-Path -LiteralPath $Path -PathType Any)) {
            throw [IgugaError]::PathNotFound($Script:LocalizedData.ErrorPathNotFound, $Path)
        }
    }

    $WindowsDirSep = [System.IO.Path]::DirectorySeparatorChar
    $LinuxDirSep = [System.IO.Path]::AltDirectorySeparatorChar

    if ($NonExistentPath.IsPresent -or $IsLinux) {
        return $Path.Replace($WindowsDirSep, $LinuxDirSep).TrimEnd($LinuxDirSep)
    }

    $IsDirectory = -not(Test-Path -LiteralPath $Path -PathType Leaf)

    $AdaptedPath = (Split-Path -Path $Path -NoQualifier).Replace($WindowsDirSep, $LinuxDirSep).Trim($LinuxDirSep)
    $Parts = $AdaptedPath.Split($LinuxDirSep)
    # we should avoid to use (Split-Path -Path $Path -Qualifier) because it does not work with UNC Path
    $CanonicalPath = (Get-Item -Path $Path).PSDrive.Root

    if ([string]::IsNullOrEmpty($CanonicalPath)) {
        if ($Parts.Count -ge 2 -and ($Path.StartsWith("\\") -or $Path.StartsWith("//"))) {
            $CanonicalPath = $LinuxDirSep + $LinuxDirSep + $($Parts[0]) + $LinuxDirSep + $($Parts[1])
            $Parts = if ($Parts.Count -eq 2) {
                @()
            } else {
                $Parts[2 .. ($Parts.Count - 1)]
            }
        } else {
            throw [IgugaError]::InvalidArgument($Script:LocalizedData.ErrorInvalidArgument, "Path")
        }
    }

    for ($i = 0; $i -lt $Parts.Count; $i++) {
        if ((($i + 1) -lt $Parts.Count) -or $IsDirectory) {
            $CanonicalPath = (Get-ChildItem -LiteralPath $CanonicalPath -Directory -Force | Where-Object Name -eq $Parts[$i]).FullName
        } else {
            $CanonicalPath = (Get-ChildItem -LiteralPath $CanonicalPath -File -Force | Where-Object Name -eq $Parts[$i]).FullName
        }
    }

    return $CanonicalPath.Replace($WindowsDirSep, $LinuxDirSep).TrimEnd($LinuxDirSep)
}
