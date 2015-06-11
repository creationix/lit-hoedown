
@SET LUAJIT_OS=Windows
@SET LUAJIT_ARCH=x64
@SET TARGET_DIR=%LUAJIT_OS%-%LUAJIT_ARCH%
@SET LIT_PATH=C:\Code\lit.exe
@SET LUVI_PATH=C:\Code\luvi.exe
@SET HOEDOWN_DIR=%~d0%~p0

@SET HOEDOWN_LIB=hoedown.dll

@if not "x%1" == "x" GOTO :%1

:compile
@IF NOT EXIST build CALL make.bat configure
cmake --build build --config Release || GOTO :end
MKDIR %TARGET_DIR%
COPY build\Release\%HOEDOWN_LIB% %TARGET_DIR%\
@GOTO :end

:configure
@IF NOT EXIST hoedown\src git submodule update --init hoedown
cmake -Bbuild -H. -G"Visual Studio 12 Win64" || GOTO :end
@GOTO :end

:setup
cd hoedown-sample
%LIT_PATH% install || GOTO :end
RMDIR /S /Q deps\hoedown
mklink /j deps\hoedown %HOEDOWN_DIR%
cd ..
@GOTO :end

:test
@CALL make.bat compile
@IF NOT EXIST hoedown-sample git submodule update --init hoedown-sample
@IF NOT EXIST hoedown-sample\deps CALL make.bat setup
%LUVI_PATH% hoedown-sample || GOTO :end
@GOTO :end

:clean
rmdir /S /Q build hoedown-sample\deps
@GOTO :end

:end
