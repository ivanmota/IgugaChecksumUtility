---
external help file: IgugaChecksumUtility-help.xml
Module Name: IgugaChecksumUtility
online version:
schema: 2.0.0
---

# Get-IgugaChecksum

## SYNOPSIS
Get the checksum info from a given file

## SYNTAX

```
Get-IgugaChecksum [-FilePath] <String> [-Algorithm <String>] [-AlternactiveFilePath <String>]
 [<CommonParameters>]
```

## DESCRIPTION
Calculate the hash of specific file and return the checksum info

## EXAMPLES

### EXAMPLE 1
```
Get-IgugaChecksum -FilePath "C:\Test\File.txt" -Algorithm MD5
```

### EXAMPLE 2
```
# using an alternactive file path
PS> Get-IgugaChecksum -FilePath "C:\Test\File.txt" -Algorithm MD5 -AlternactiveFilePath ".\File.txt"
```

## PARAMETERS

### -FilePath
Sets the path to a given file

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

### -Algorithm
Sets the hashing algorithm to be used.
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

### -AlternactiveFilePath
Sets the alternactive path to use on the checksum file path

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### IgugaChecksum
## NOTES

## RELATED LINKS
