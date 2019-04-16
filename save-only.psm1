function save-only {



[CmdletBinding()]

param(
#path to file/directory we want to zip
[Parameter(Mandatory=$true)]
[string] $userpath,
#password used to encrypt file/directory
[string] $pass,
#storage location of copied profile information
[string] $raw_profile = '',
#location to store zipped profile.
[string] $profile_store,
#log file location
[string] $Logfile = "$PSScriptRoot\logfile.log" 

)
#importing zipping module
Import-Module "$PSScriptRoot\zipup.psm1"
#importing LogWriting moduel
Import-Module "$PSScriptRoot\LogWrite.psm1"


$date = (Get-Date -Format g).ToString() 
LogWrite -logfile $Logfile -logstring "$date Starting save-only script..."

LogWrite -logfile $Logfile -logstring "$date Checking to see if running script as Administrator..."
# Checking to make sure script is being run as an administrator   
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
[Security.Principal.WindowsBuiltInRole] "Administrator"))
{
Write-Warning "You do not have Administrator rights to run this script!`nPlease re-run this script as an Administrator!"
Break
}

LogWrite -logfile $Logfile -logstring "$date Checking to see if trying to copy entire C drive..."

[string] $notallow = "C:\"
# fail safe so that we dont try to copy entire C drive by accident

if ($notallow -eq $userpath)
{ Write-Error "This is not an allowed input. Terminating script..."
  Return 1
}

#extracting name of file/directory
$zipname = Split-Path -Path $userpath -Leaf 


# location profile will be saved
$newloc = $raw_profile + $zipname +" " + $(Get-Date -Format MM-dd-yyyy)
LogWrite -logfile $Logfile -logstring "$date Beginning copy of $userpath to $newloc..."
# Setting path that will be exclusded from the Robocopy 

$exclusionpath = $userpath + '\AppData'

try {

# Copying user data except AppData path

    Robocopy.exe $userpath $newloc /log+:"$Logfile" /s /np /eta /xd /xj $exclusionpath 
    
    }

catch

    {
        Write-Error "Failed to copy user profile data..."
        Throw $_
        Break
    }
    
try {
# AppData paths we want to copy 
    $Folderstocopy =  @(
        '\AppData\Local\Microsoft'
        '\AppData\Local\Google'
        '\AppData\Roaming\Microsoft\Excel'
        '\AppData\Roaming\Microsoft\Outlook'
        '\AppData\Roaming\Microsoft\PowerPoint'
        '\AppData\Roaming\Microsoft\Word'
        '\AppData\Roaming\Mozilla'

    )
    LogWrite -logfile $Logfile -logstring "$date Beginning copy of AppData folder locations to $newloc..."
    foreach ($item in $Folderstocopy)
    {
# Setting path we want to copy from AppData  

    $appcopy = $userpath + $item
    
    if (test-path $appcopy)

    {
# Copying AppData path to same location as other user data
        Robocopy.exe $appcopy $newloc /e /xj /np /eta /log+:"$Logfile"

    }
    }
}
catch {
        Write-Error "Failed to copy AppData Files/Directory..."
        Throw $_
        Break
}

LogWrite -logfile $Logfile -logstring "$date Beginning zipping of $newloc..."
$quotes = ""

if ($profile_store -eq $quotes)
{
    zipup -location $newloc -PlainPassword $pass
}

else 
{
    zipup -location $newloc -PlainPassword $pass -store_loc $profile_store 
}


}
Export-ModuleMember save-only