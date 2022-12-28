@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
COLOR A
CLS
SET reg_path="HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
GOTO :RawData

:Menu
CLS
ECHO [94m################################################[0m
ECHO [94m#[0m[95m _____     _ _          _[0m[92m _____         _     [0m[94m#[0m
ECHO [94m#[0m[95m^|  ___^|_ _^(_^) ^| ___  __^|[0m[92m ^|_   _^|__  ___^| ^|__  [0m[94m#[0m
ECHO [94m#[0m[95m^| ^|_ / _` ^| ^| ^|/ _ \/ _` ^|[0m[92m ^| ^|/ _ \/ __^| '_ \ [0m[94m#[0m
ECHO [94m#[0m[95m^|  _^| ^(_^| ^| ^| ^|  __/ ^(_^| ^|[0m[92m ^| ^|  __/ ^(__^| ^| ^| ^|[0m[94m#[0m
ECHO [94m#[0m[95m^|_^|  \__,_^|_^|_^|\___^|\__,_^|[0m[92m ^|_^|\___^|\___^|_^| ^|_^|[0m[94m#[0m
ECHO [94m#[0m[93m                                              [0m[94m#[0m
ECHO [94m#[0m[93m              Windows Auto Logon              [0m[94m#[0m
ECHO [94m#[0m[93m                      v1.0                    [0m[94m#[0m
ECHO [94m#[0m[93m             Powered By [35mFailed[0m[32mTech[0m            [0m[94m#[0m
ECHO [94m#[0m[31m         [0m[92m(C)[0m[31m 2022 All Rights Reserved         [0m[94m#[0m
ECHO [94m################################################[0m
ECHO [33m[1][0m [32mInput Data[0m
ECHO [33m[2][0m [94mDefaultUserName =[0m[35m %DUN% [0m
ECHO [33m[3][0m [94mDefaultPassword =[0m[35m %DP% [0m
ECHO [33m[4][0m [94mDefaultDomainName =[0m[35m %DDN% [0m
ECHO [33m[5][0m [32mADD Registry Keys[0m
ECHO [33m[6][0m [32mRemove Registry Keys[0m
ECHO [33m[7][0m [32mReset[0m
ECHO [33m[0][0m [31mEXIT[0m
CHOICE /C 12345670 /N /M "[#] Choose a menu option, or press 0 to Exit:"
GOTO :UserInput

:UserInput
IF %ERRORLEVEL%==1 (
CAll :DefaultUserName
CAll :DefaultPassword
CAll :DefaultDomainName
GOTO :Menu
) 
IF %ERRORLEVEL%==2 (
    CAll :DefaultUserName
    GOTO :Menu
)
IF %ERRORLEVEL%==3 (
    CAll :DefaultPassword
    GOTO :Menu
)
IF %ERRORLEVEL%==4 (
    CAll :DefaultDomainName
    GOTO :Menu
)
IF %ERRORLEVEL%==5 (
    CAll :AddReg
    GOTO :Menu
)
IF %ERRORLEVEL%==6 (
    CAll :RMReg
    GOTO :Menu
)
IF %ERRORLEVEL%==7 GOTO :RawData
IF %ERRORLEVEL%==8 (
    EXIT /B %ERRORLEVEL% REM GOTO :EOF is the same as exit /b 0
)
GOTO :Menu

:RawData
SET DUN="Not Set"
SET DP="Not Set"
SET DDN="Not Set"
GOTO :Menu

:DefaultUserName
ECHO Enter Your DefaultUserName
SET /P DUN=  & ::prompt for DefaultUserName input
IF %DUN%=="Not Set" GOTO :DefaultUserName
GOTO :EOF

:DefaultPassword
ECHO Enter Your DefaultPassword
SET /P DP=  & REM prompt for DefaultUserName input
IF %DP%=="Not Set" GOTO :DefaultPassword
GOTO :EOF

:DefaultDomainName
ECHO Enter Your DefaultDomainName
SET /P DDN=  & REM prompt for DefaultDomainName input
GOTO :EOF

:AddReg
IF %DUN%=="Not Set" CAll :DefaultUserName
IF %DP%=="Not Set" CAll :DefaultPassword
IF %DDN%=="Not Set" CAll :DefaultDomainName

REM > nul Redirect the output to nul
REM > nul 2> nul Redirect Errors to nul

reg add %reg_path% /f /v "DefaultUserName" /d %DUN% > nul 2> nul && (
     ECHO [92mSuccessfully added DefaultUserName[0m ) || ( ECHO [91mFailed to add DefaultUserName[0m )
reg add %reg_path% /f /v "DefaultPassword" /d %DP% > nul 2> nul && (
     ECHO [92mSuccessfully added DefaultPassword[0m ) || ( ECHO [91mFailed to add DefaultPassword[0m )
reg add %reg_path% /f /v "AutoAdminLogon" /d "1" > nul 2> nul && (
     ECHO [92mSuccessfully added AutoAdminLogon[0m ) || ( ECHO [91mFailed to add AutoAdminLogon[0m )
IF %DDN%=="Not Set" ( 
    reg query %reg_path% /v "DefaultDomainName" > nul 2> nul && (
         ECHO [91mDefaultDomainName Key Found ,Trying to remove it[0m
         reg delete %reg_path% /f /v "DefaultDomainName" > nul 2> nul && (
         ECHO [92mSuccessfully removed DefaultDomainName[0m ) || ( 
            ECHO [91mFailed to remove DefaultDomainName[0m )
            ) || ( ECHO [91mDefaultDomainName Key Not Found[0m )
) ELSE (
    reg add %reg_path% /f /v "DefaultDomainName" /d %DDN% > nul 2> nul && (
         ECHO [92mSuccessfully added DefaultDomainName[0m ) || ( ECHO [91mFailed to add DefaultDomainName[0m )
)
PAUSE
EXIT /B 0

:RMReg
reg delete %reg_path% /f /v "DefaultUserName" > nul 2> nul && (
     ECHO [92mSuccessfully removed DefaultUserName[0m ) || ( ECHO [91mFailed to remove DefaultUserName[0m )
reg delete %reg_path% /f /v "DefaultPassword" > nul 2> nul && (
     ECHO [92mSuccessfully removed DefaultPassword[0m ) || ( ECHO [91mFailed to remove DefaultPassword[0m )
reg delete %reg_path% /f /v "DefaultDomainName" > nul 2> nul && (
     ECHO [92mSuccessfully removed DefaultUserName[0m ) || ( ECHO [91mFailed to remove DefaultDomainName[0m )
reg delete %reg_path% /f /v "AutoAdminLogon" > nul 2> nul && (
     ECHO [92mSuccessfully removed AutoAdminLogon[0m ) || ( ECHO [91mFailed to remove AutoAdminLogon[0m )
PAUSE
EXIT /B 0