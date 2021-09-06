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

        [System.ConsoleColor]
        $ForegroundColor
    )

    if ($PSBoundParameters.ContainsKey("ForegroundColor") -and $ForegroundColor) {
        if (($null -ne $Host.UI) -and ($null -ne $Host.UI.RawUI) -and ($null -ne $Host.UI.RawUI.ForegroundColor)) {
            $PreviousColor = $Host.UI.RawUI.ForegroundColor
            $Host.UI.RawUI.ForegroundColor = $ForegroundColor
        }
    }

    $MessageData

    if ($null -ne $PreviousColor) {
        $Host.UI.RawUI.ForegroundColor = $PreviousColor
    }
}
