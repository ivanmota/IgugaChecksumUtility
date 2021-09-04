class IgugaValidateResult {
    [string] $Hash
    [string] $ExpectedHash
    [ValidateSet("PASS", "FAIL", "NOT_FOUND")] [string] $Status
    [string] $FilePath

    IgugaValidateResult([string] $FilePath, [string] $Status) {
        $this.FilePath = $FilePath
        $this.Status = $Status
    }

    IgugaValidateResult([string] $FilePath, [string] $Status, [string] $ExpectedHash, [string] $Hash) {
        $this.FilePath = $FilePath
        $this.Status = $Status
        $this.ExpectedHash = $ExpectedHash
        $this.Hash = $Hash
    }
}