# PowerShell-Skript zum Entfernen von vorinstallierter Bloatware in Windows 10 basierend auf einer Whitelist

# Überprüfen, ob das Skript bereits ausgeführt wurde
$LogFile = "C:\Temp\RemoveApps_Log.txt"
if (Test-Path $LogFile) {
    Write-Host "Script has already been executed. Exiting..."
    exit
}

# Liste der Apps, die behalten werden sollen
$Whitelist = @(
    "*MicrosoftTeams*",
    "*1527c705-839a-4832-9118-54d4Bd6a0c89*"
    "*c5e2524a-ea46-4f67-841f-6a9465d9d515*"
    "*E2A4F912-2574-4A75-9BB0-0D023378592B*"
    "*F46D4000-FD22-4DB4-AC8E-4E1DDDE828FE*"
    "*InputApp*"
    "*Microsoft.AAD.BrokerPlugin*"
    "*Microsoft.AccountsControl*"
    "*Microsoft.BioEnrollment*"
    "*Microsoft.CredDialogHost*"
    "*Microsoft.ECApp*"
    "*Microsoft.LockApp*"
    "*Microsoft.MicrosoftEdgeDevToolsClient*"
    "*Microsoft.MicrosoftEdge*"
    "*Microsoft.PPIProjection*"
    "*Microsoft.Win32WebViewHost*"
    "*Microsoft.Windows.Apprep.ChxApp*"
    "*Microsoft.Windows.AssignedAccessLockApp*"
    "*Microsoft.Windows.CapturePicker*"
    "*Microsoft.Windows.CloudExperienceHost*"
    "*Microsoft.Windows.ContentDeliveryManager*"
    "*Microsoft.Windows.Cortana*"
    "*Microsoft.Windows.HolographicFirstRun*"
    "*Microsoft.Windows.NarratorQuickStart*"
    "*Microsoft.Windows.OOBENetworkCaptivePortal*"
    "*Microsoft.Windows.OOBENetworkConnectionFlow*"
    "*Microsoft.Windows.ParentalControls*"
    "*Microsoft.Windows.PeopleExperienceHost*"
    "*Microsoft.Windows.PinningConfirmationDialog*"
    "*Microsoft.Windows.SecHealthUI*"
    "*Microsoft.Windows.SecondaryTileExperience*"
    "*Microsoft.Windows.SecureAssessmentBrowser*"
    "*Microsoft.Windows.ShellExperienceHost*"
    "*Microsoft.Windows.XGpuEjectDialog*"
    "*Microsoft.XboxGameCallableUI*"
    "*Windows.CBSPreview*"
    "*windows.immersivecontrolpanel*"
    "*Windows.PrintDialog*"
    "*Microsoft.VCLibs.140.00*"
    "*Microsoft.Services.Store.Engagement*"
    "*Microsoft.UI.Xaml.2.0*"
    "*Microsoft.WindowsCalculator*"
    "*Microsoft.WindowsStore*"
    "*Microsoft.Windows.Photos*"
    "*CanonicalGroupLimited.UbuntuonWindows*"
    "*Microsoft.Xbox.TCUI*"
    "*Microsoft.XboxApp*"
    "*Microsoft.XboxGameOverlay*"
    "*Microsoft.XboxGamingOverlay*"
    "*Microsoft.XboxIdentityProvider*"
    "*Microsoft.XboxSpeechToTextOverlay*"
    "*Microsoft.MicrosoftStickyNotes*"
    "*Microsoft.MSPaint*"
    "*Microsoft.WindowsCamera*"
    "*\.NET*"
    "*Microsoft.HEIFImageExtension*"
    "*Microsoft.ScreenSketch*"
    "*Microsoft.StorePurchaseApp*"
    "*Microsoft.VP9VideoExtensions*"
    "*Microsoft.WebMediaExtensions*"
    "*Microsoft.WebpImageExtension*"
    "*Microsoft.DesktopAppInstaller*"
    "*Microsoft.RemoteDesktop*"
)

# Alle vorinstallierten Apps abrufen
$InstalledApps = Get-AppxPackage -AllUsers | Where-Object { $_.PackageFullName -notin $Whitelist }

# Überprüfen, ob das Verzeichnis für das Logfile existiert, andernfalls erstellen
$LogDirectory = "C:\Temp"
if (-not (Test-Path $LogDirectory)) {
    New-Item -ItemType Directory -Path $LogDirectory | Out-Null
}

# Logdatei erstellen
$LogContent = "Bereinigungsdatum: $(Get-Date)"
$LogContent | Out-File -FilePath $LogFile

# Apps entfernen, die nicht auf der Whitelist stehen
foreach ($App in $InstalledApps) {
    Write-Host "Removing $($App.Name)..." -NoNewline
    Remove-AppxPackage -Package $App.PackageFullName -AllUsers -Quiet
    Write-Host "Done"
}

Write-Host "Whitelisted apps are retained. Others have been removed."
