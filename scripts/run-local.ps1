param(
  [int]$Port = 8084,
  [switch]$StartTomcat
)

$ErrorActionPreference = "Stop"

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 -bor `
  ([Net.SecurityProtocolType]::Tls13 2>$null)

function Ensure-Dir([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) {
    New-Item -ItemType Directory -Path $Path | Out-Null
  }
}

function Download-File([string]$Url, [string]$OutFile) {
  if (Test-Path -LiteralPath $OutFile) { return }
  Write-Host "Downloading: $Url"
  $attempts = 0
  while ($true) {
    $attempts++
    try {
      Invoke-WebRequest -Uri $Url -OutFile $OutFile -UseBasicParsing
      return
    } catch {
      if ($attempts -ge 3) { throw }
      Start-Sleep -Seconds (2 * $attempts)
    }
  }
}

function Download-FileFromAny([string[]]$Urls, [string]$OutFile) {
  if (Test-Path -LiteralPath $OutFile) { return }
  $lastError = $null
  foreach ($url in $Urls) {
    try {
      Download-File $url $OutFile
      return
    } catch {
      $lastError = $_
    }
  }
  if ($lastError) { throw $lastError }
  throw "Failed to download file."
}

function Expand-Zip([string]$ZipPath, [string]$DestDir) {
  if (Test-Path -LiteralPath $DestDir) { return }
  Write-Host "Extracting: $ZipPath"
  Expand-Archive -Path $ZipPath -DestinationPath $DestDir
}

function Find-FirstDirWith([string]$Root, [string]$RelativePath) {
  $match = Get-ChildItem -LiteralPath $Root -Directory | Where-Object {
    Test-Path -LiteralPath (Join-Path $_.FullName $RelativePath)
  } | Select-Object -First 1
  if ($null -eq $match) { return $null }
  return $match.FullName
}

$projectRoot = Split-Path -Parent $PSScriptRoot
$toolsRoot = Join-Path $projectRoot ".tools"

Ensure-Dir $toolsRoot

# --- Download portable JDK (Temurin) ---
$jdkZip = Join-Path $toolsRoot "jdk.zip"
$jdkExtract = Join-Path $toolsRoot "jdk"
Download-File "https://api.adoptium.net/v3/binary/latest/17/ga/windows/x64/jdk/hotspot/normal/eclipse?project=jdk" $jdkZip
Expand-Zip $jdkZip $jdkExtract
$javaHome = Find-FirstDirWith $jdkExtract "bin\\java.exe"
if (-not $javaHome) { throw "Could not locate java.exe under $jdkExtract" }
$env:JAVA_HOME = $javaHome
$env:Path = (Join-Path $env:JAVA_HOME "bin") + ";" + $env:Path

Write-Host ("JAVA_HOME = {0}" -f $env:JAVA_HOME)

# --- Download portable Ant ---
$antZip = Join-Path $toolsRoot "ant.zip"
$antExtract = Join-Path $toolsRoot "ant"
Download-FileFromAny @(
  "https://dlcdn.apache.org/ant/binaries/apache-ant-1.10.14-bin.zip",
  "https://downloads.apache.org/ant/binaries/apache-ant-1.10.14-bin.zip",
  "https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.14-bin.zip",
  "https://repo.maven.apache.org/maven2/org/apache/ant/apache-ant/1.10.14/apache-ant-1.10.14-bin.zip"
) $antZip
Expand-Zip $antZip $antExtract
$antHome = Find-FirstDirWith $antExtract "bin\\ant.bat"
if (-not $antHome) { throw "Could not locate ant.bat under $antExtract" }
$env:ANT_HOME = $antHome
$env:Path = (Join-Path $env:ANT_HOME "bin") + ";" + $env:Path

Write-Host ("ANT_HOME  = {0}" -f $env:ANT_HOME)

# --- Download portable Tomcat 9 ---
$tomcatZip = Join-Path $toolsRoot "tomcat.zip"
$tomcatExtract = Join-Path $toolsRoot "tomcat"
Download-FileFromAny @(
  "https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.zip",
  "https://downloads.apache.org/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.zip",
  "https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.89/bin/apache-tomcat-9.0.89.zip"
) $tomcatZip
Expand-Zip $tomcatZip $tomcatExtract
$tomcatHome = Find-FirstDirWith $tomcatExtract "bin\\catalina.bat"
if (-not $tomcatHome) { throw "Could not locate catalina.bat under $tomcatExtract" }

Write-Host ("TOMCAT    = {0}" -f $tomcatHome)

# --- Ensure required runtime/build jars ---
$libDir = Join-Path $projectRoot "web\\WEB-INF\\lib"
Ensure-Dir $libDir

Download-File "https://repo1.maven.org/maven2/com/mysql/mysql-connector-j/9.2.0/mysql-connector-j-9.2.0.jar" (Join-Path $libDir "mysql-connector-j-9.2.0.jar")
Download-File "https://repo1.maven.org/maven2/org/apache/taglibs/taglibs-standard-impl/1.2.5/taglibs-standard-impl-1.2.5.jar" (Join-Path $libDir "taglibs-standard-impl-1.2.5.jar")
Download-File "https://repo1.maven.org/maven2/org/apache/taglibs/taglibs-standard-jstlel/1.2.5/taglibs-standard-jstlel-1.2.5.jar" (Join-Path $libDir "taglibs-standard-jstlel-1.2.5.jar")
Download-File "https://repo1.maven.org/maven2/org/apache/taglibs/taglibs-standard-spec/1.2.5/taglibs-standard-spec-1.2.5.jar" (Join-Path $libDir "taglibs-standard-spec-1.2.5.jar")

# --- Ensure ToyyibPay local config exists ---
$toyCfg = Join-Path $projectRoot "web\\WEB-INF\\toyyibpay.properties"
$toyExample = Join-Path $projectRoot "web\\WEB-INF\\toyyibpay.properties.example"
if (-not (Test-Path -LiteralPath $toyCfg)) {
  if (Test-Path -LiteralPath $toyExample) {
    Copy-Item -LiteralPath $toyExample -Destination $toyCfg
    Write-Host "Created: $toyCfg"
  } else {
    Write-Host "Missing toyyibpay.properties.example; create $toyCfg manually."
  }
}

# --- Configure Tomcat port ---
$serverXml = Join-Path $tomcatHome "conf\\server.xml"
$serverXmlText = Get-Content -LiteralPath $serverXml -Raw
$updated = $false
$pattern = '(<Connector\s+port=")\d+(".*protocol="HTTP/1\.1")'
if ($serverXmlText -match $pattern) {
  $serverXmlText = [regex]::Replace($serverXmlText, $pattern, ('$1{0}$2' -f $Port), 1)
  $updated = $true
} elseif ($serverXmlText -match 'Connector port=\"8080\"') {
  $serverXmlText = $serverXmlText -replace 'Connector port=\"8080\"', ('Connector port="{0}"' -f $Port)
  $updated = $true
}
if ($updated) {
  Set-Content -LiteralPath $serverXml -Value $serverXmlText -Encoding UTF8
  Write-Host "Tomcat HTTP port set to $Port"
}

# --- Build WAR (without NetBeans) ---
$stageRoot = Join-Path $toolsRoot "stage"
if (Test-Path -LiteralPath $stageRoot) {
  Remove-Item -LiteralPath $stageRoot -Recurse -Force
}
Ensure-Dir $stageRoot
Copy-Item -Path (Join-Path $projectRoot "web\\*") -Destination $stageRoot -Recurse -Force

$classesDir = Join-Path $stageRoot "WEB-INF\\classes"
Ensure-Dir $classesDir

$srcDir = Join-Path $projectRoot "src\\java"
$javaFiles = Get-ChildItem -Path $srcDir -Recurse -Filter "*.java" | Select-Object -ExpandProperty FullName
if (-not $javaFiles -or $javaFiles.Count -eq 0) { throw "No Java sources found under $srcDir" }

$servletApi = Join-Path $tomcatHome "lib\\servlet-api.jar"
if (-not (Test-Path -LiteralPath $servletApi)) { throw "Missing servlet-api.jar at $servletApi" }

$libJars = Get-ChildItem -LiteralPath $libDir -Filter "*.jar" | Select-Object -ExpandProperty FullName
$compileCp = @($servletApi) + @($libJars)
$cp = [string]::Join(";", $compileCp)

Write-Host "Compiling Java sources..."
& (Join-Path $env:JAVA_HOME "bin\\javac.exe") --release 8 -encoding UTF8 -d $classesDir -cp $cp @($javaFiles)

Ensure-Dir (Join-Path $projectRoot "dist")
$warPath = Join-Path $projectRoot "dist\\S70632_Masjid_Management_System.war"
if (Test-Path -LiteralPath $warPath) { Remove-Item -LiteralPath $warPath -Force }

Write-Host "Packaging WAR..."
& (Join-Path $env:JAVA_HOME "bin\\jar.exe") cf $warPath -C $stageRoot .

# --- Deploy WAR ---
$webapps = Join-Path $tomcatHome "webapps"
Ensure-Dir $webapps
Copy-Item -LiteralPath $warPath -Destination (Join-Path $webapps "S70632_Masjid_Management_System.war") -Force

Write-Host ""
Write-Host "Deployed WAR to: $webapps"
Write-Host ("Open: http://localhost:{0}/S70632_Masjid_Management_System/" -f $Port)
Write-Host ""
if ($StartTomcat) {
  Write-Host "Starting Tomcat (Ctrl+C to stop)..."
  $env:CATALINA_HOME = $tomcatHome
  $env:CATALINA_BASE = $tomcatHome
  Push-Location (Join-Path $tomcatHome "bin")
  try {
    & .\\catalina.bat run
  } finally {
    Pop-Location
  }
} else {
  Write-Host "Tomcat not started. To start it:"
  Write-Host ("  cd `"{0}`"" -f (Join-Path $tomcatHome "bin"))
  Write-Host "  .\\catalina.bat run"
}
