# Dot source this script in any Pester test script that requires the module to be imported.

$ModuleManifestName = 'IgugaChecksumUtility.psd1'
$ModuleManifestPath = "$PSScriptRoot\..\src\$ModuleManifestName"
$ModuleTestPath = Resolve-Path "$PSScriptRoot\..\test"

if (!$SuppressImportModule) {
    # -Scope Global is needed when running tests from inside of psake, otherwise
    # the module's functions cannot be found in the IgugaChecksumUtility\ namespace
    Import-Module $ModuleManifestPath -Scope Global
}

