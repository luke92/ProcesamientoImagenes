@Title OC2 - TP2 - Pesado , Vargas
@echo.
@Echo  -----------------------------------------------------------
@Echo  --Bienvenido al programa de compilacion de codigo fuente!--
@Echo  -----------------------------------------------------------
@echo.
@set RutaBAT=%~d0%~p0
@set RutaNASM="C:\Program Files\NASM\" 
@set RutaGCC="C:\MinGW\bin"

@ping localhost -n 2 >nul
@echo LAS RUTAS USADAS PARA COMPILAR LA APLICACION SERAN:
@Echo  ---------------------------------------------------------
@echo RUTA DE LOS ARCHIVOS FUENTE = %RutaBAT%
@echo RUTA DE NASM = %RutaNASM%
@echo RUTA DE GCC = %RutaGCC%
@echo RUTA DEL EJECUTABLE FINAL = %RutaBAT%
@echo.

@Echo  -----------------------------------------------------------
@ECHO  --PRESIONE UNA TECLA PARA COMENZAR A COMPILAR EL PROGRAMA--
@Echo  -----------------------------------------------------------
@PAUSE > nul

@cd /d %RutaNASM%
@echo CREANDO OBJ DE ASM
@nasm -f win32 -o "%RutaBAT%fuenteASM.obj" "%RutaBAT%funcionesASM.asm" 
@ECHO OBJ CREADO CON EXITO!
@cd /d %RutaGCC%
@echo.

@echo CREANDO EJECUTABLE A PARTIR DE LOS ARCHIVOS DE CODIGO FUENTE
@ gcc -Wall -m32 -o "%RutaBAT%TP2E1_OC2_PESADO_VARGAS.exe" "%RutaBAT%fuenteASM.obj" "%RutaBAT%Interpolar.c"  
@echo EJECUTABLE CREADO CON EXITO EN %RutaBAT%
@echo.

@cd  /d %RutaBAT%
@ECHO ELIMINANDO ARCHIVOS TEMPORALES
@ping localhost -n 3 >nul
@del /f /q fuenteASM.obj
@ECHO ARCHIVOS TEMPORALES ELIMINADOS! 
@echo.

@Echo  ------------------------------------------------------------------
@ECHO  --PRESIONE UNA TECLA PARA COMENZAR LA 1RA EJECUCION DEL PROGRAMA--
@Echo  ------------------------------------------------------------------
@echo.
@PAUSE > nul

@ECHO EJECUTANDO TP2E1_OC2_PESADO_VARGAS.exe , DESDE %RutaBAT%
@ECHO PREPARANDO APLICACION PARA LA PRIMERA EJECUCION...
@ECHO PREPARANDO APLICACION PARA LA PRIMERA EJECUCION..
@ECHO PREPARANDO APLICACION PARA LA PRIMERA EJECUCION.
@echo.
@ECHO LISTO!, EJECUTANDO...
@echo.
@echo.

@echo EJECUTANDO INTERPOLACION.....
@TP2E1_OC2_PESADO_VARGAS imagen1.rgb imagen2.rgb 256 256 0.3 resultado0.3.rgb
@gm convert -size 256x256 -depth 8 resultado0.3.rgb win:
@TP2E1_OC2_PESADO_VARGAS imagen1.rgb imagen2.rgb 256 256 0.5 resultado0.5.rgb
@gm convert -size 256x256 -depth 8 resultado0.5.rgb win:
@TP2E1_OC2_PESADO_VARGAS imagen1.rgb imagen2.rgb 256 256 0.7 resultado0.7.rgb
@gm convert -size 256x256 -depth 8 resultado0.7.rgb win:
@echo.
@echo.
@ECHO MUCHAS GRACIAS POR UTILIZAR EL PROGRAMA!!
@ECHO RECUERDE QUE LA APLICACION ESTA EN %RutaBAT%
@echo.
@ECHO PRESIONE UNA TECLA PARA SALIR!!!
@PAUSE > nul
@CLS
EXIT