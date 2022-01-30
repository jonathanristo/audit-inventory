PowerShell script

For this script to work, it does not require any additional information to invoke it.
All that is needed is the .ps1 file to be stored on the disk. When the command is run, it
will request the IP address from the user. No other input is needed. It will query the
remote PC using the credentials that invoked the program.

The output of this script is also stored in the c:\temp directory. The output will be
in the format of <IP address>_<YEAR><MONTH><DAY><HOUR><MINUTE>.txt.
For example, when the program is run it would create a file called
172.19.5.9_201607301134.txt that contains all of the output from the command.
This naming convention was done to permit multiple collections from the same IP
address to happen without overwriting the information, and to quickly provide a
reference of when the file was created.

To change this setting, and reference to c:\temp found within the script must be
modified.

To run this script, just type the following command at an administrative command
prompt. The following command example assumes that the ps1 file is saved in the
c:\temp directory and is called software_enumeration.ps1.

powershell -executionpolicy bypass –file software_enumeration.ps1

The -executionpolicy bypass option is used to ensure that the script will run even
if the security policy is configured to block PowerShell scripts. This exception allows the
scripts to run and lowers the setting only for that PowerShell session, and not the entire
system configuration
