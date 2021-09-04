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
IgugaChecksumUtility [-Mode] <String> [-Path] <String> [-Algorithm <String>] [-Hash <String>]
 [-Filter <String>] [-Exclude <String[]>] [-Depth <Int32>] [-OutFile] [-OutFilePath <String>]
 [-UseAbsolutePath] [-OutputFilePath <String>] [-Silent] [<CommonParameters>]
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
# Perform a compare operation on a file with a known hash
IgugaChecksumUtility -Mode Compare -Path C:\Test\File.docx -Algorithm SHA1 -Hash ED1B042C1B986743C1E34EBB1FAF758549346B24
```

## PARAMETERS

### -Mode
Sets the operation mode

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

Required: True
Position: 2
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
Use with Compare mode, sets the specific previously known hash

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
Use with Generate mode when the path is a directory, specifies a filter to qualify the Path parameter.
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
Use with Generate mode when the path is a directory, specifies an array of one or more string patterns to be matched as the cmdlet gets child items.
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
Use with Generate mode when the path is a directory, allow you to limit the recursion to X levels.
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
Use with Generate mode, sets whether it will generate a checksum file or not

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
Use with Generate mode, sets the path of the generated checksum file.
If this parameter is not provided the default name will be "{Algorithm}SUMS.txt" and will be stored on the Path directory

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
Use with Generate mode, sets whether the checksum file path should be absolute or not

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
