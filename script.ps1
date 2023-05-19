$key = New-Object byte[] 32
[Security.Cryptography.RNGCryptoServiceProvider]::Create().GetBytes($key)

# Set Wget Progress to Silent, Becuase it slows down Downloading by +50x
Write-Output "Setting Wget Progress to Silent, Becuase it slows down Downloading by +50x`n"
$ProgressPreference = 'SilentlyContinue'

# Check JDK-18 Availability or Download JDK-20
$jdk20 = & winget list --name-only | Where-Object { $_ -like 'Java(TM) SE Development Kit 20*' }

if (!$jdk20) {
    Write-Output "`t`tDownloading Java JDK-20 ...."
    Start-Process -FilePath 'winget' -ArgumentList 'install --id Oracle.JavaJDK --silent' -Wait
    Write-Output "`n`t`tJava JDK-20 installation completed."
} else {
    Write-Output "Required JDK-20 is already installed"
    $jdk20
}


# Check JRE-8 Availability or Download JRE-8
$jre8 = & winget list --name-only | Where-Object { $_ -like 'Java 8 Update *' }

if (!$jre8) {
    Write-Output "`n`t`tDownloading Java JRE ...."
    Start-Process -FilePath 'winget' -ArgumentList 'install --id Oracle.JavaRuntimeEnvironment --silent' -Wait
    Write-Output "`n`t`tJava JRE installation completed."
} else {
    Write-Output "`n`nRequired JRE-8 is already installed`n"
    $jre8
}


Write-Output "We are getting ready to download files from XxRagulxX Github"

function Show-DownloadAnimation {
    $spinner = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
    $i = 0
    $endTime = (Get-Date).AddSeconds(7)

    while ((Get-Date) -lt $endTime) {
        Write-Host -NoNewline "`rFeaching Files from XxRagulxX Server... $($spinner[$i])"
        $i = ($i + 1) % $spinner.Length
        Start-Sleep -Milliseconds 100
    }
}

function Show-DownloadAnimationexit {
    $spinner = @("⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏")
    $i = 0
    $endTime = (Get-Date).AddSeconds(7)

    while ((Get-Date) -lt $endTime) {
        Write-Host -NoNewline "`rDisconnecting from XxRagulxX Server... $($spinner[$i])"
        $i = ($i + 1) % $spinner.Length
        Start-Sleep -Milliseconds 100
    }
}

Clear-Host
#$response = Invoke-RestMethod -Uri "https://api.ipify.org?format=json"
#$ipAddress = $response.IP
#Write-Host "Public IP address: $ipAddress"
Write-Host "Connecting To XxRagulxX Server"
Write-Output "Authenticating..."
Show-DownloadAnimation
Write-Host "`rApproved! Getting Files from XxRagulxX Server"

$folderPath = "C:\Burpsuite"
$downloadUrl1 = "https://raw.githubusercontent.com/XxRagulxX/Burpsuite_pro/main/burploader.jar"
$downloadUrl2 = "https://raw.githubusercontent.com/XxRagulxX/Burpsuite_pro/main/burp_pro.sh"

# Function to download a file
function DownloadFile($url, $fileName) {
    $file = "C:\Burpsuite\$fileName"
    $hash = (Get-FileHash -Path $file -Algorithm SHA384).Hash
    $downloadPath = Join-Path $folderPath $fileName
    Invoke-WebRequest -Uri $url -OutFile $downloadPath
    #Write-Host "File downloaded and saved: $downloadPath"
    Write-Host "SHA-384 Hash Value: $hash"
}

# Create the folder if it doesn't exist
if (!(Test-Path $folderPath -PathType Container)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
    Write-Host "Folder created: $folderPath"
}

# Download the files
DownloadFile $downloadUrl1 "burploader.jar"
DownloadFile $downloadUrl2 "burp_pro.sh"

Write-Host "File downloads completed!"
Show-DownloadAnimationexit
Write-Host "`rDisconnected!"

$desiredVersion = "2023.4.3"
$folderPath = "C:\burpsuite"
$downloadUrl = "https://portswigger.net/burp/releases/startdownload?product=pro&version=$desiredVersion&type=Jar"
$downloadPath = Join-Path $folderPath "Burp-Suite-Pro.jar"

# Create the folder if it doesn't exist
if (!(Test-Path $folderPath -PathType Container)) {
    New-Item -ItemType Directory -Path $folderPath | Out-Null
    Write-Host "Folder created: $folderPath"
}

Write-Host "Downloading Burp Suite Professional $desiredVersion"
# Check if the file already exists
if (Test-Path $downloadPath) {
    $fileSizeMB = (Get-Item $downloadPath).Length / 1MB

    if ($fileSizeMB -lt 400) {
        Write-Output "`n`t`tFile seems to be corrupted.`n`t`tDownloading Burp Suite Professional v$desiredVersion ...."
        Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath
    } else {
        Write-Output "File looks fine. Proceeding with execution."
    }
} else {
    Write-Output "`n`t`tDownloading Burp Suite Professional v$desiredVersion ...."
    Invoke-WebRequest -Uri $downloadUrl -OutFile $downloadPath
}

Write-Host "Burp Download Completed"
Write-Host "Thanks for Using Me Goodbye :) Press Enter to Exit."
Read-Host