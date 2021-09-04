# IgugaChecksumUtility

IgugaChecksumUtility is an utility made entirely in Powershell that allow you to generate or validate checksum for files or directories

## Getting started

To install the tool you will need to create a build first.
For creating a build the projects has the following module dependencies:

[psake](https://github.com/psake/psake)

Minimal required version: 4.9.0

How to install:

```powershell
Install-Module -Name psake
```

[Pester](https://github.com/pester)

Minimal required version: 5.3.0

How to install:

```powershell
Install-Module -Name Pester
```

[platyPS](https://github.com/PowerShell/platyPS)

Minimal required version: 0.14.2

How to install:

```powershell
Install-Module -Name platyPS
```

[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer)

Minimal required version: 1.20.0

How to install:

```powershell
powershell Install-Module -Name PSScriptAnalyzer
```

After install all required dependencies, make a clone of this project `git clone https://github.com/ivanmota/IgugaChecksumUtility.git` or just download it into a folder and run the following code:

```powershell
Invoke-psake build.psake.ps1 -taskList Build
```

The above code will create the directory **Release** were module build results will stored.