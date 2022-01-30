echo off
cls

:start
set /p orig_file=Enter the full path and name of the baseline file for the computer to be audited:
REM getting the baseline file

echo You entered %orig_file%
echo.

if "%%~orig_file" == "" goto :start
REM if the file is blank, need to get a request again

if exist %orig_file% (
echo The file %orig_file% exists
goto :collection
REM Check to see if the file is there, if it is, allow things to continue

) else (
echo The file %orig_file% doesn't exist. Please enter a valid filename.
echo.
goto :start
and ask again for the filename
)

:collection

set /p query_means=Enter the collection method you wish to use to audit the information (type one of psinfo, PowerShell or wmic)
if "%query_means%"=="psinfo" (
       goto :psinfo
       )
if "%query_means%"=="powershell" (
       goto :powershell
       )
if "%query_means%"=="wmic" (
       goto :wmic
       )

REM checking for valid inputs and then going to the right location

echo you didn't enter a valid entry, please try again.
goto :collection

REM no valid value, go back and ask again

:wmic
call c:\temp\wmic_query.bat
rem need to use call command to run a script from within a script
goto :compare

:powershell
powershell /executionpolicy bypass /file c:\temp\software_enumeration.ps1
goto :compare

:psinfo
call C:\temp\psinfo.bat
goto :compare

:compare

REM now that we have the two files, need to compare them
for /f "delims=|" %%I in ('dir "c:\temp\*.*" /b /o:d') do set new_file=c:\temp\%%I

REM above finds the most recent file written to the directory, as if using PowerShell or psinfo, we cannot guarantee what the name is.
REM dir /o:d shows files in order oldest first. last value output from the command would be the newest file. We store that value for use

REM now that we have the old file, and the new file is created, we can compare. We are using the Windows command line program FC

set /p out_file=Enter the output file name that you wish to store the comparison results in. Please enter full path (e.g.
C:\temp\comparison.txt)

REM creating the output file name to use in the next comma

>%out_file% (
type %orig_file% > %orig_file%.v2
type %new_file% > %new_file%.v2

REM ensure that the files do not have any UNICODE entries in them. WMIC output stores in UNICODE. This ensures we don't touch the
originals.

fc /w %orig_file%.v2 %new_file%.v2
)

del %new_file%.v2
del %orig_file%.v2
REM clean up the temp files before leaving the script

echo The comparison results are stored in %out_file%
REM above we open the output file first, and then run the command we want in that file. Easiest way to capture command outputs

