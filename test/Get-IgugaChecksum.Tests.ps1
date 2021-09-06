BeforeAll {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
    $SuppressImportModule = $true

    . $PSScriptRoot\Shared.ps1
    . $PSScriptRoot\..\src\Classes\IgugaChecksumClass.ps1
    . $PSScriptRoot\..\src\Public\Get-IgugaChecksum.ps1
}

Describe 'Get-IgugaChecksum' {
    It 'Should throw an error when the path does not exists' {
        { Get-IgugaChecksum -FilePath $(Join-Path -Path $ModuleTestPath -ChildPath "Data\FileNotFound.txt") } | Should -Throw
    }

    It 'Passe default algorithm (SHA256)' {
        $hash = "D0B79192B857365CCE727E6CE415ACCB2F19CADECD549EC72ECD3627F5B7F8F3"
        $FilePath = $(Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx")
        $expected = "$hash  $($FilePath.Replace("\", "/"))"
        (Get-IgugaChecksum -FilePath $FilePath).Checksum | Should -BeExactly $expected
    }

    It 'Passe default algorithm with relative file path' {
        $hash = "D0B79192B857365CCE727E6CE415ACCB2F19CADECD549EC72ECD3627F5B7F8F3"
        $FilePath = $(Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx")
        $expected = "$hash  $($FilePath.Replace("\", "/"))"
        (Get-IgugaChecksum -FilePath "./Data/File.docx").Checksum | Should -BeExactly $expected
    }

    It 'Passe default algorithm with alternactive file path' {
        $hash = "D0B79192B857365CCE727E6CE415ACCB2F19CADECD549EC72ECD3627F5B7F8F3"
        $FilePath = $(Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx")
        $expected = "$hash  ./Data/File.docx"
        (Get-IgugaChecksum -FilePath $FilePath -AlternactiveFilePath ".\Data\File.docx").Checksum | Should -BeExactly $expected
    }

    It 'Passe with algorithm MD5' {
        $Hash = "C292CAFA6276D42C5C667AFDAE74A63E"
        $FilePath = $(Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx")
        $Expected = "$Hash  ./Data/File.docx"
        (Get-IgugaChecksum -FilePath $FilePath -Algorithm MD5 -AlternactiveFilePath ".\Data\File.docx").Checksum | Should -BeExactly $Expected
    }

    It 'Passe with algorithm SHA1' {
        $Hash = "BEA1B1DB015021C73D34F9D70DEBF2FB2AB0141C"
        $FilePath = $(Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx")
        $Expected = "$Hash  ./Data/File.docx"
        (Get-IgugaChecksum -FilePath $FilePath -Algorithm SHA1 -AlternactiveFilePath ".\Data\File.docx").Checksum | Should -BeExactly $Expected
    }

    It 'Passe with algorithm SHA512' {
        $Hash = "342368400ABBA022914A52F3416DCDCAD6CDAFA1B2045FDD8CC92E8040595E4306851DD966C497815330FA970C586BB125E4D4AE2FCDB1F2BC839E75BA402967"
        $FilePath = $(Join-Path -Path $ModuleTestPath -ChildPath "Data\File.docx")
        $Expected = "$Hash  ./Data/File.docx"
        (Get-IgugaChecksum -FilePath $FilePath -Algorithm SHA512 -AlternactiveFilePath ".\Data\File.docx").Checksum | Should -BeExactly $Expected
    }
}