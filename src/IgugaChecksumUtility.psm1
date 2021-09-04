Import-LocalizedData -BindingVariable "Script:LocalizedData" -FileName IgugaChecksumUtility.Resources.psd1 -ErrorAction SilentlyContinue

# -------------------------- Load Script Files ----------------------------
#
$Classes  = Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Classes\*.ps1') -Recurse
$Public  = Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public\*.ps1') -Recurse

#Excluding the classes, because they will be loaded by the manifest
$ModuleScriptFiles = Get-ChildItem -Path $PSScriptRoot -Filter *.ps1 -Recurse -Exclude $Classes.Name | Where-Object { $_.Name -notlike "*.ps1xml" };

foreach ($ScriptFile in $ModuleScriptFiles) {
    try {
        Write-Verbose -Message "$($Script:LocalizedData.VerboseLoadingScript -f $ScriptFile.FullName)"
        . $ScriptFile.FullName
    }
    catch {
       Write-Error "$($Script:LocalizedData.ErrorLoadingScript -f $ScriptFile.FullName)"
    }
}

Export-ModuleMember -Function $Public.Basename