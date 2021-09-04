function Write-IgugaColorOutput() {
    <#
    .SYNOPSIS
        Print message to the console with specified text color
    .DESCRIPTION
        An alternactive to write-host to print message to the console
    .PARAMETER MessageData
        Specifies an informational message that you want to display to users as they run a script or command.
        For best results, enclose the informational message in quotation marks.
    .PARAMETER ForegroundColor
        Specifies the text color. There is no default
    .EXAMPLE
        PS> Write-IgugaColorOutput -MessageData "Message to display to the console" -ForegroundColor Green
    #>
    [CmdletBinding()]
    param(
        [Parameter(Position = 0)]
        [Object]
        $MessageData,

        [string]
        $ForegroundColor
    )

    # save the current color
    $CurrentColor = $host.UI.RawUI.ForegroundColor;

    if ($PSBoundParameters.ContainsKey("ForegroundColor") -and $ForegroundColor) {
        # set the new color
        $host.UI.RawUI.ForegroundColor = $ForegroundColor
    }

    Write-Output $MessageData

    if ($PSBoundParameters.ContainsKey("ForegroundColor") -and $ForegroundColor) {
        # restore the original color
        $host.UI.RawUI.ForegroundColor = $CurrentColor
    }
}
