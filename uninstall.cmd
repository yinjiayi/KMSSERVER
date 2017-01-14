@echo off

set KeyName=kmsserverservice

sc query %KeyName%>nul 2>nul
if errorlevel 1 exit/b %errorlevel%

sc start %KeyName%>nul 2>nul

for /f "usebackq delims=: tokens=2" %%A in (`sc queryex %KeyName%^|find/i "PID"`) do set PID=%%~A

for /f "usebackq delims== tokens=2" %%A in (`wmic process where "processid=%PID%" get ExecutablePath /value^|findstr /b /i "ExecutablePath"`) do (
	set ExecutablePath=%%~A
	set dp=%%~dpA
)

echo=

sc stop %KeyName%>nul 2>nul
timeout/nobreak /t 1 >nul
sc delete %KeyName%

del /a/f/q "%ExecutablePath%"
rd/q "%dp%"

setlocal EnableDelayedExpansion

for /l %%Z in (1,1,14) do (
	for /f "delims=" %%A in ("!dp!.") do (
		if "%%~pA"=="\" exit/b
		rd "%%~dpA" 2>nul
		set dp=%%~dpA
	)
)

ENDLOCAL
