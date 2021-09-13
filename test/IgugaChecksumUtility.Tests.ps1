BeforeAll {
    [System.Diagnostics.CodeAnalysis.SuppressMessage('PSUseDeclaredVarsMoreThanAssigments', '', Scope='*', Target='SuppressImportModule')]
    $SuppressImportModule = $true

    . $PSScriptRoot\Shared.ps1

    $Script:Manifest = $null
}

# test the module manifest - exports the right functions, processes the right formats, and is generally correct
Describe "Manifest" {
    It "Should be a valid Manifest" {
        { $Script:Manifest = Test-ModuleManifest -Path $ModuleManifestPath } | Should -Not -Throw
    }

    It "Sould contains Name" {
        $Script:Manifest.Name | Should -Be $ModuleName
    }

    It "Should contains Author"{
        $Script:Manifest.Author | Should -Not -BeNullOrEmpty
    }

	It "has a valid root module" {
        $Script:Manifest.RootModule | Should -Be "$ModuleName.psm1"
    }

	It "Should contains Description" {
        $Script:Manifest.Description | Should -Not -BeNullOrEmpty
    }

    It "Sould contains a valid Guid" {
        $Script:Manifest.Guid | Should -Be '5ab60a17-55ca-4df4-b409-d656a605c26e'
    }

	It "Should contains License" {
		$Script:Manifest.LicenseUri | Should -Not -BeNullOrEmpty
	}

    It "Should contains Copyright" {
		$Script:Manifest.CopyRight | Should -Not -BeNullOrEmpty
	}

	It "Should contains PowerShellVersion" {
		$Script:Manifest.PowerShellVersion | Should -Not -BeNullOrEmpty
	}

    It "Should contains CompatiblePSEditions" {
		$Script:Manifest.CompatiblePSEditions | Should -Not -BeNullOrEmpty
	}

    It "Should contains a Project Link" {
		$Script:Manifest.ProjectURI  | Should -Not -BeNullOrEmpty
	}

    It "Should contains a Tags (For the PSGallery)"{
        $Script:Manifest.Tags.count | Should -BeGreaterThan 0 -Because "the publish task will fail if there is no tags"
    }

	It 'exports all public functions' {
        $FunctionFiles = Get-ChildItem "$ModuleSrcPath\Public" -Filter *.ps1 | Select-Object -ExpandProperty BaseName
        $DefaultCommandPrefix = if ($Script:Manifest.DefaultCommandPrefix -eq $null) {
            ""
        } else {
            $Script:Manifest.DefaultCommandPrefix
        }

        $ExFunctions = $Script:Manifest.ExportedFunctions.Values.Name
        $FunctionNames = $FunctionFiles | ForEach-Object {$_ -replace '-', "-$DefaultCommandPrefix"}
		foreach ($FunctionName in $FunctionNames)
		{
			$ExFunctions -contains $FunctionName | Should -Be $true -Because "function named '$FunctionName' is missing"
		}
	}

    It 'exports all public classes' {
        $ClassesFiles = Get-ChildItem "$ModuleSrcPath\Classes" -Filter *.ps1 | Select-Object -ExpandProperty BaseName
        $ScriptsToProcess = $Script:Manifest.Scripts | ForEach-Object { (Get-Item $_).BaseName }
		foreach ($ClassName in $ClassesFiles)
		{
            $ScriptsToProcess -contains $ClassName | Should -Be $true -Because "class named '$ClassName' is missing"
		}
	}
}