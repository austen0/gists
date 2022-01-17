# This script enables Riot Vanguard at startup on an adhoc basis.
#
# Author: austen0
#
# How it works:
#   When Vanguard installs, the local machine registry is edited to run vgtray.exe at startup. This
#   script copies the property created by the installer to the RunOnce key which functions the same
#   but after it's executed for the first time, Windows will automatically delete the property and
#   it will not be launched on subsequent startups. This is not a circumvention of Vanguard's
#   functionality in any way, it's simply more convenient than manually enabling and disabling
#   automatic startup for Vanguard through Windows settings for people that don't want this running
#   all the time.

$PropertyName = "Riot Vanguard"
$SrcKeyPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
$DestKeyPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce"

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")

# Confirm vanguard property exists before trying to copy, else throw error
if((Get-ItemProperty -Path $SrcKeyPath).PSObject.Properties.name -contains $PropertyName) {
    Copy-ItemProperty `
        -Path Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Run `
        -Destination Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce `
        -Name "Riot Vanguard"
} else {
    [System.Windows.Forms.MessageBox]::Show("Fatal error: No startup key property exists for Vanguard", "runonce-vanguard.ps1", "Dang", "Error")
    Exit 1
}

if((Get-ItemProperty -Path $DestKeyPath).PSObject.Properties.name -contains $PropertyName) {
    $RebootInput = [System.Windows.Forms.MessageBox]::Show("Vanguard successfully added to next startup. Would you like to reboot now?", "runonce-vanguard.ps1", "YesNo")
} else {
    [System.Windows.Forms.MessageBox]::Show("Fatal error: Property creation failed", "runonce-vanguard.ps1", "Dang", "Error")
    Exit 1
}

if($RebootInput -eq "Yes") {
    Restart-Computer
}
