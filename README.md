Description
=================

Use this module to backup a users profile to a network location or a local (USB device). The module will copy everything in the target
user's **C:\Users\[User Name]** directory except for in the AppData directory. The only things copied from the AppData directory are the
contents of the following directory: 

**'\AppData\Local\Microsoft','\AppData\Local\Google','\AppData\Roaming\Microsoft\Excel','\AppData\Roaming\Microsoft\Outlook',
'\AppData\Roaming\Microsoft\PowerPoint','\AppData\Roaming\Microsoft\Word','\AppData\Roaming\Mozilla'.**

Once the contents of the target user's directory is copied to your specified directory it will zipup the content with 7zip, using the specified password as the encryption key.

The save-only module will be the entry point to execute a profile backup. The zipup module will zip up the target users profile, the logwrite module will allow logging to be outputted to a log file in the directory that the module is ran from.

Save-Only Cmdlet Options
=================

-userpath - The path to the target user you want to backup.

-pass - Password to be used when the profile is zipped up and encrypted.

-raw_profile - Storage location of copied profile information.

-profile_store - Location to store zipped profile.

-Logfile - Log file location by default this will be in the location that the script is executed from.

Zipup Cmdlet Options
=================

-location - path to directory/file that will be zipped. This is passed in from the save-only module if the save-only module is ran.

-PlainPassword - password string in plaintext. This is passed in from the save-only module if the save-only module is ran.

-securepath - path to a securestring password file by default this looks at a file called passtime.txt in the root directory for where the module was executed.

-store_loc - storage location for zipped file. This is passed in from the save-only module if the save-only module is ran.

-isprofile - switch to determine whether the location param is a file or directory, by default this is set to true and will run as a directory.

-Logfile - location of where the logfile is stored. 

LogWrite Cmdlet Options
=================

-logstring - String that is passed in to be written to the logfile.

-logfile - location of logfile.

Examples
=================

`save-only -userpath C:\Users\TargetUser -pass EncryptionPass -raw_profile Locationtostorecopiedprofile -profile_store zipfilestorelocation`


Requirements
=================

7zip application is required to run this script.

This script must be ran as an admin user on the target machine.

The modules must all be in the same directory in order for the save-only module to work correctly.
