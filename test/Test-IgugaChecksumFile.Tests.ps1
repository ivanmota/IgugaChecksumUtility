BeforeAll {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
    $SuppressImportModule = $true

    . $PSScriptRoot\Shared.ps1
    . $PSScriptRoot\..\src\Classes\IgugaErrorClass.ps1
    . $PSScriptRoot\..\src\Classes\IgugaValidateResultClass.ps1
    . $PSScriptRoot\..\src\Public\Get-IgugaChecksum.ps1
    . $PSScriptRoot\..\src\Public\Test-IgugaChecksumFile.ps1
}

Describe 'Test-IgugaChecksumFile' {
    It 'Should throw an error when the file path does not exists' {
        { Test-IgugaChecksumFile -FilePath ".\Data\FileNotFound.txt" } | Should -Throw
    }

    It 'Passe Validattion' {
        $ChecksumFilePath = ".\Data\SHA256SUMS.txt"
        $FilePath1 = (Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx").Replace("\", "/").TrimEnd("/")
        $FilePath2 = (Join-Path -Path $ModuleTestPath -ChildPath "Data\SubDirectory\File2.docx").Replace("\", "/").TrimEnd("/")

        $Expected = @(
            [IgugaValidateResult]::new($FilePath1, "PASS"),
            [IgugaValidateResult]::new($FilePath2, "PASS")
        );

        $Results = Test-IgugaChecksumFile -FilePath $ChecksumFilePath -Algorithm SHA256 -Silent

        for ($i = 0; $i -lt $Results.Length; $i++) {
            $Results[$i].FilePath | Should -Be -ExpectedValue $Expected[$i].FilePath
            $Results[$i].Status | Should -Be -ExpectedValue $Expected[$i].Status
        }
    }
}