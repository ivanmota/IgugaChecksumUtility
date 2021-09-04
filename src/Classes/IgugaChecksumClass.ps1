class IgugaChecksum {
    [string] $Hash
    [string] $FilePath
    [string] $Checksum

    IgugaChecksum([string] $FilePath, [string] $Hash, [string] $Checksum) {
        $this.FilePath = $FilePath
        $this.Hash = $Hash
        $this.Checksum = $Checksum
    }
}