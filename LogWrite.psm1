Function LogWrite
{
   Param (
       [string] $logstring,
       [string] $logfile
   )

   Add-content $logfile -value $logstring
}

Export-modulemember LogWrite
