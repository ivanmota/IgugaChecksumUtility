class IgugaMailerSetting {
    [ValidatePattern('(^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$)|(^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$)')] [string] $SMTPServer
    [int] $Port
    [pscredential] $Credential
    [ValidateSet("None", "Auto", "SslOnConnect", "StartTls", "StartTlsWhenAvailable")] [string] $Encryption = "Auto"

    IgugaMailerSetting() {

    }

    IgugaMailerSetting([string] $SMTPServer, [int] $Port) {
        $this.SMTPServer = $SMTPServer
        $this.Port = $Port
    }

    IgugaMailerSetting([string] $SMTPServer, [int] $Port, [pscredential] $Credential) {
        $this.SMTPServer = $SMTPServer
        $this.Port = $Port
        $this.Credential = $Credential
    }
}