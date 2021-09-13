---
external help file: IgugaChecksumUtility-help.xml
Module Name: IgugaChecksumUtility
online version:
schema: 2.0.0
---

# Send-IgugaMailMessage

## SYNOPSIS
Send an email using MailKit

## SYNTAX

```
Send-IgugaMailMessage [-MailerSetting] <IgugaMailerSetting> [-From] <IgugaMailAddress>
 [-ToList] <IgugaMailAddress[]> [[-CcList] <IgugaMailAddress[]>] [[-BccList] <IgugaMailAddress[]>]
 [[-Subject] <String>] [[-TextBody] <String>] [[-HTMLBody] <String>] [[-AttachmentList] <String[]>]
 [<CommonParameters>]
```

## DESCRIPTION
Send an email using the implementing the Microsoft-recommended MailKit library

## EXAMPLES

### EXAMPLE 1
```
# How to send a simple email
$Credential = [PSCredential]::new("example@gmail.com", (ConvertTo-SecureString -String 'password-example' -AsPlainText -Force))
$MailerSetting = [IgugaMailerSetting]::new("smtp.gmail.com", 587, $Credential)
$From = [IgugaMailAddress]::new("My Name", "example@gmail.com")
$ToList = @([IgugaMailAddress]::new("name@example.com"))
Send-IgugaMailMessage -MailerSetting $MailerSetting -From $From -ToList $ToList -Subject "Email Subject" -TextBody "Email Body"
```

## PARAMETERS

### -MailerSetting
Sets the SMTP server host name to connect to.

```yaml
Type: IgugaMailerSetting
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -From
Sets the addreess in the From header.

```yaml
Type: IgugaMailAddress
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ToList
Sets the list of addresses in the To header.

```yaml
Type: IgugaMailAddress[]
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CcList
Sets the list of addresses in the Cc header.

```yaml
Type: IgugaMailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BccList
Sets the list of addresses in the Bcc header.

```yaml
Type: IgugaMailAddress[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Subject
Sets the subject of the message.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TextBody
Sets the text body if it exists; otherwise, $null.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HTMLBody
Sets the html body if it exists; otherwise, null.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AttachmentList
Sets the attachements file path list

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
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
