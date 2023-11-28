# PowerShell-Skript zur Entfernung vorinstallierter Bloatware in Windows 10 basierend auf einer Whitelist

# Überprüfen, ob das Skript bereits ausgeführt wurde
$LogFile = "C:\Temp\RemoveApps_Log.txt"
if (Test-Path $LogFile) {
    Write-Host "Das Skript wurde bereits ausgeführt. Beende..."
    exit
}

# Liste der Apps, die behalten werden sollen
$Whitelist = @(
    #"Microsoft.WindowsStore"
    #"Microsoft.Windows.Search"
    #"Microsoft.MicrosoftEdgeDevToolsClient"
    "Microsoft.ScreenSketch",
    "Microsoft.Paint3D",
    "Microsoft.MicrosoftEdge"
    "Microsoft.WindowsCalculator",
    "Microsoft.Windows.Photos",
    "Microsoft.MicrosoftStickyNotes",
    "Microsoft.MSPaint",
    "Microsoft.WindowsCamera",
    ".NET",
    "Microsoft.HEIFImageExtension",
    "Microsoft.ScreenSketch",
    "Microsoft.VP9VideoExtensions",
    "Microsoft.WebMediaExtensions",
    "Microsoft.WebpImageExtension",
    "Microsoft.DesktopAppInstaller",
    "Microsoft.RemoteDesktop",
    "WindSynthBerry",
    "MIDIBerry",
    "Slack"
)

# Überprüfen, ob das Verzeichnis für das Logfile existiert, andernfalls erstellen
$LogDirectory = "C:\Temp"
if (-not (Test-Path $LogDirectory)) {
    New-Item -ItemType Directory -Path $LogDirectory | Out-Null
}

# Logdatei erstellen
$LogContent = "Bereinigungsdatum: $(Get-Date)"
$LogContent | Out-File -FilePath $LogFile -Append

# Alle vorinstallierten Apps abrufen
$InstalledApps = Get-AppxPackage -AllUsers

# Durchlaufe installierte Apps
foreach ($App in $InstalledApps) {
    $AppName = $App.Name
    $PackageFullName = $App.PackageFullName

    # Überprüfe, ob App in Whitelist
    $IsWhitelisted = $Whitelist -contains $PackageFullName -or $Whitelist -contains $AppName

    # Logge Information
    "$AppName - Whitelisted: $IsWhitelisted" | Out-File -FilePath $LogFile -Append

    # Falls nicht in Whitelist, entferne die App
    if (-not $IsWhitelisted) {
        Write-Host "Entferne $AppName..." -NoNewline
        try {
            Remove-AppxPackage -Package $PackageFullName -AllUsers -ErrorAction Stop
            Write-Host "Fertig"
        } catch {
            Write-Host "Konnte nicht entfernt werden"
        }
    }
}

Write-Host "Whitelisted Apps bleiben erhalten. Andere wurden entfernt."
# end script
