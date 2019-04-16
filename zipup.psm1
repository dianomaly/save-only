function zipup {
[CmdletBinding()]

param (
	#path to file/directory you want to zip.
	[string] $location, 
	#password string
	$PlainPassword,
	# path to securestring password file 
	[string] $securepath = "$PSScriptRoot\passtime.txt",
	# the file storage location of zipped file
	$store_loc = "",
	#switch for if the input location is only a file or a profile(directory).
	$isprofile =($true),
	#logfile location
	$Logfile = "$PSScriptRoot\logfile.log"
)
# Checking to see if 7zip exists on pc
Import-Module "$PSScriptRoot\LogWrite.psm1"

#getting date-time
$date = (Get-Date -Format g).ToString() 
LogWrite -logfile $Logfile -logstring "$date Starting Zipup script..."

LogWrite -logfile $Logfile -logstring "$date Checking to see if 7zip is installed..."

#checking to see if 7zip is installed. If not it will terminate program
$zpath =[Environment]::GetEnvironmentVariable("ProgramW6432") + "\7-Zip\7z.exe"
	if (-not (test-path $zpath)) 
	{
		throw "$zpath needed. Profile is not backedup..."
		LogWrite -logfile $Logfile -logstring "$date 7zip not installed, terminating script..."
		Break
	} 
	LogWrite -logfile $Logfile -logstring "$date Checking to see if file or directory..."
	if ($isprofile -eq "$true" )
{
	set-alias sz $zpath  

	if ($PlainPassword -eq $null)
{	
	
	[string] $loc_name = Split-Path -Path $location -Leaf 
	# the file path of the zipped file
	$Target  = $store_loc + $loc_name +".7z"   
	# getting password info
	$content = Get-Content -Path $securepath

	# converting text to securing string
	$securePwd = $content | ConvertTo-SecureString 

	$passget = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd)
	# decrypting secure string to regular plain text 
	$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($passget)
	#running zip command
	$outval = sz a -t7z -bb2 -spe -p"$PlainPassword" -mx9 $Target $location 
	LogWrite -logfile $Logfile -logstring "$date Compression progress $outval"
	LogWrite -logfile $Logfile -logstring "$date Creating Zip file of $location"
	LogWrite -logfile $Logfile -logstring "$date Created $Target"
	
}

else {
	
	[string] $loc_name = Split-Path -Path $location -Leaf 

	# the file path of the zipped file
	$Target  = $store_loc + $loc_name +".7z"   

	#running zip command
	$outval =	sz a -t7z -bb2 -spe -p"$PlainPassword" -mx9 $Target $location 
	
	LogWrite -logfile $Logfile -logstring "$date Compression progress $outval"
	LogWrite -logfile $Logfile -logstring "$date Creating Zip file of $location"
	LogWrite -logfile $Logfile -logstring "$date Created $Target"
	

}

	}

else
{

	set-alias sz $zpath  
	
	$dirpaths = Get-ChildItem $location -Directory | % { $_.FullName}

	foreach ($dir in $dirpaths)
	{
	if ($PlainPassword -eq $null)
{	
	
	[string] $loc_name = Split-Path -Path $dir -Leaf 
	# the file path of the zipped file
	$Target  = $store_loc + $loc_name +".7z"   
	# getting password info
	$content = Get-Content -Path $securepath

	# converting text to securing string
	$securePwd = $content | ConvertTo-SecureString 

	$passget = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($securePwd)
	# decrypting secure string to regular plain text 
	$PlainPassword = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($passget)
	#running zip command
	$outval =  sz a -t7z -bb2 -spe -p"$PlainPassword" -mx9 $Target $dir 
	LogWrite -logfile $Logfile -logstring "$date Compression progress $outval"
	LogWrite -logfile $Logfile -logstring "$date Creating Zip file of $dir"
	LogWrite -logfile $Logfile -logstring "$date Created $Target"
	
}

else {
	
	[string] $loc_name = Split-Path -Path $dir -Leaf 

	# the file path of the zipped file
	$Target  = $store_loc + $loc_name +".7z"   

	#running zip command
	$outval = sz a -t7z -bb2 -spe -p"$PlainPassword" -mx9 $Target $dir 
	LogWrite -logfile $Logfile -logstring "$date Compression progress $outval"
	LogWrite -logfile $Logfile -logstring "$date Creating Zip file of $dir"
	LogWrite -logfile $Logfile -logstring "$date Created $Target"
	

}

	}
}

LogWrite -logfile $Logfile -logstring "$date Exiting Zipup script"
}

Export-ModuleMember zipup