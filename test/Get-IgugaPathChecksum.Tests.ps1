BeforeAll {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
    $SuppressImportModule = $true

    . $PSScriptRoot\Shared.ps1
    . $PSScriptRoot\..\src\Classes\IgugaError.ps1
    . $PSScriptRoot\..\src\Classes\IgugaChecksum.ps1
    . $PSScriptRoot\..\src\Classes\IgugaValidateResult.ps1
    . $PSScriptRoot\..\src\Private\Get-IgugaCanonicalPath.ps1
    . $PSScriptRoot\..\src\Private\Get-IgugaRelativePath.ps1
    . $PSScriptRoot\..\src\Private\Test-IgugaLikeAny.ps1
    . $PSScriptRoot\..\src\Public\Get-IgugaChecksum.ps1
    . $PSScriptRoot\..\src\Public\Get-IgugaPathChecksum.ps1
}

Describe 'Get-IgugaPathChecksum' {
    It 'Pass get single file checksum' {
        $FilePath = Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx"
        $Checksum = (Get-IgugaChecksum -FilePath $FilePath -AlternactiveFilePath "./File.docx").Checksum

        $Results = Get-IgugaPathChecksum -Path $FilePath -Silent
        $Results.Length | Should -Be 1
        $Results[0].Checksum | Should -Be $Checksum
    }

    It 'Pass get single file checksum with absolute path' {
        $FilePath = Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx"
        $Checksum = (Get-IgugaChecksum -FilePath $FilePath).Checksum

        $Results = Get-IgugaPathChecksum -Path $FilePath -Silent -UseAbsolutePath
        $Results.Length | Should -Be 1
        $Results[0].Checksum | Should -Be $Checksum
    }

    It 'Pass get directory depth 0' {
        $Path = Join-Path -Path $ModuleTestPath -ChildPath "Data"
        $Results = Get-IgugaPathChecksum -Path $Path -Depth 0 -Silent -UseAbsolutePath
        $Results.Length | Should -Be 2
    }

    It 'Pass get directory checksum' {
        $Path = Join-Path -Path $ModuleTestPath -ChildPath "Data"
        $ExpectedChecksums = @();
        $ExpectedChecksums += Get-IgugaChecksum -FilePath $(Join-Path -Path $Path -ChildPath "File.docx") -AlternactiveFilePath "./File.docx"
        $ExpectedChecksums += Get-IgugaChecksum -FilePath $(Join-Path -Path $Path -ChildPath "SubDirectory\File2.docx") -AlternactiveFilePath "./SubDirectory/File2.docx"

        $Results = Get-IgugaPathChecksum -Path $Path -Exclude "SHA256SUMS.txt" -Silent
        $Results.Length | Should -Be $ExpectedChecksums.Length
        $Results[0].Checksum | Should -Be $ExpectedChecksums[0].Checksum
        $Results[1].Checksum | Should -Be $ExpectedChecksums[1].Checksum
    }
}