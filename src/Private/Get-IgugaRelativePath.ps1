function Get-IgugaRelativePath() {
    <#
    .SYNOPSIS
        Returns a relative path from one path to another.
    .DESCRIPTION
        Returns a relative path from one path to another using the linux directory separator.
    .PARAMETER RelativeTo
        The source path the result should be relative to. This path is always considered to be a directory.
    .PARAMETER Path
        The destination path.
    .EXAMPLE
        PS> Get-IgugaRelativePath -RelativeTo "C:\Test\" -Path "C:\Test\File.txt"
    #>
    [OutputType([string])]
    [CmdletBinding()]
    param(
        [Parameter(Position = 0, Mandatory = $true)]
        [string]
        $RelativeTo,

        [Parameter(Position = 1, Mandatory = $true)]
        [string]
        $Path
    )

    if (-not([System.IO.Path]::IsPathRooted($RelativeTo))) {
        if (-not(Test-Path -LiteralPath $RelativeTo -PathType Any)) {
            # In this case will not use Resolve-path because it requires that the path exists
            $RelativeTo = Join-Path -Path (Get-Location).Path -ChildPath $RelativeTo
            $RelativeTo = Join-Path -Path $RelativeTo -ChildPath '.'
            $RelativeTo  = [System.IO.Path]::GetFullPath($RelativeTo)
        } else {
            $RelativeTo = Resolve-Path -LiteralPath $RelativeTo
        }
    }

    if (-not([System.IO.Path]::IsPathRooted($Path))) {
        if (-not(Test-Path -LiteralPath $Path -PathType Any)) {
            # In this case will not use Resolve-path because it requires that the path exists
            $Path = Join-Path -Path (Get-Location).Path -ChildPath $Path
            $Path = Join-Path -Path $Path -ChildPath '.'
            $Path  = [System.IO.Path]::GetFullPath($Path)
        } else {
            $Path = Resolve-Path -LiteralPath $Path
        }
    }

    $WindowsDirSep = [System.IO.Path]::DirectorySeparatorChar
    $LinuxDirSep = [System.IO.Path]::AltDirectorySeparatorChar

    $RelativeTo = $RelativeTo.Replace($WindowsDirSep, $LinuxDirSep).TrimEnd($LinuxDirSep)
    $Path = $Path.Replace($WindowsDirSep, $LinuxDirSep).TrimEnd($LinuxDirSep)

    $Result = $Path
    $Pos = $Path.IndexOf($RelativeTo)
    if ($Pos -eq 0) {
        if ($RelativeTo.Length -eq $Path.Length) {
            $Result = ".$LinuxDirSep"
        } else {
            $Result = ".$LinuxDirSep" + $Path.Remove(0, $RelativeTo.Length).TrimStart($LinuxDirSep)
        }
    }

    return $Result
}
