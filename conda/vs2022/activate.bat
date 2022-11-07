:: Set env vars that tell distutils to use the compiler that we put on path
SET DISTUTILS_USE_SDK=1
SET MSSdk=1

SET "VS_VERSION=17.4"
SET "VS_MAJOR=17"
SET "VS_YEAR=2022"
SET "VC_VERSION_LOWER=17"
set "VC_VERSION_UPPER=18"

set "MSYS2_ARG_CONV_EXCL=/AI;/AL;/OUT;/out"
set "MSYS2_ENV_CONV_EXCL=CL"

:: For Python 3.5+, ensure that we link with the dynamic runtime.  See
:: http://stevedower.id.au/blog/building-for-python-3-5-part-two/ for more info
set "PY_VCRUNTIME_REDIST=%PREFIX%\\bin\\vcruntime143.dll"

if NOT "%VS15INSTALLDIR%" == "" if exist "%VS15INSTALLDIR%\VC\Auxiliary\Build\vcvarsall.bat" (
    set "VSINSTALLDIR=%VS15INSTALLDIR%\"
    goto :vswhere
)

for /f "usebackq tokens=*" %%i in (`"%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe" -legacy -products * -version [%VC_VERSION_LOWER%^,%VC_VERSION_UPPER%^) -property installationPath`) do (
    if exist "%%i" if exist "%%i\VC\Auxiliary\Build\vcvarsall.bat" (
        set "VSINSTALLDIR=%%i\"
        goto :vswhere
    )
)

:vswhere

:: Shorten PATH to avoid the `input line too long` error.
SET MyPath=%PATH%

setlocal EnableDelayedExpansion

SET TempPath="%MyPath:;=";"%"
SET var=
FOR %%a IN (%TempPath%) DO (
    IF EXIST %%~sa (
        SET "var=!var!;%%~sa"
    )
)

set "TempPath=!var:~1!"
endlocal & set "PATH=%TempPath%"

:: Shorten current directory too
FOR %%A IN (.) DO CD "%%~sA"

:: other things added by install_activate.bat at package build time
