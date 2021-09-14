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
    EmailNotificationSentWithSuccess=Email notification sent successfully
    ErrorInvalidArgument='{0}' parameter value is not valid
    ErrorInvalidSetting='{0}' setting value is not valid
    ErrorLoadingScript=There was an error loading '{0}': {1}
    ErrorPathNotFound=Cannot find path '{0}' because it does not exist
    ErrorPSVersionFunctionNotSupported=The function '{0}' is not supported by your Powershell version. This operation require at least Powershell version '{1}'
    ErrorSettingsFileNotFound=The settings file '{0}' has not been created yet
    ErrorUtilityParameterRequired=To use '{0}', the '{1}' parameter must be set correctly
    ErrorUtilityParameterRequiredMode=To use '{0}' mode, the '{1}' parameter must be set correctly
    ErrorUtilityPathNotFound='{0}' mode was selected, but path '{1}' does not exists!
    ErrorUtilityPathNotValidFile='{0}' mode was selected, but path '{1}' is not a valid file!
    ErrorUtilitySettingsFileDoesNotExists=To use '{0}', the settings file needs to be created first. To create the settings file please use the mode '{1}'
    ErrorUtilitySettingsFileDoesNotExistsMode='{0}' mode was selected, but the settings file has not been created yet. To create the settings file please use the mode '{1}'
    ErrorUtilityValidateFileNotFound=File does not exist at this path: {0}
    GenerateOpCounterProgressStatus=File {0} of {1}
    GenerateOpProgressCompleted=Generate operation completed!
    GenerateOpProgressMessage=Generating checksum, source: '{0}'
    GenerateOpProgressStatus=Running...
    OpCompleted=Operation Complete!
    PrintChecksumProgressCompleted=Printing the checksums completed!
    PrintChecksumProgressMessage=Printing the checksums
    PrintChecksumProgressStatus=Running...
    RemoveSettingSuccess=[ Removed ] The parameter '{0}' was removed successfully
    ReportSummaryAgent=Agent: {0}
    ReportSummaryAuthor=Author: {0}
    ReportSummaryChecksumAlgorithm=Checksum algorithm: {0}
    ReportSummaryChecksumFilePath=Checksum file path: {0}
    ReportSummaryDescription=Description: {0}
    ReportSummaryEndedAt=Ended at: {0}
    ReportSummaryFilePath=File path: {0}
    ReportSummaryOperationMode=Operation mode: {0}
    ReportSummaryOutputFilePath=Output file path: {0}
    ReportSummaryPath=Path: {0}
    ReportSummaryProjectUrl=Project Url: {0}
    ReportSummaryStartedAt=Started at: {0}
    ReportSummaryTotalFailed=Total failed: {0}
    ReportSummaryTotalFileNotFound=Total files not found: {0}
    ReportSummaryTotalGenerated=Total generated: {0}
    ReportSummaryTotalOfItems=Total of items: {0}
    ReportSummaryTotalPassed=Total passed: {0}
    ReportSummaryVersion=Version: {0}
    ShowMailerSettingEncryption=Encryption: {0}
    ShowMailerSettingFilePath=File path: {0}
    ShowMailerSettingPassword=Password: {0}
    ShowMailerSettingPort=Port: {0}
    ShowMailerSettingSmtpServer=SMTP Server: {0}
    ShowMailerSettingUsername=Username: {0}
    SetSettingSuccess=[ Set ] The parameter '{0}' had set successfully
    ValidateOpProgressCompleted=Validate operation completed!
    ValidateOpProgressMessage=Validating checksum file, source: '{0}'
    ValidateOpProgressStatus=Running {0}
    ValidationEmailNotificationGreetings=Hi there,
    ValidationEmailNotificationInstructions=Please find below the validation result:
    ValidationEmailNotificationMoreInfo=Please find the attached report for more information.
    ValidationEmailNotificationSignature={0}
    ValidationEmailNotificationSubject={0} - validation result
    ValidationEmailNotificationTotalFileNotFound= - Total files not found: {0}
    ValidationEmailNotificationTotalFailed= - Total failed: {0}
    ValidationEmailNotificationTotalItems= - Total of items: {0}
    ValidationEmailNotificationTotalPassed= - Total passed: {0}
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
$Classes = @( Get-ChildItem -Path "$PSScriptRoot\Classes\*.ps1" -ErrorAction SilentlyContinue )
$Public  = @( Get-ChildItem -Path "$PSScriptRoot\Public\*.ps1" -ErrorAction SilentlyContinue )
$Private = @( Get-ChildItem -Path "$PSScriptRoot\Private\*.ps1" -ErrorAction SilentlyContinue )

#Dot source the files
Foreach($Import in @($Classes + $Private + $Public))
{
    Try
    {
        Write-Verbose -Message "$($Script:LocalizedData.VerboseLoadingScript -f $Import.FullName)"
        . $Import.FullName
    }
    Catch
    {
        Write-Error -Message $($Script:LocalizedData.ErrorLoadingScript -f $Import.FullName, $_)
    }
}

Export-ModuleMember -Function $Public.Basename