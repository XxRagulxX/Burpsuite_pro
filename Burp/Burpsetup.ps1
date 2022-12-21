# Name is Important
echo "                       ( O_)
                              / `-/
                             /-. /
                            /   )
                           /   /  
              _           /-. /
             (_)*-._     /   )
               *-._ *-'**( )/    
                   *-/*-._* `. 
                    /     *-.'._
                   /\       /-._*-._
    _,---...__    /  ) _,-*/    *-(_)
___<__(|) _   **-/  / /   /
 '  `----' **-.   \/ /   /
               )  ] /   /
       ____..-'   //   /                       )
   ,-**      __.,'/   /   ___                 /,
  /    ,--**/  / /   /,-**   ***-.          ,'/
 [    (    /  / /   /  ,.---,_   `._   _,-','
  \    `-./  / /   /  /       `-._  *** ,-'
   `-._  /  / /   /_,'            **--*
       */  / /   /*         
       /  / /   /
      /  / /   /  
     /  |,'   /  
    :   /    /
    [  /   ,'     ~>Burp Suit Tool<~ Dev - Sngwn
    | /  ,'      ~~>Modified By XxRagulxX<~~
    |/,-'
    '
"
# Suspending Wget Progress 
echo "Suspending Wget Process . Because I hate it`n"
$ProgressPreference = 'SilentlyContinue'

# Check JDK-18 Availability or Download JDK-19
$jdk18 = Get-WmiObject -Class Win32_Product -filter "Vendor='Oracle Corporation'" |where Caption -clike "Java(TM) SE Development Kit 19*"
if (!($jdk18)){
    echo "`t`tDownnloading Java JDK-19 ...."
    wget "https://download.oracle.com/java/19/latest/jdk-19_windows-x64_bin.exe" -O jdk-19.exe    
    echo "`n`t`tJDK-19 Downloaded, lets start the Installation process"
    start -wait jdk-19.exe
    rm jdk-19.exe
}else{
    echo "Required JDK-19 is Installed"
    $jdk18
}

# Check JRE-8 Availability or Download JRE-8
$jre8 = Get-WmiObject -Class Win32_Product -filter "Vendor='Oracle Corporation'" |where Caption -clike "Java 8 Update *"
if (!($jre8)){
    echo "`n`t`tDownloading Java JRE ...."
    wget "https://javadl.oracle.com/webapps/download/AutoDL?BundleId=246474_2dee051a5d0647d5be72a7c0abff270e" -O jre-8.exe
    echo "`n`t`tJRE-8 Downloaded, lets start the Installation process"
    start -wait jre-8.exe
    rm jre-8.exe
}else{
    echo "`n`nRequired JRE-8 is Installed`n"
    $jre8
}

# Downloading Burp Suite Professional
if (Test-Path burpsuite_pro_v2022.jar){
    echo "Burp Suite Professional JAR file is available.`nChecking its Integrity ...."
    if (((Get-Item burpsuite_pro_v2022.jar).length/1MB) -lt 500 ){
        echo "`n`t`tFiles Seems to be corrupted `n`t`tDownloading Burp Suite Professional v2022.12.4 ...."
        wget "https://portswigger.net/burp/releases/startdownload?product=pro&version=2022.12.4&type=Jar" -O "burpsuite_pro_v2022.jar"
        echo "`nBurp Suite Professional is Downloaded.`n"
    }else {echo "File Looks fine. Lets proceed for Execution"}
}else {
    echo "`n`t`tDownloading Burp Suite Professional v2022.12.4 ...."
    wget "https://portswigger-cdn.net/burp/releases/download?product=pro&version=2022.12.4&type=jar" -O "burpsuite_pro_v2022.jar"
    echo "`nBurp Suite Professional is Downloaded.`n"
}

# Creating Burp.bat file with command for execution
if (Test-Path burp.bat) {rm burp.bat} 
$path = "java --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED -javaagent:ja-netfilter.jar -jar burpsuite_pro_v2022.jar -r"
$path | add-content -path Burp.bat
echo "`nBurp.bat file is created"
echo "`n`nStarting Burp Suite Professional"
start-process "Burp.bat"
Start-Sleep -Seconds 8.0

# Creating Burp-Suite-Pro.vbs File for background execution
if (Test-Path Burp-Suite-Pro.vbs) {
   Remove-Item Burp-Suite-Pro.vbs}
echo "Set WshShell = CreateObject(`"WScript.Shell`")" > Burp-Suite-Pro.vbs
add-content Burp-Suite-Pro.vbs "WshShell.Run chr(34) & `"$pwd\Burp.bat`" & Chr(34), 0"
add-content Burp-Suite-Pro.vbs "Set WshShell = Nothing"
echo "`nBurp-Suite-Pro.vbs file is created."


# Lets Activate Burp Suite Professional with ja-netfilter by surferxyz Thank you so much :)
echo "Reloading Environment Variables ...."
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User") 
echo "`n`nStarting Ja-Netfilter ...."
start-process java.exe -argumentlist "ja-netfilter.jar"
java --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED -jar ja-netfilter.jar -r 


