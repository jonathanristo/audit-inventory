$orig_file = read-host 'Enter the full path and name of the baseline file for the computer to be audited: '

#get baseline file name from user
if (![System.IO.File]::Exists($orig_file)) {
#check to see if the file exists. If it doesn't, loop till it does

do{
$orig_file = read-host 'File does not exist. Enter the full path and name of the baseline file for the computer to be audited: '
}
while (![System.IO.File]::Exists($orig_file))
}

#have a file that exists for a baseline.
$query_means = read-host 'Enter the collection method you wish to use to audit the information (type one of psinfo, powershell or wmic)'

if ($query_means -ne "wmic" -AND $query_means -ne "psinfo" -AND $query_means -ne "powershell")
{
do {
$query_means = read-host 'Invalid entry. Enter one of psinfo, powershell or wmic'
}
Until ($query_means -eq "wmic" -OR $query_means -eq "psinfo" -OR $query_means -eq "powershell")
}
#ask for the collection method. If the value is not entered correctly, loop until it is

if ($query_means -eq "wmic") {
cmd /c c:\temp\wmic_query.bat
}

if ($query_means -eq "powershell") {
invoke-expression -Command 'powershell /executionpolicy bypass /file c:\temp\software_enumeration.ps1'
}

if ($query_means -eq "psinfo") {
cmd /c c:\temp\psinfo.bat
}

# the above runs the proper commands depending on what the user has selected

$newest_file = Dir c:\temp\ | Sort CreationTime -Descending | Select Name -First 1
$new_filename = "c:\temp\"
$new_filename += $newest_file.name

# the above queries the directory where the files are stored, sorts by creation time and selects the newest one.
# the filename is stored in $newest_file.name location variable

$out_file= read-host 'Enter the output file name where you wish to store the comparison results. Please enter full path (e.g.
C:\temp\comparison.txt)'

# creating the output file name to use in the next commands

$temp1 = "baseline file "
$temp1 += $orig_file
$temp2 = "compare file "
$temp2 += $new_filename
$temp1 | out-file $out_file
$temp2 | out-file $out_file -append
#putting some details on the two files compared to the start of the output file

Compare-Object $(Get-Content $orig_file) $(Get-Content $new_filename) | out-file -filepath $out_file -append

#-append command used on outfile to not overwrite the existing file information we created above.

# run the compare-object commandlet to compare the two files. Output is redirected to the file the user entered

write-host 'The comparison file was saved at ' $out_file '.'

