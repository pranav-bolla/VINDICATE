@echo off
echo Checking if script contains Administrative rights...
net sessions
if %errorlevel%==0 (
echo Success!
) else (
echo Please Run as Administrator...
echo.
pause
exit
)

cd 
:MENU
cls
echo Choose an option
echo.
echo SECURITY:					USERS:
echo.
echo 1 - Change Password Policies			10 - View Account Details
echo.
echo 2 - Change Audit Policies			11 - Change Account Passwords
echo.
echo 3 - List Services				12 - Enable/Disable Account
echo.
echo 4 - List Processes				13 - Add/Remove Administrator Priviledge
echo.
echo 5 - Enable Auto-Update				14 - Make User Records
echo.
echo 6 - Turn On Firewall			
echo.
echo 7 - Disable Remote Desktop
echo.
echo 8 - Find File Extension
echo.
echo 9 - System Integrity Scan
echo.
echo All created Files are located in C: unless specified
echo.
echo Made By Pranav Bolla
echo.
set /p A= Enter your choice:

if %A%== 1 goto Policy
if %A%== 2 goto Audit
if %A%== 3 goto Services
if %A%== 4 goto Processes
if %A%== 5 goto Update
if %A%== 6 goto Firewall
if %A%== 7 goto RDP
if %A%== 8 goto Find
if %A%== 9 goto Integrity
if %A%== 10 goto Acc
if %A%== 11 goto Pwd
if %A%== 12 goto EnDis
if %A%== 13 goto Admin
if %A%== 14 goto Record

:Policy
cls
echo CURRENT POLICY
echo.
net accounts
echo.
echo Changing Policy...
echo.
net accounts /minpwlen:10 /maxpwage:90 /minpwage:30 /uniquepw:5 /lockoutthreshold:5 /lockoutduration:30 /lockoutwindow:30
echo.
echo NEW POLICY
echo.
net accounts
echo.
pause
goto Menu

:Audit
cls
echo Setting Audit Policy (S + F ALL)
echo.
auditpol /set /category:* /success:enable
auditpol /set /category:* /failure:enable
echo Audit Policy has been set
echo.
pause
goto Menu

:Services
cd C:/
cls
net start > Services.txt
start Services.txt
echo Success
pause
goto Menu

:Processes
cd C:/
cls
wmic process list brief > Processes.txt
start Processes.txt
echo Success
pause
goto Menu

:Update
cls
echo Enabling Auto-Updates...
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v AUOptions /t REG_DWORD /d 4 /f
pause
goto Menu

:Firewall
cls
echo Turning on Firewall...
netsh advfirewall set allprofiles state on
pause
goto Menu

:RDP
cls
echo Disabling Remote Desktop...
echo.
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server" /v fDenyTSConnections /t REG_DWORD /d 1 /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Terminal Server\WinStations\RDP-Tcp" /v UserAuthentication /t REG_DWORD /d 0 /f
echo.
pause
goto Menu

:Find
cls
echo.

set "extension=dir"
set "path=dir"
set "Target=dir"
set "report=dir"

:Path1
set/p "path=Enter Path to search (e.g. C:\Users): "
goto :Extension1

:Extension1
echo.
set/p "extension=Enter Extension (e.g. *.jpg *.mp3 *.mp4 *.txt *.exe ...): "
goto :report

:report
echo.
set/p "report=Enter Report name (e.g. jpgExtension.txt): "
goto :Target

:Target
echo.
set/p "Target=Enter target of generated report (e.g. C:\Users\Pranav\Desktop): "
goto :Print1

:Print1
cd %path%
dir/s /a %extension% > "%Target%\%report%"
echo.
echo.
echo A report of all files of the specified extension and location can be found 
echo in the specified target.
echo.
start %Target%\%report%
pause
echo.
set /p Quit= "Would you like to go back to menu? y-Yes n-no:"
if %Quit% == y goto Menu
if %Quit% == n goto Find
goto Menu

:Integrity
cls
echo Starting System Integrity Scan...
sfc.exe /scannow
pause
goto Menu

:Acc
cls
wmic useraccount get name
echo.
set /p User= "Type the user account you wish to see the details of:"
net user %User%  
echo The user account information has been shown successfully
echo.
pause
echo.
set /p Quit= "Would you like to go back to menu? y-Yes n-no:"
if %Quit% == y goto Menu
if %Quit% == n goto Details
goto Menu

:Pwd
cls
echo.
wmic useraccount set passwordchangeable=true
echo.
wmic useraccount set passwordexpires=true
echo.
wmic useraccount set passwordrequired=true
echo.
pause
for /f "skip=1" %%a in ('wmic useraccount get name') do net user %%a HoCo*2020
echo.
Password for all users has been set to "HoCo*2020"
pause
goto Menu

:EnDis
cls
wmic useraccount get name,disabled 
echo.
set /p Status= "E-Enable or D-Disable:"
echo.
set /p User= "Type the user whose account you want to enable or disable:"
if %Status% == E net user %User% /active:yes
if %Status% == D net user %User% /active:no
echo.
echo The user account has been changed successfully
echo.
pause
echo.
set /p Quit= "Would you like to go back to menu? y-Yes n-no:"
if %Quit% == y goto Menu
if %Quit% == n goto EnDis
goto Menu

:Admin
cls
net localgroup Administrators
echo.
set /p Status= "A-Add or R-Remove from Administraor Group:"
set /p User= "Type the user whose account you want to add or remove from administrators:"
if %Status% == A net localgroup administrators %User% /add
if %Status% == R net localgroup administrators %User% /del
echo The group has been changed successfully
echo.
pause
echo.
set /p Quit= "Would you like to go back to menu? y-Yes n-no:"
if %Quit% == y goto Menu
if %Quit% == n goto Admin
goto Menu

:Record
cd C:\
cls
wmic useraccount > UserRecords.txt
echo.
start UserRecords.txt
echo Success
echo.
goto Menu
