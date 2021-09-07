---
external help file: IgugaChecksumUtility-help.xml
Module Name: IgugaChecksumUtility
online version:
schema: 2.0.0
---

# Compare-IgugaFileHash

## SYNOPSIS
Compare a file with a known hash

## SYNTAX

```
Compare-IgugaFileHash [-FilePath] <String> [-Algorithm <String>] [-Hash <String>] [-Silent]
 [<CommonParameters>]
```

## DESCRIPTION
Perform a compare operation on a file with a known hash

## EXAMPLES

### EXAMPLE 1
```
# Perform a compare operation on a file with a known hash
Compare-IgugaFileHash -Path "C:\Test\SHA512SUMS.txt" -Algorithm SHA512
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

### -Hash
Sets the specific previously known hash

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

### IgugaValidateResult
## NOTES

## RELATED LINKS
