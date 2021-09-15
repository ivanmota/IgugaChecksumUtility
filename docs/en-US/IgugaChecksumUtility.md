---
external help file: IgugaChecksumUtility-help.xml
Module Name: IgugaChecksumUtility
online version:
schema: 2.0.0
---

# IgugaChecksumUtility

## SYNOPSIS
Generates and validate checksums for files or directories

## SYNTAX

```
IgugaChecksumUtility [-Mode] <String> [-Path <String>] [-BasePath <String>] [-Algorithm <String>]
 [-Hash <String>] [-Filter <String>] [-Exclude <String[]>] [-Depth <Int32>] [-OutFile] [-OutFilePath <String>]
 [-UseAbsolutePath] [-OutputFilePath <String>] [-Silent] [-SendEmailNotification <String>]
 [-MailerSetting <IgugaMailerSetting>] [-From <IgugaMailAddress>] [-ToList <IgugaMailAddress[]>]
 [-CcList <IgugaMailAddress[]>] [-BccList <IgugaMailAddress[]>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
Generates and validate checksum file hashes for a variety of algorithms

## EXAMPLES

### EXAMPLE 1
```
# Checksum a single file, and output to console
IgugaChecksumUtility -Mode Generate -Path C:\Test\File.docx
```

### EXAMPLE 2
```
# Checksum an entire directory using the SHA512 algorithm and create a checksum file
IgugaChecksumUtility -Mode Generate -Path C:\Test\ -Algorithm SHA512 -OutFile
```

### EXAMPLE 3
```
# Perform a validate operation on a checksum file
IgugaChecksumUtility -Mode Validate -Path C:\Test\SHA512SUMS.txt -Algorithm SHA512
```

### EXAMPLE 4
```
# Perform a validate operation on a checksum file when the paths inside the file being validated is located on a different path and send an email notification (only supported on PS 7 or higher) if there is any failed validation or file not found
# First we need to set the Mailer settings. We just need to do this once. All this info will be stored on the user local computer.
using module IgugaChecksumUtility
$Credential = Get-Credential -Message "Please enter the SMTP Server username and password."
$MailerSetting = [IgugaMailerSetting]::new("smtp.gmail.com", 587, $Credential)
IgugaChecksumUtility -Mode SetMailerSetting -MailerSetting $MailerSetting
# You can see all the Mailer settings and where the data is located if you run the following PS command line
IgugaChecksumUtility -Mode ShowMailerSetting
# If you wich to remove the Mailer setting, then run the follow PS command line
IgugaChecksumUtility -Mode RemoveMailerSetting
# Then, define the sender(From) and the recipents (ToList) and run the validation
$From = [IgugaMailAddress]::new("My Name", "my.name@gmail.com")
$ToList = @([IgugaMailAddress]::new("name1@example.com"), [IgugaMailAddress]::new("name2@example.com"))
IgugaChecksumUtility -Mode Validate -Path "\\server1\checksums\apps\SHA256SUMS.txt" -BasePath "C:\Apps" -Algorithm SHA512 -SendMailNotification NotSuccess -From $From -ToList $ToList
```

### EXAMPLE 5
```
# Perform a compare operation on a file with a known hash
IgugaChecksumUtility -Mode Compare -Path C:\Test\File.docx -Algorithm SHA1 -Hash ED1B042C1B986743C1E34EBB1FAF758549346B24
```

## PARAMETERS

### -Mode
Sets the operation mode.
The allowed modes are: Generate, Validate, Compare, SetMailerSetting, RemoveMailerSetting, ShowMailerSetting

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Sets the path to a given file or directory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BasePath
Used with Validate mode, sets the base path.
This parameter is usefull when the paths inside of the checksum file are
relative and the file being validated is located in a not related path.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Algorithm
Sets the hashing algorithm to be used in the checksum operation.
The allowed algotithms are: MD5, SHA1, SHA256, SHA384 and SHA512

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: SHA256
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hash
Used with Compare mode, sets the specific previously known hash

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Used with Generate mode when the path is a directory, specifies a filter to qualify the Path parameter.
Example: '*.txt'

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Exclude
Used with Generate mode when the path is a directory, specifies an array of one or more string patterns to be matched as the cmdlet gets child items.
Any matching item is excluded from the output.
Enter a path element or pattern, such as *.txt or A*.
Wildcard characters are accepted

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Depth
Used with Generate mode when the path is a directory, allow you to limit the recursion to X levels.
For example, -Depth 2 includes the Path parameter's directory, first level of subdirectories, and second level of subdirectories.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFile
Used with Generate mode, sets whether it will generate a checksum file or not

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutFilePath
Used with Generate mode, sets the path of the generated checksum file.
If this parameter is not provided the default name will be "{Algorithm}SUMS.txt" and will be stored on the Path root directory

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseAbsolutePath
Used with Generate mode, sets whether the checksum file path should be absolute or not

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -OutputFilePath
Sets the file path to export the output.
If the output file path is not provided the output will be printed to the console

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Silent
Omitte the progress status and the output will not be printed on the console

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SendEmailNotification
Used with Validate mode, indicates in which condition a notification email should be sent after the validation process.
Please note that the email notification only support Powershell version 7 or higher.
The allowed values are: None, Always, Success, NotSuccess.
'None' means no notification email will be sent.
'Always' means a notification email will be sent after each validation process.
'Success' means a notification email will be sent only if all file validation passed.
'NotSuccess' means a notification email will be sent if at least one file validation failed or not found.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MailerSetting
Used with SetMailerSetting mode, sets the mailer settings

```yaml
Type: IgugaMailerSetting
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -From
Used with the parameter SendEmailNotification, sets the from email address

```yaml
Type: IgugaMailAddress
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToList
Used with the parameter SendEmailNotification, sets the to list email addresses

```yaml
Type: IgugaMailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CcList
Used with the parameter SendEmailNotification, sets the cc list email addresses

```yaml
Type: IgugaMailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BccList
Used with the parameter SendEmailNotification, sets the bcc list email addresses

```yaml
Type: IgugaMailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
