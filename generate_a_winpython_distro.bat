rem  to launch from a winpython package directory, where 'make.py' is
@echo on

rem *****************************
rem 2019-05-10 PATCH for build problem (asking permission to overwrite the file)
rem 
rem *****************************
del -y %userprofile%\.jupyter\jupyter_notebook_config.py


rem ******************************


rem  this is initialised per the calling .bat
rem  set my_original_path=%path%
rem  set my_buildenv=C:\WinPython-64bit-3.4.3.7Qt5
rem  set my_root_dir_for_builds=D:\Winp

rem  set my_python_target=34
rem  set my_pyver=3.4
rem  set my_release=84

rem *****************************
rem v2 2016-03-19 change 
rem we don't use building rootdir (D:\winPython) anymore
rem we use only building basedir (D:\WinPython\basedir34Qt5)  

set my_basedir=%my_root_dir_for_builds%\bd%my_python_target%
rem set my_basedir=%my_root_dir_for_builds%\build%my_python_target%\%my_arch%

rem ***********************************************************
rem Override other scripts (simpler maintenance)

set my_buildenv=C:\winpython-64bit-3.4.3.7Qt5

rem handle alpha
if "%my_release_level%"=="" set my_release_level=b1
if %my_python_target%==38 set my_release_level=

rem ---------
rem newAge 20191022
rem install with zero package, no installer, then do it from there
rem change is we must help by giving my_python_target_release
rem --------

if %my_python_target%==37 (
   set my_python_target_release=375
   set my_release=0
)
if %my_python_target%==38 (
   set my_python_target_release=380
   set my_release=0
)

rem **** 2018-10-30 create_installer **
if "%my_create_installer%"=="" set my_create_installer=True
rem ***********************************************************

rem  set my_flavor=Slim

rem  set my_arch=32
rem  set my_preclear_build_directory=Yes

rem  set my_requi=C:\Winpents=d:\my_req1.txt d:\my_req2.txt d:\my_req3.txt  d:\my_req4.txt
rem  set my_find_links=D:\WinPython\packages.srcreq

rem  set my_source_dirs=D:\WinPython\bd34\packages.src D:\WinPython\bd34\packages.win32.Slim
rem  set my_toolsdirs=D:\WinPython\bd34\Tools.Slim
rem  set my_docsdirs=D:\WinPython\bd34\docs.Slim


rem  set my_install_options=--no-index --pre

set my_day=%date:/=-%
set my_time=%time:~0,5%
set my_time=%my_time::=_%

rem  was the bug 
set my_time=%my_time: =0%

set my_archive_dir=%~dp0WinPython_build_logs
if not exist %my_archive_dir% mkdir %my_archive_dir%

set my_archive_log=%my_archive_dir%\build_%my_pyver%._.%my_release%%my_flavor%_%my_release_level%_of_%my_day%_at_%my_time%.txt


echo ===============
echo preparing winpython for %my_pyver% (%my_python_target%)release %my_release%%my_flavor% (%my_release_level%) *** %my_arch% bit *** 
echo %date% %time%
echo ===============
echo ===============>>%my_archive_log%
echo preparing winpython for %my_pyver% (%my_python_target%)release %my_release%%my_flavor% (%my_release_level%) *** %my_arch% bit ***>>%my_archive_log%
echo %date% %time%>>%my_archive_log%
echo ===============>>%my_archive_log%


if not "%my_preclear_build_directory%"=="Yes" goto no_preclear

echo ------------------>>%my_archive_log%
echo 1.0 Do Pre-clear  >>%my_archive_log%
echo ------------------>>%my_archive_log%


cd /D  %my_root_dir_for_builds%\bd%my_python_target%

set build_det=\%my_flavor%
if "%my_flavor%"=="" set build_det=

dir %build_det%
echo rmdir /S /Q bu%my_flavor%
rem  pause
rmdir /S /Q bu%my_flavor%
rmdir /S /Q bu%my_flavor%
rmdir /S /Q bu%my_flavor%
rmdir /S /Q bu%my_flavor%
rmdir /S /Q bu%my_flavor%
rmdir /S /Q dist

echo %date% %time%
echo %date% %time%>>%my_archive_log%

:no_preclear


echo ------------------>>%my_archive_log%
echo 2.0 Create a build>>%my_archive_log%
echo ------------------>>%my_archive_log%


echo cd /D %~dp0>>%my_archive_log%
cd /D %~dp0

echo set path=%my_original_path%>>%my_archive_log%
set path=%my_original_path%

echo call %my_buildenv%\scripts\env.bat>>%my_archive_log%
call %my_buildenv%\scripts\env.bat

echo ----------------------------->>%my_archive_log%
echo 2.0 Create a build newage1/3 >>%my_archive_log%
echo ----------------------------->>%my_archive_log%

rem 2019-10-22 new age step1
rem we don't use requirements 
rem we don't create installer at first path
rem we use legacy python build cd /D %~dp0

set my_buildenv_path=%path%

echo python.exe  -c "from make import *;make_all(%my_release%, '%my_release_level%', pyver='%my_pyver%', basedir=r'%my_basedir%', verbose=True, architecture=%my_arch%, flavor='%my_flavor%', install_options=r'%my_install_options%', find_links=r'%my_find_links%', source_dirs=r'%my_source_dirs%', toolsdirs=r'%my_toolsdirs%', docsdirs=r'%my_docsdirs%', create_installer='False')">>%my_archive_log%
python.exe  -c "from make import *;make_all(%my_release%, '%my_release_level%', pyver='%my_pyver%', basedir=r'%my_basedir%', verbose=True, architecture=%my_arch%, flavor='%my_flavor%', install_options=r'%my_install_options%', find_links=r'%my_find_links%', source_dirs=r'%my_source_dirs%', toolsdirs=r'%my_toolsdirs%', docsdirs=r'%my_docsdirs%', create_installer='False')">>%my_archive_log%

rem old one
rem echo python.exe  -c "from make import *;make_all(%my_release%, '%my_release_level%', pyver='%my_pyver%', basedir=r'%my_basedir%', verbose=True, architecture=%my_arch%, flavor='%my_flavor%', requirements=r'%my_requirements%', install_options=r'%my_install_options%', find_links=r'%my_find_links%', source_dirs=r'%my_source_dirs%', toolsdirs=r'%my_toolsdirs%', docsdirs=r'%my_docsdirs%', create_installer='%my_create_installer%')">>%my_archive_log%


echo ----------------------------->>%my_archive_log%
echo 2.0 Create a build newage2/3 >>%my_archive_log%
echo ----------------------------->>%my_archive_log%
rem 2019-10-22 new age step2
rem we use final environment to install requirements
set path=%my_original_path%

@echo on
set my_WINPYDIRBASE=%my_root_dir_for_builds%\bd%my_python_target%\bu%my_flavor%\Wpy%my_arch%-%my_python_target_release%%my_release%%my_release_level%

set WINPYDIRBASE=%my_WINPYDIRBASE% 
call %my_WINPYDIRBASE%\scripts\env.bat
set
echo beg of step 2/3
rem ok no pause 

echo pip install -r %my_requirements% --pre  --no-index --trusted-host=None  --find-links=C:\WinP\packages.srcreq  --upgrade
pip install -r %my_requirements% --pre  --no-index --trusted-host=None  --find-links=C:\WinP\packages.srcreq  --upgrade >>%my_archive_log%
echo mid of step 2/3
rem pause

rem finalize
@echo on
call  %my_basedir%\run_complement_newbuild.bat %my_WINPYDIRBASE%
echo end of step 2/3
rem pause

echo ----------------------------->>%my_archive_log%
echo 2.0 Create a build newage3/3 >>%my_archive_log%
echo ----------------------------->>%my_archive_log%

rem build final changelog and binaries, using create_installer='%my_create_installer%', remove_existing=False , remove : requirements, toolsdirs and docdirs

set path=%my_original_path%
echo cd /D %~dp0>>%my_archive_log%
cd /D %~dp0

echo call %my_buildenv%\scripts\env.bat>>%my_archive_log%
call %my_buildenv%\scripts\env.bat
set

echo python.exe  -c "from make import *;make_all(%my_release%, '%my_release_level%', pyver='%my_pyver%', basedir=r'%my_basedir%', verbose=True, architecture=%my_arch%, flavor='%my_flavor%', install_options=r'%my_install_options%', find_links=r'%my_find_links%', source_dirs=r'%my_source_dirs%', create_installer='%my_create_installer%', remove_existing=False)">>%my_archive_log%
python.exe  -c "from make import *;make_all(%my_release%, '%my_release_level%', pyver='%my_pyver%', basedir=r'%my_basedir%', verbose=True, architecture=%my_arch%, flavor='%my_flavor%', install_options=r'%my_install_options%', find_links=r'%my_find_links%', source_dirs=r'%my_source_dirs%', create_installer='%my_create_installer%', remove_existing=False)">>%my_archive_log%

echo ===============>>%my_archive_log%
echo END OF creation>>%my_archive_log%
echo %date% %time%  >>%my_archive_log%
echo ===============>>%my_archive_log%

set path=%my_original_path%
rem pause