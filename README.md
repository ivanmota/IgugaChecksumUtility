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
Install-Module -Name psake -Scope CurrentUser -SkipPublisherCheck
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

After install all required dependencies, make a clone of this project `git clone https://github.com/ivanmota/IgugaChecksumUtility.git` or just download it into a folder and run the following powershell command:

```powershell
Invoke-psake build.psake.ps1 -taskList Build
```

The above code will create the **Release** directory, where the module build results will be stored.

## How to manually install this module

Run the following Powershell command to discover where the Powershell Modules are installed:

```powershell
$Env:PSModulePath.Split([System.IO.Path]::PathSeparator)
```

Usually, the first line of the above output is where you can put modules just for the current user, the others are for all users. The paths depended on which version of Powershell and the Plataform (Windows, Mac, Linux) you are using.

Imagine that I'm using Powershell 5.1 on Windows 10 and I want to install this module just for my current user (which is "ivan2562", just as example). So the first line of the output of the code above could be something like:

`C:\Users\ivan2562\Documents\WindowsPowerShell\Modules`

So then I will need to create the folder `IgugaChecksumUtility` inside of the above path, so my result will be something like:

`C:\Users\ivan2562\Documents\WindowsPowerShell\Modules\IgugaChecksumUtility`

And after that I will need to create a folder with the same name as the version of this module, which is `1.0.0` when I'm writing this tutorial, so my result will be something like:

`C:\Users\ivan2562\Documents\WindowsPowerShell\Modules\IgugaChecksumUtility\1.0.0`

Then I will need to copy all the content of the `Release` folder (folder generated when we build this module) to the above directory.

And finally, we will need to run the following powershell commands to import this module:

```powershell
Import-Module IgugaChecksumUtility
```

## How to install this module via the project task

To install this module using the project you will need to run the following powershell commands:

```powershell
Import-Module ./src/IgugaChecksumUtility.psd1
Invoke-psake build.psake.ps1 -taskList Install
Import-Module IgugaChecksumUtility
```

The above commands will:

1. Create the build;
2. Create the module name and the current version folders on the current Powershell Modules directory of the current user;
3. Copy all the `Release` folder content to it; and
4. Proceed with the module import process.

## Execution Policy issues on Windows

If when you ran the Import-Module procedure you get an error saying that you can't load the class bla bla bla, because is not digitally signed, don't worry, it is the default behaviour of Powershell on Windows. By default, all script or module that are not signed on Powershell Windows will be not allowed to run.

You have two ways to work around this issue:

### Solution 1

Remove the restriction (which is not recommended), running the following code:

```powershell
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

The above code will ask your confirmation whether you want to remove the restriction for the current user or not. You should respond "Y" (yes)

For more information, check the [Execution Policy Page](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-5.1)

### Solution 2

Digitally sign the Module using a self-signed Certificate. Please find bellow all the steps that you will need to digitally sign the module on Windows 10:

#### Step 1

**Open PowerShell as administrator** on your computer.

#### Step 2

Copy the command below and run it in PowerShell. This command uses the `New-SelfSignedCertificate` cmdlet to create a new code signing certificate with 10 years expiration date. The certificate’s name is __Iguga Services__ inside the local computer’s Personal certificate store.

> The `New-SelfSignedCertificate` cmdlet only supports creating certificates in the current user’s personal certificate store (cert:\CurrentUser\My) or the local machine’s personal certificate store (cert:\LocalMachine\My). Certificates in cert:\LocalMachine\My are available computer-wide.

The command also stores the certificate object to the `$authenticode` variable for use in the next step.

```powershell
# Generate a self-signed Authenticode certificate in the local computer's personal certificate store.
$authenticode = New-SelfSignedCertificate -Subject "Iguga Services" -CertStoreLocation Cert:\LocalMachine\My -Type CodeSigningCert -NotAfter (Get-Date).AddYears(10)
```

#### Step 3

Next, to make your computer trust the new certificate you’ve created, add the self-signed certificate to the computer’s __Trusted Root Certification Authority__ and __Trusted Publishers__ certificate store. To do so, copy the code below and run it in PowerShell.

```powershell
# Add the self-signed Authenticode certificate to the computer's root certificate store.
## Create an object to represent the LocalMachine\Root certificate store.
$rootStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("Root","LocalMachine")
## Open the root certificate store for reading and writing.
$rootStore.Open("ReadWrite")
## Add the certificate stored in the $authenticode variable.
$rootStore.Add($authenticode)
## Close the root certificate store.
$rootStore.Close()

# Add the self-signed Authenticode certificate to the computer's trusted publishers certificate store.
## Create an object to represent the LocalMachine\TrustedPublisher certificate store.
$publisherStore = [System.Security.Cryptography.X509Certificates.X509Store]::new("TrustedPublisher","LocalMachine")
## Open the TrustedPublisher certificate store for reading and writing.
$publisherStore.Open("ReadWrite")
## Add the certificate stored in the $authenticode variable.
$publisherStore.Add($authenticode)
## Close the TrustedPublisher certificate store.
$publisherStore.Close()
```

#### Step 4

On the module project, edit the file `build.settings.ps1`:

1. Sets the variable `$ScriptSigningEnabled` value to `$true`
2. Sets the variable `$CertSubjectName` value to `"Iguga Services"`
3. Sets the variable `$CertPath` value to `"Cert:\LocalMachine\My"`
4. Finally save the file

#### Step 5

Run the build again and follow the steps to install this module again.
