setlocal EnableDelayedExpansion

:: Remove -GL from CXXFLAGS as this causes a fatal error
set "CFLAGS= -MD"
set "CXXFLAGS= -MD"

mkdir build-dynamic
cd build-dynamic

cmake -G "NMake Makefiles" ^
    -DCMAKE_INSTALL_PREFIX:PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_PREFIX_PATH:PATH="%LIBRARY_PREFIX%" ^
    -DCMAKE_BUILD_TYPE:STRING=Release ^
    -DBUILD_SHARED_LIBS=ON ^
    ..
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

:: need to be in the root directory for this to run properly
cd ..
build-dynamic\snappy_unittest
if errorlevel 1 exit 1
cd build-dynamic

nmake install
if errorlevel 1 exit 1

cd ..
