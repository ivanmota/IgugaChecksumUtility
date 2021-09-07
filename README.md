# IgugaChecksumUtility

IgugaChecksumUtility is an utility made entirely in Powershell that allow you to generate or validate checksum for files or directories

## How to install this module via Powershell Gallery

Install for all users (require admin permission)

```powershell
Install-Module -Name IgugaChecksumUtility -Scope AllUsers -SkipPublisherCheck
```

Install for current user

```powershell
Install-Module -Name IgugaChecksumUtility -Scope CurrentUser -SkipPublisherCheck
```

## Examples

```powershell
# Create the checksum for a single file, and output to console
IgugaChecksumUtility -Mode Generate -Path "C:\Test\File.docx"
```

```powershell
# Create a checksum for an entire directory using the SHA512 algorithm and export the checksum (SHA512SUMS.txt) to the root of the directory
IgugaChecksumUtility -Mode Generate -Path "C:\Test\" -Algorithm SHA512 -OutFile
```

```powershell
# Create a checksum for an entire directory using the SHA512 algorithm and export the checksum (SHA512SUMS.txt) to a specific path
IgugaChecksumUtility -Mode Generate -Path "C:\Test\" -Algorithm SHA512 -OutFile -OutFilePath "C:\Checksums\SHA512SUMS.txt"
```

```powershell
# Perform a validate operation on a checksum file
IgugaChecksumUtility -Mode Validate -Path "C:\Test\SHA512SUMS.txt" -Algorithm SHA512
```

```powershell
# Perform a compare operation on a file with a known hash
IgugaChecksumUtility -Mode Compare -Path "C:\Test\File.docx" -Algorithm SHA1 -Hash ED1B042C1B986743C1E34EBB1FAF758549346B24
```

Please find below others function that this module export:

1. Compare-IgugaFileHash
2. Get-IgugaChecksum
3. Get-IgugaPathChecksum
4. Test-IgugaChecksumFile

Find more info about those functions on the [docs](https://github.com/ivanmota/IgugaChecksumUtility/tree/master/docs) folder


## How to get started with this project

This project was created with a [Plaster](https://github.com/PowerShellOrg/Plaster) template and has the following dependencies:

[psake](https://github.com/psake/psake), the minimal required version `4.9.0`. To install it, run the following powershell command:

```powershell
Install-Module -Name psake -Scope CurrentUser
```

[Pester](https://github.com/pester), the minimal required version is `5.3.0`. To install it, run the following powershell command:

```powershell
Install-Module -Name Pester -Scope CurrentUser -Force -SkipPublisherCheck
```

[platyPS](https://github.com/PowerShell/platyPS), the minimal required version is `0.14.2`. To install it, run the following powershell command:

```powershell
Install-Module -Name platyPS -Scope CurrentUser
```

[PSScriptAnalyzer](https://github.com/PowerShell/PSScriptAnalyzer), the minimal required version is `1.20.0`. To install it, run the following powershell command:

```powershell
Install-Module -Name PSScriptAnalyzer -Scope CurrentUser
```

> On Windows by default only digitally signed Module are allowed to run.
Because `psake` is not digitally signed you will not be allowed to run it.
Only for DEV enviroment, we suggest you to enable Execution Policy Unrestricted for the current user. Run the following Powershell command to enable it:

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

After install all required dependencies, make a clone of this project `git clone https://github.com/ivanmota/IgugaChecksumUtility.git` or just download it into a folder and run the following powershell command:

```powershell
Invoke-psake build.psake.ps1 -taskList Build
```

The above code will create the directory **Release** where the module build results will be stored.

## How to manually install this module

Run the following powershell command to discover where the Powershell Modules are installed

```powershell
$Env:PSModulePath.Split([System.IO.Path]::PathSeparator)
```

Usually the first line of the above output is where you can put Modules just for the current user, the others are for all users. The paths dependend on which version of Powershell and the plataform (Windows, Mac, Linux) you are using.

Imagine that I'm using Powershell 5.1 on Windows 10 and I want to install this module just for my current user (which is "ivan2562", just as example). So the first line of the output of the code above could be something like:

`C:\Users\ivan2562\Documents\WindowsPowerShell\Modules`

So then I will need to create the folder `IgugaChecksumUtility` inside of the above path, so my result will be something like:

`C:\Users\ivan2562\Documents\WindowsPowerShell\Modules\IgugaChecksumUtility`

And after that I will need to create a folder with the same name as the version of the module, in this example `1.0.0`, so my result will be something like:

`C:\Users\ivan2562\Documents\WindowsPowerShell\Modules\IgugaChecksumUtility\1.0.0`

Then I will need to copy all the content of the `Release` folder (folder generated when we build the module) to the above folder.

And finally we will need to run the folling powershell commands to import the module:

```powershell
Import-Module IgugaChecksumUtility
```

## How to install this module via the project task

To install the tool using the project you will need to run the following powershell commands:

```powershell
Import-Module ./src/IgugaChecksumUtility.psd1
Invoke-psake build.psake.ps1 -taskList Install
Import-Module IgugaChecksumUtility
```

The above commands will create the build, than create the module name and the current version folder on the current Powershell Modules directory of the current user and than copy all the `Release` content to it and following with the import module procedure.

## Execution Policy issues on Windows

If when you ran the Import-Module procedure you get some kind of error saying that you can't load the class bla bla bla, because is not digitaly signed, don't worry it is the default behavior of Powershell on Windows. By default all script or module that are not signed on Powershell Windows will be not allowed to run.

You have to way to workaround this issue:

### Solution 1

Remove the restriction (which is not recommended), running the following code:

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

The above code will ask your confirmation whether you want to remove the restriction for the current user or not. You should responde "Y" (yes)

For more information, check the [Execution Policy Page](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-5.1)

### Solution 2

Digitally sign the Module using a self-assigned Certificate.
Please find bellow all the steps that you will need to digitally sign the module on Windows 10:

#### Step 1

Lets create a self-sign certificate, using powershell. We will create a certificate with the DnsName `powershell.igugachecksumutility.local` and with 10 years of expiration date for the current user. Run the following powershell command:

```powershell
New-SelfSignedCertificate -DnsName powershell.igugachecksumutility.local -CertStoreLocation Cert:\CurrentUser\My\ -Type Codesigning -NotAfter (Get-Date).AddYears(10)
```

You can find your certificate in your certificate store (Personal -> Certificates), more in next setp.

#### Step 2

Export the just created certificate to a folder. Run the command to open the `Manage Computer Certificates` tool.

```powershell
certmgr.msc
```

Then on the folder tree `Personal->Certificates` find the certificate issued to `powershell.igugachecksumutility.local`. With the mouse right click, click on the `All Tasks -> Export...` menu, then:

1. Click `Next`
2. Select `No, do not export the private key` and then click `Next`
3. Select `DER encoded binary X.509 (.CER)` and then click `Next`
4. Choose where to save the file with the name `powershell.igugachecksumutility.local` on your computer and then click `Next`
5. Finally click `Finish`

#### Step 3

Import the certificate in Trusted Root Certification Autorities and Trusted Publisher

With the `Manage Computer Certificates` tool still opened, with the mouse right click on the left side bar folder tree `Trusted Root Certification Authorities->Certificates`, click on the menu `All Tasks -> Import...` and then:

1. Click `Next`
2. Select the certificate exported on the previous step and then click `Next`
3. Select `Place all certificates in the following store`, and be sure that the value of the `Certificate store:` is `Trusted Root Certification Autorities` and then click `Next`
4. Finally click `Finish` and accept the Security Warning by click on the button `Yes`

With the `Manage Computer Certificates` tool still opened, with the mouse right click on the left side bar folder tree `Trusted Publisher->Certificates`, click on the menu `All Tasks -> Import...` and then:

1. Click `Next`
2. Select the certificate exported on the previous step and then click `Next`
3. Select `Place all certificates in the following store`, and be sure that the value of the `Certificate store:` is `Trusted Publishers` and then click `Next`
4. Finally click `Finish`

#### Step 4

On the module project, edit the file `build.settings.ps1`:

1. Sets the variable `$ScriptSigningEnabled` value to `$true`
2. Sets the variable `$CertSubjectName` value to `"powershell.igugachecksumutility.local"`
3. Sets the variable `$CertPath` value to `"Cert:\CurrentUser\My"`
4. Finally save the file

#### Step 5

Run the build again and follow the steps to install the Module again.
