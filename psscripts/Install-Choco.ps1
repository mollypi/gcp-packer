Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

function Choco-Install {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string] $PackageName,
        [string[]] $ArgumentList,
        [int] $RetryCount = 5
    )

    process {
        $count = 1
        while($true)
        {
            Write-Host "Running [#$count]: choco install $packageName -y $argumentList"
            choco install $packageName -y @argumentList --no-progress

            $pkg = choco list --localonly $packageName --exact --all --limitoutput
            if ($pkg) {
                Write-Host "Package installed: $pkg"
                break
            }
            else {
                $count++
                if ($count -ge $retryCount) {
                    Write-Host "Could not install $packageName after $count attempts"
                    exit 1
                }
                Start-Sleep -Seconds 30
            }
        }
    }
}


### using choco for git 
# Install git
Choco-Install -PackageName git -ArgumentList '--installargs="/VERYSILENT /NORESTART /NOCANCEL /SP- /CLOSEAPPLICATIONS /RESTARTAPPLICATIONS /o:PathOption=CmdTools /o:BashTerminalOption=ConHost /o:EnableSymlinks=Enabled /COMPONENTS=gitlfs"'

# Install hub
Choco-Install -PackageName hub

# Install GVFS
$url = "https://api.github.com/repos/microsoft/VFSForGit/releases/latest"
[System.String] $gvfsLatest = (Invoke-RestMethod -Uri $url).assets.browser_download_url -match "SetupGVFS.+\.exe$"
$gvfsInstallerPath = Start-DownloadWithRetry -Url $gvfsLatest -Name "SetupGVFS.exe"

# Start-Process waits on the entire process tree but Wait-Process only waits on the initiating process(GVFS.Service.UI.exe)
$env:GVFS_UNATTENDED = "1"
$argList = "/VERYSILENT", "/NORESTART", "/NOCANCEL", "/SP-", "/CLOSEAPPLICATIONS", "/RESTARTAPPLICATIONS", "/SUPPRESSMSGBOXES"
Start-Process $gvfsInstallerPath -ArgumentList $argList -PassThru | Wait-Process

# Disable GCM machine-wide
[Environment]::SetEnvironmentVariable("GCM_INTERACTIVE", "Never", [System.EnvironmentVariableTarget]::Machine)

# Add to PATH
Add-MachinePathItem "C:\Program Files\Git\bin"

if (Test-IsWin16) {
    $env:Path += ";$env:ProgramFiles\Git\usr\bin\"
}