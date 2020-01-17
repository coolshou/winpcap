@echo OFF

set BAT=%0
set sCMD=%1

echo cmd %sCMD%
if "%sCMD%" NEQ "" (
  if "%sCMD%" NEQ "clean" (
	if "%sCMD%" NEQ "build" (
		call :Pack
	) else (
		call :Build
	)
  ) else (
	call :Clean
  )
) else (
  call :Help
)
exit /b

:Help
echo =====%BAT% usage===============
echo  %BAT% build : build x86/x64 
echo  %BAT%  : clean build
echo ===================================
exit /b

:Build
set LIB=""
set LIBPATH=""
set INCLUDE=""
set Path="%SystemRoot%\System32\"
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
MSBuild winpcap.sln /m /t:Rebuild /p:Configuration=Release /p:Platform=Win32

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
MSBuild winpcap.sln /m /t:Rebuild /p:Configuration=Release /p:Platform=x64

exit /b

:Pack
echo "call build"
call :Build

echo "packing..."
set WPDPACKDESTDIR=..\
set WINPCAPSOURCEDIR=.\
REM LIB
REM mkdir %WPDPACKDESTDIR%  		2>nul >nul
IF not exist %WPDPACKDESTDIR%\Lib (
	mkdir %WPDPACKDESTDIR%\Lib  	2>nul >nul
)
IF not exist %WPDPACKDESTDIR%\Lib\x64 (
	mkdir %WPDPACKDESTDIR%\Lib\x64  	2>nul >nul
)

xcopy /v /Y %WINPCAPSOURCEDIR%\Release_No_NetMon\x86\packet.lib	 	%WPDPACKDESTDIR%\Lib\ >nul
xcopy /v /Y %WINPCAPSOURCEDIR%\Release_No_NetMon\x64\packet.lib	 	%WPDPACKDESTDIR%\Lib\x64 >nul
xcopy /v /Y %WINPCAPSOURCEDIR%\Release_No_AirPcap\x86\wpcap.lib		%WPDPACKDESTDIR%\Lib\ >nul
xcopy /v /Y %WINPCAPSOURCEDIR%\Release_No_AirPcap\x64\wpcap.lib		%WPDPACKDESTDIR%\Lib\x64 >nul
REM xcopy /v /Y Release_No_NetMon\x86\libpacket.a		%WPDPACKDESTDIR%\Lib\	>nul
REM xcopy /v /Y Release_No_NetMon\x64\libpacket.a		%WPDPACKDESTDIR%\Lib\x64	>nul
REM xcopy /v /Y Release_No_AirPcap\x86\libwpcap.a		%WPDPACKDESTDIR%\Lib\ >nul
REM xcopy /v /Y Release_No_AirPcap\x64\libwpcap.a		%WPDPACKDESTDIR%\Lib\x64 >nul

REM DLL
xcopy /v /Y %WINPCAPSOURCEDIR%\Release_No_NetMon\x86\packet.dll	 	%WPDPACKDESTDIR%\Lib\ >nul
xcopy /v /Y %WINPCAPSOURCEDIR%\Release_No_NetMon\x64\packet.dll	 	%WPDPACKDESTDIR%\Lib\x64 >nul
xcopy /v /Y %WINPCAPSOURCEDIR%\Release_No_AirPcap\x86\wpcap.dll		%WPDPACKDESTDIR%\Lib\ >nul
xcopy /v /Y %WINPCAPSOURCEDIR%\Release_No_AirPcap\x64\wpcap.dll		%WPDPACKDESTDIR%\Lib\x64 >nul

REM include
IF not exist %WPDPACKDESTDIR%\Include (
	mkdir %WPDPACKDESTDIR%\Include  	2>nul >nul
)
IF not exist %WPDPACKDESTDIR%\Include\pcap (
	mkdir %WPDPACKDESTDIR%\Include\pcap  	2>nul >nul
)

xcopy /v /Y %WINPCAPSOURCEDIR%\wpcap\libpcap\pcap\*.h		 		%WPDPACKDESTDIR%\Include\pcap\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\wpcap\libpcap\pcap.h			 	%WPDPACKDESTDIR%\Include\	>nul
rem xcopy /v /Y %WINPCAPSOURCEDIR%\wpcap\libpcap\pcap-int.h			%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\wpcap\libpcap\pcap-bpf.h		 		%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\wpcap\libpcap\pcap-namedb.h	 		%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\wpcap\libpcap\remote-ext.h		 	%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\wpcap\libpcap\pcap-stdinc.h		 	%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\wpcap\Win32-Extensions\Win32-Extensions.h 	%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\wpcap\libpcap\Win32\Include\bittypes.h 		%WPDPACKDESTDIR%\Include\	>nul	 
xcopy /v /Y %WINPCAPSOURCEDIR%\wpcap\libpcap\Win32\Include\ip6_misc.h		%WPDPACKDESTDIR%\Include\	>nul
rem TME stuff
xcopy /v /Y %WINPCAPSOURCEDIR%\packetNtx\driver\bucket_lookup.h	 		%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\packetNtx\driver\count_packets.h	 		%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\packetNtx\driver\memory_t.h		 	%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\packetNtx\driver\normal_lookup.h	 		%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\packetNtx\driver\tcp_session.h		 	%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\packetNtx\driver\time_calls.h		 	%WPDPACKDESTDIR%\Include\	>nul
xcopy /v /Y %WINPCAPSOURCEDIR%\packetNtx\driver\tme.h			 	%WPDPACKDESTDIR%\Include\	>nul
REM
xcopy /v /Y %WINPCAPSOURCEDIR%\Common\Packet32.h			 	%WPDPACKDESTDIR%\Include\	>nul

echo "packing end"

exit /b

:Clean
set LIB=""
set LIBPATH=""
set INCLUDE=""
set Path="%SystemRoot%\System32\"
call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
MSBuild winpcap.sln /m /t:clean /p:Configuration=Release /p:Platform=Win32

call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
MSBuild winpcap.sln /m /t:clean /p:Configuration=Release /p:Platform=x64

REM remove target files
RMDIR /S /Q %WPDPACKDESTDIR%\Include
RMDIR /S /Q %WPDPACKDESTDIR%\Lib

exit /b
