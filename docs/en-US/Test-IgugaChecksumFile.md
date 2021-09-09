---
external help file: IgugaChecksumUtility-help.xml
Module Name: IgugaChecksumUtility
online version:
schema: 2.0.0
---

# Test-IgugaChecksumFile

## SYNOPSIS
Validate checksum file

## SYNTAX

```
Test-IgugaChecksumFile [-FilePath] <String> [-BasePath <String>] [-Algorithm <String>] [-Silent]
 [<CommonParameters>]
```

## DESCRIPTION
Validate a give checksum file

## EXAMPLES

### EXAMPLE 1
```
# Perform a validate operation on a checksum file
Test-IgugaChecksumFile -Path C:\Test\SHA512SUMS.txt -Algorithm SHA512
```

## PARAMETERS

### -FilePath
Sets the path to a given checksum file

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
Sets the hashing algorithm to be used in the checksum validation.
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

### -Silent
Omitte the progress status

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### IgugaValidateResult[]
## NOTES

## RELATED LINKS
