BeforeAll {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
    $SuppressImportModule = $true

    . $PSScriptRoot\Shared.ps1
    . $PSScriptRoot\..\src\Private\Get-IgugaRelativePath.ps1
}

Describe 'Get-IgugaRelativePath' {
    It 'Passe pass with absolute path' {
        Get-IgugaRelativePath -RelativeTo "C:\Test\"  -Path "C:\Test\File.docx"  | Should -Be "./File.docx"
    }

    It 'Passe with relative path' {
        Get-IgugaRelativePath -RelativeTo ".\Test\"  -Path ".\Test\File.docx"  | Should -Be "./File.docx"
    }
}