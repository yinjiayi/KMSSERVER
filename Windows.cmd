@echo off

Setlocal EnableDelayedExpansion

set KeyName=KMSServerService

sc query %KeyName%>nul 2>nul

if errorlevel 1 (
	call "%~dp0Install KMSEmulator" "%~1"
	sc create %KeyName% binPath= "!AppFolder!\KMS Server Service.exe" start= auto DisplayName= "KMS Server Service"
	sc description %KeyName% "Windows Service that emulates a Key Management Service (KMS) Server"
	sc config %KeyName% start= delayed-auto 2>nul
	reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%KeyName%\Parameters /f /v "KMSPID" /d "RandomKMSPID"
	reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%KeyName%\Parameters /f /v "KMSPort" /d "1688"
	reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%KeyName%\Parameters /f /v "KillProcessOnPort" /d "1" /t reg_dword
	reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%KeyName%\Parameters /f /v "VLRenewalInterval" /d "10080" /t reg_dword
	reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\%KeyName%\Parameters /f /v "VLActivationInterval" /d "120" /t reg_dword
) else if errorlevel 0 (
	echo KMS Server Service has existed.
)   
,
sc start %KeyName%>nul 2>nul
