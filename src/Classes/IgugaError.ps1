using namespace System.Management.Automation

class IgugaError {
    static [ErrorRecord] PathNotFound([string]$Exception, [string]$Path) {
        $Exp = [System.ArgumentException]::new($Exception -f $Path)
        return [ErrorRecord]::new($Exp, 'PathNotFound', [ErrorCategory]::ObjectNotFound, $Path)
    }

    static [ErrorRecord] InvalidArgument([string]$Exception, [string]$ArgumentName) {
        $Exp = [System.ArgumentException]::new($Exception -f $ArgumentName)
        return [ErrorRecord]::new($Exp, 'InvalidArgument', [ErrorCategory]::InvalidArgument, $ArgumentName)
    }

    static [ErrorRecord] InvalidSetting([string]$Exception, [string]$ArgumentName) {
        $Exp = [System.ArgumentException]::new($Exception -f $ArgumentName)
        return [ErrorRecord]::new($Exp, 'InvalidSetting', [ErrorCategory]::InvalidArgument, $ArgumentName)
    }

    static [ErrorRecord] PSVersionFunctionNotSupported([string]$Exception, [string]$Operation, [string]$Version) {
        $Exp = [System.ArgumentException]::new($($Exception -f $Operation, $Version))
        return [ErrorRecord]::new($Exp, 'PSVersionFunctionNotSupported', [ErrorCategory]::InvalidOperation, $Operation)
    }
}
