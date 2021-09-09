BeforeAll {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
    $SuppressImportModule = $true

    . $PSScriptRoot\Shared.ps1
    . $PSScriptRoot\..\src\Classes\IgugaError.ps1
    . $PSScriptRoot\..\src\Private\Get-IgugaCanonicalPath.ps1
}


Describe 'Get-IgugaCanonicalPath' {
    It 'Should throw an error when the path does not exists' {
        $FilePath = Join-Path -Path $ModuleTestPath -ChildPath "Data\This-File-Does-Not-Exists.txt"
        { Get-IgugaCanonicalPath -Path $FilePath } | Should -Throw
    }

    It 'Pass when file exists' {
        $FilePath = Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx"
        $Expected = $FilePath.Replace("\", "/")
        Get-IgugaCanonicalPath -Path $FilePath | Should -Be $Expected
    }

    It 'Pass using NonExistentPath Windows' {
        $FilePath = Join-Path -Path $ModuleTestPath -ChildPath "Data\This-File-Does-Not-Exists.txt"
        $Expected = $FilePath.Replace("\", "/");
        Get-IgugaCanonicalPath -Path $FilePath -NonExistentPath | Should -Be $Expected
    }

    It 'Pass using NonExistentPath Linux' {
        $FilePath = "/Test/This-File-Does-Not-Exists.txt";
        Get-IgugaCanonicalPath -Path $FilePath -NonExistentPath | Should -Be $FilePath
    }

    # It 'Should throw an error when you only pass the unc path hostname' {
    #     $Path = "\\server1";
    #     { Get-IgugaCanonicalPath -Path $Path } | Should -Throw
    # }

    # It 'Should process UNC Path' {
    #     $Path = "\\server1\checksums\";
    #     $ExpectedPath = "//server1/checksums"
    #     Get-IgugaCanonicalPath -Path $Path | Should -Be $ExpectedPath
    # }

    It 'Pass case sensitive' {
        $FilePath = Join-Path -Path $ModuleTestPath -ChildPath "Data\file.docx"
        $Expected = $FilePath.Replace("\", "/")
        if ($PSVersionTable.PSVersion.Major -le 5) {
            Get-IgugaCanonicalPath -Path $FilePath | Should -Not -BeExactly $Expected
        } elseif ($IsWindows) {
            Get-IgugaCanonicalPath -Path $FilePath | Should -Not -BeExactly $Expected
        } elseif ($IsLinux) {
            { Get-IgugaCanonicalPath -Path $FilePath } | Should -Throw
        }
    }
}