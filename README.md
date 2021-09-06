# IgugaChecksumUtility

IgugaChecksumUtility is an utility made entirely in Powershell that allow you to generate or validate checksum for files or directories

## Getting started

To install the tool you will need to create a build first.
For creating a build the projects has the following module dependencies:

[psake](https://github.com/psake/psake), the minimal required version `4.9.0`. To install it, run the following powershell command:

```powershell
Install-Module -Name psake
```

[Pester](https://github.com/pester), the minimal required version is `5.3.0`. To install it, run the following powershell command:

```powershell
Install-Module -Name Pester
```

[platyPS](https://github.com/PowerShell/platyPS), the minimal required version is `0.14.2`. To install it, run the following powershell command:

```powershell
Install-Module -Name platyPS
```

[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer), the minimal required version is `1.20.0`. To install it, run the following powershell command:

```powershell
Install-Module -Name PSScriptAnalyzer
```

After install all required dependencies, make a clone of this project `git clone https://github.com/ivanmota/IgugaChecksumUtility.git` or just download it into a folder and run the following powershell command:

```powershell
Invoke-psake build.psake.ps1 -taskList Build
```

The above code will create the directory **Release** were the module build results will be stored.

## Install Manually Instructions

Run the following powershell command to discover where the Powershell Modules are installed

```powershell
$Env:PSModulePath.Split([System.IO.Path]::PathSeparator)
```

Usually the first line of the above output is where you can put Modules just for the current user, the others are for all users. The paths dependend on which version of Powershell and the plataform (Windows, Mac, Linux) you are using.

Imagine that I'm using Powershell 5.1 on Windows 10 and I want to install this module just for my current user (which is "ivan2562", just as example). So the first line of the output of the code above could be something like:

`C:\Users\ivan2562\Documents\WindowsPowerShell\Modules`

So then I will need to create the folder `IgugaChecksumUtility` inside of the above path, so my result will be something like:

`C:\Users\ivan2562\Documents\WindowsPowerShell\Modules\IgugaChecksumUtility`

And after that I will need to create a folder with the same name as the version of the tool, in this example `1.0.0`, so my result will be something like:

`C:\Users\ivan2562\Documents\WindowsPowerShell\Modules\IgugaChecksumUtility\1.0.0`

Then I will need to copy all the content of the `Release` folder (folder generated when we build the tool) to the above folder.

And finally we will need to run the folling powershell commands to import the module:

```powershell
Import-Module IgugaChecksumUtility
```

## Install using the project Instructions

To install the tool using the project you will need to run the following powershell commands:

```powershell
Import-Module ./src/IgugaChecksumUtility.psd1
Invoke-psake build.psake.ps1 -taskList Install
Import-Module IgugaChecksumUtility
```

The above commands will create the build, than create the module name and the current version folder on the current Powershell Modules directory of the current user and than copy all the `Release` content to it and following with the import module procedure.
