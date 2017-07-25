setlocal EnableDelayedExpansion

mkdir build
cd build

cmake -G "NMake Makefiles" ^
    -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_BUILD_TYPE:STRING=Release ^
    -DCMAKE_POSITION_INDEPENDENT_CODE=1 ^
    ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

:: need to be in the root directory for this to run properly
cd ..
build\snappy-unittest
if errorlevel 1 exit 1
cd build

nmake install
if errorlevel 1 exit 1
