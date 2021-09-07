using namespace System.Management.Automation

class IgugaError {
    static [ErrorRecord] PathNotFound([String]$Exception,[string]$Path) {
        $Exp = [System.ArgumentException]::new($Exception -f $Path)
        return [ErrorRecord]::new($Exp, 'PathNotFound', [ErrorCategory]::ObjectNotFound, $Path)
    }

    static [ErrorRecord] InvalidArgument([String]$Exception,[string]$ArgumentName) {
        $Exp = [System.ArgumentException]::new($Exception -f $ArgumentName)
        return [ErrorRecord]::new($Exp, 'InvalidArgument', [ErrorCategory]::InvalidArgument, $ArgumentName)
    }
}
