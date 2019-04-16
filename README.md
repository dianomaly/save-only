Description
=================

Use this module to backup a users profile to a network location or a local (USB device). The module will copy everything in the target
user's **C:\Users\[User Name]** directory except for in the AppData directory. The only things copied from the AppData directory are the
contents of the following directory: 

**'\AppData\Local\Microsoft','\AppData\Local\Google','\AppData\Roaming\Microsoft\Excel','\AppData\Roaming\Microsoft\Outlook',
'\AppData\Roaming\Microsoft\PowerPoint','\AppData\Roaming\Microsoft\Word','\AppData\Roaming\Mozilla'.**

Once the contents of the target user's directory is copied to your specified directory it will zipup the content with 7zip, using the specified password as the encryption key.

The save-only module will be the entry point to execute a profile backup. The zipup module will zip up the target users profile, the logwrite module will allow logging to be outputted to a log file in the directory that the module is ran from.

Examples
=================

`save-only -userpath C:\Users\TargetUser -pass EncryptionPass -raw_profile Locationtostorecopiedprofile -profile_store zipfilestorelocation`
