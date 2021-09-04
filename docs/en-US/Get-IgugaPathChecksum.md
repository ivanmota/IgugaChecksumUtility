---
external help file: IgugaChecksumUtility-help.xml
Module Name: IgugaChecksumUtility
online version:
schema: 2.0.0
---

# Get-IgugaPathChecksum

## SYNOPSIS
Get the checksums for files or directories

## SYNTAX

```
Get-IgugaPathChecksum [-Path] <String> [-Algorithm <String>] [-Filter <String>] [-Exclude <String[]>]
 [-Depth <Int32>] [-UseAbsolutePath] [-Silent] [<CommonParameters>]
```

## DESCRIPTION
Get the checksums hashes for a variety of algorithms for the purposes of file validation

## EXAMPLES

### EXAMPLE 1
```
# Get the checksum info for a single file
Get-IgugaPathChecksum -Path "C:\Test\File.docx"
```

### EXAMPLE 2
```
# Get the checksums of an entire directory using the SHA512 algorithm
Get-IgugaPathChecksum -Path "C:\Test\" -Algorithm SHA512
```

## PARAMETERS

### -Path
Sets the path to a given file or directory

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

### -Filter
When the path is a directory, specifies a filter to qualify the Path parameter.
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
When the path is a directory, specifies an array of one or more string patterns to be matched as the cmdlet gets child items.
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
When the path is a directory, allow you to limit the recursion to X levels.
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

### -UseAbsolutePath
Sets whether the checksum file path should be absolute or not

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

### IgugaChecksum[]
## NOTES

## RELATED LINKS
