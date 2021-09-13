class IgugaMailAddress {
    [string] $Name
    [ValidatePattern('^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$')] [string] $Address

    IgugaMailAddress([string] $Address) {
        $this.Name = $Address
        $this.Address = $Address
    }

    IgugaMailAddress([string] $Name, [string] $Address) {
        $this.Name = $Name
        $this.Address = $Address
    }
}