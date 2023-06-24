# Get the directory where the script is located.
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path

# Logo Intro
$animation_frames = @(
    "                               ( O_)",
    "                              / `-/",
    "                             /-. /",
    "                            /   )",
    "                           /   /",
    "              _           /-. /",
    "             (_)*-._     /   )",
    "               *-._ *-'**( )/",
    "                   *-/*-._* `.",
    "                    /     *-.'._",
    "                   /\       /-._*-._",
    "    _,---...__    /  ) _,-*/    *-(_)",
    "___<__(|) _   **-/  / /   /",
    " '  `----' **-.   \/ /   /",
    "               )  ] /   /",
    "       ____..-'   //   /                       )",
    "   ,-**      __.,'/   /   ___                 /,",
    "  /    ,--**/  / /   /,-**   ***-.          ,'/",
    " [    (    /  / /   /  ,.---,_   `._   _,-',",
    "  \    `-./  / /   /  /       `-._  *** ,-'\\",
    "   `-._  /  / /   /_,'            **--*",
    "       */  / /   /*",
    "       /  / /   /",
    "      /  / /   /",
    "     /  |,'   /",
    "    :   /    /",  
    "    [  /   ,'     ~>Cracked by<~ Zer0DayLab - ",
    "    | /  ,'      ~~>Dev XxRagulxX<~~ AKA King",
    "    |/,-'",
    "    '"
)

foreach ($frame in $animation_frames) {
    Write-Host $frame
    Start-Sleep -Milliseconds 200
}

Write-Host "Burpsuite Professional"
Write-Host "Special Thanks to Zer0DayLab for the Crack, Cheers Mate :)"


# Check JDK-20 Availability or Download JDK-20.
function IsJavaInstalled {
    return [bool](Get-Command java -ErrorAction SilentlyContinue)
}
function DownloadAndInstallJava {
    Write-Host "`t`tDownloading Java JDK-20 ...."

    Invoke-WebRequest -Uri $Link -OutFile "Burp_Suite_Pro.jar"

    $jdkDownloadUrl = "https://download.oracle.com/java/20/latest/jdk-20_windows-x64_bin.exe"
    $jdkInstallerPath = Join-Path -Path $scriptDirectory -ChildPath "jdk-20.exe"

    # Download JDK.
    (New-Object System.Net.WebClient).DownloadFile($jdkDownloadUrl, $jdkInstallerPath)
    Write-Host "`n`t`tJDK-20 Downloaded, let's start the Installation process silently"

    # Install JDK.
    $installArgs = "/s"
    Start-Process -Wait -FilePath $jdkInstallerPath -ArgumentList $installArgs

    Remove-Item -Path $jdkInstallerPath
}

if (IsJavaInstalled) {
    Write-Host "Required JDK-20 is already installed"
}
else {
    DownloadAndInstallJava
}
# Prompt user for Burp Suite version.
$burpSuiteVersion = "2023.6.1"

# Construct the download URL based on the selected version.
$downloadUrl = "https://portswigger-cdn.net/burp/releases/download?product=pro&version=2023.6.1&type=Jar"

# Check if Burp Suite JAR file is available and download if necessary.
if (-not (Test-Path "burpsuite_pro_v$burpSuiteVersion.jar")) {
    Write-Host "Downloading Burp Suite Professional $burpSuiteVersion ..."
    (New-Object System.Net.WebClient).DownloadFile($downloadUrl, "burpsuite_pro_v2023.6.1.jar")
    Write-Host "Burp Suite Professional is downloaded.`n"
}
else {
    Write-Host "Burp Suite Professional JAR file is already available.`n"
}

# Downloading Burploader from Github.
function Download-File {
    param (
        [string]$url,
        [string]$destination
    )

    if (Test-Path $destination) {
        Write-Host "$destination already exists. Skipping the download."
        return
    }

    $client = New-Object System.Net.WebClient

    try {
        $client.DownloadFile($url, $destination)
        Write-Host "File $destination downloaded successfully."
    }
    catch {
        Write-Host "Failed to download file."
    }
    finally {
        $client.Dispose()
    }
}

# URL & PATH
$url = "https://github.com/XxRagulxX/Burpsuite_pro/raw/main/burploader.jar"
$destination = "burploader.jar"
Download-File -url $url -destination $destination

if (Test-Path "burp runner.bat") {
    Remove-Item "burp runner.bat"
}

# Creating Burp.bat file with command for execution.
$path = 'java --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED -javaagent:burploader.jar -jar burpsuite_pro_v2023.6.1.jar -r'
$path | Add-Content -Path "burp runner.bat"
Write-Host "`nburp runner.bat file is created`n"


# Creating Burpsuite pro.vbs File for Running application alone.
$scriptPath = "Burpsuite pro.vbs"
$batFile = (Join-Path $PSScriptRoot "burp runner.bat")

@"
Set WshShell = CreateObject("WScript.Shell")
WshShell.Run Chr(34) & "$batFile" & Chr(34), 0
Set WshShell = Nothing
"@ | Set-Content -Path $scriptPath

Write-Host "`nBurpsuite pro.vbs file is created."
Write-Host "ALL files downloaded."

# Opening Jar File.
Write-Host "Opening Jar File"

$jarFileName = "burploader.jar"
$jarFilePath = Join-Path -Path $scriptDirectory -ChildPath $jarFileName
java -jar $jarFilePath




