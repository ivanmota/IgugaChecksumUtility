# IgugaChecksumUtility

IgugaChecksumUtility is an utility made entirely in Powershell that allow you to generate or validate checksum for files or directories

## Getting started

To install the tool you will need to create a build first.
For creating a build the projects has the following module dependencies:

[psake](https://github.com/psake/psake), the minimal required version `4.9.0`. To install it, run the following code:

```powershell
Install-Module -Name psake
```

[Pester](https://github.com/pester), the minimal required version is `5.3.0`. To install it, run the following code:

```powershell
Install-Module -Name Pester
```

[platyPS](https://github.com/PowerShell/platyPS), the minimal required version is `0.14.2`. To install it, run the following code:

```powershell
Install-Module -Name platyPS
```

[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer), the minimal required version is `1.20.0`. To install it, run the following code:

```powershell
Install-Module -Name PSScriptAnalyzer
```

After install all required dependencies, make a clone of this project `git clone https://github.com/ivanmota/IgugaChecksumUtility.git` or just download it into a folder and run the following code:

```powershell
Invoke-psake build.psake.ps1 -taskList Build
```

The above code will create the directory **Release** were the module build results will be stored.
