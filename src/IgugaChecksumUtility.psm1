$Script:LocalizedData = DATA {
    # Localized data for en-US
    ConvertFrom-StringData @'
    ###PSLOC
    CompareOpProgressCompleted=Compare operation completed!
    CompareOpProgressMessage=Comparing file hash, source: {0}
    CompareOpProgressStatus=Running...
    DiscoveringFilesProgressCompleted=Discovering files completed!
    DiscoveringFilesProgressMessage=Discovering files, from '{0}'
    DiscoveringFilesProgressStatus=Running...
    ErrorInvalidArgument={0} parameter value is not valid
    ErrorLoadingScript=There was an error loading '{0}'.
    ErrorPathNotFound=Cannot find path '{0}' because it does not exist.
    ErrorUtilityParameterRequired=To use {0} mode, the {1} parameter must be set correctly
    ErrorUtilityPathNotFound={0} mode was selected, but path '{1}' does not exists!
    ErrorUtilityPathNotValidFile={0} mode was selected, but path '{1}' is not a valid file!
    ErrorUtilityValidateFileNotFound=File does not exist at this path: {0}
    GenerateOpCounterProgressStatus=File {0} of {1}
    GenerateOpProgressCompleted=Generate operation completed!
    GenerateOpProgressMessage=Generating checksum, source: '{0}'
    GenerateOpProgressStatus=Running...
    OpCompleted=Operation Complete!
    PrintChecksumProgressCompleted=Printing the checksums completed!
    PrintChecksumProgressMessage=Printing the checksums
    PrintChecksumProgressStatus=Running...
    ValidateOpProgressCompleted=Validate operation completed!
    ValidateOpProgressMessage=Validating checksum file, source: '{0}'
    ValidateOpProgressStatus=Running {0}
    ValidationFailed=[ Fail ] {0} (Hash: {1}, Expected: {2})
    ValidationPassed=[ Pass ] {0}
    VerboseLoadingScript=Loading script file '{0}'.
    VerboseMoreInfo=For more information use the -Verbose flag
    ###PSLOC
'@
}

Import-LocalizedData -BindingVariable "Script:LocalizedData" -FileName IgugaChecksumUtility.Resources.psd1 -ErrorAction SilentlyContinue

# -------------------------- Load Script Files ----------------------------
#
$Public  = Get-ChildItem -Path (Join-Path -Path $PSScriptRoot -ChildPath 'Public\*.ps1') -Recurse

#Excluding the classes, because they will be loaded by the manifest
$ModuleScriptFiles = Get-ChildItem -Path $PSScriptRoot -Filter *.ps1 | Where-Object { $_.Name -notlike "*.ps1xml" };

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