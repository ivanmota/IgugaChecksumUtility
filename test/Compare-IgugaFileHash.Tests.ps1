BeforeAll {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
    $SuppressImportModule = $true

    . $PSScriptRoot\Shared.ps1
    . $PSScriptRoot\..\src\Classes\IgugaErrorClass.ps1
    . $PSScriptRoot\..\src\Classes\IgugaValidateResultClass.ps1
    . $PSScriptRoot\..\src\Classes\IgugaChecksumClass.ps1
    . $PSScriptRoot\..\src\Public\Get-IgugaChecksum.ps1
    . $PSScriptRoot\..\src\Public\Compare-IgugaFileHash.ps1
}

Describe 'Compare-IgugaFileHash' {
    It 'Should throw an error when the file path does not exists' {
        $FilePath = Join-Path -Path $ModuleTestPath -ChildPath "Data\FileNotFound.txt"
        $KnownHash = "D0B79192B857365CCE727E6CE415ACCB2F19CADECD549EC72ECD3627F5B7F8F3"
        { Compare-IgugaFileHash -FilePath $FilePath -Hash $KnownHash -Silent } | Should -Throw
    }

    It 'Should throw an error when the hash parameter has not been passed' {
        $FilePath = Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx"
        { Compare-IgugaFileHash -FilePath $FilePath -Silent } | Should -Throw
    }

    It 'Pass Compare' {
        $FilePath = Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx"
        $KnownHash = "D0B79192B857365CCE727E6CE415ACCB2F19CADECD549EC72ECD3627F5B7F8F3"
        $Result = Compare-IgugaFileHash -FilePath $FilePath -Hash $KnownHash -Silent
        $Result.Status | Should -Be "PASS"
        $Result.Hash | Should -Be $KnownHash
    }

    It 'Fail Compare' {
        $FilePath = Join-Path -Path $ModuleTestPath -ChildPath "Data\SubDirectory\File2.docx"
        $KnownHash = "D0B79192B857365CCE727E6CE415ACCB2F19CADECD549EC72ECD3627F5B7F8F3"
        $Result = Compare-IgugaFileHash -FilePath $FilePath -Hash $KnownHash -Silent
        $Result.Status | Should -Be "FAIL"
        $Result.Hash | Should -Not -Be $KnownHash
    }
}