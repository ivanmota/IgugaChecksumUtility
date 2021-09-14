function Write-IgugaReportContent() {
    param(
        # Text - the text to print or record
        [Parameter(Position = 0, Mandatory = $true)]
        [string]
        $Text,

        # ForegroundColor - the color to use on the print out operation
        [Parameter(Position = 1, Mandatory = $true)]
        [string]
        $ForegroundColor,

        # OutputFilePath - the file path to export the output. If the output file path is not provided the output will be printed to the console
        [Parameter(Position = 2, Mandatory = $true)]
        [AllowEmptyString()]
        [string]
        $OutputFilePath,

        # Silent - prevent the output to be printed on the screen
        [switch]
        $Silent
    )

    if (-not([string]::IsNullOrWhiteSpace($OutputFilePath))) {
        Add-Content -LiteralPath $OutputFilePath -Value $Text
    }

    if (-not($Silent.IsPresent)) {
        Write-IgugaColorOutput $Text -ForegroundColor $ForegroundColor
    }
}