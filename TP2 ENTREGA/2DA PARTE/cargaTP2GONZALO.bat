@Title OC2 - TP2 - Pesado , Vargas E2
@echo.
@Echo  -----------------------------------------------------------
@Echo  --Bienvenido al programa de compilacion de codigo fuente!--
@Echo  -----------------------------------------------------------
@echo.
@set RutaBAT=%~d0%~p0
@set RutaNASM="C:\Program Files\NASM\" 
@set RutaGCC="C:\Program Files (x86)\CodeBlocks\MinGW\bin"

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
@nasm -f win32 -o "%RutaBAT%funcionesASM_TP2_E2.obj" "%RutaBAT%funcionesASM_TP2_E2.asm" 
@ECHO OBJ CREADO CON EXITO!
@echo.

@echo CREANDO EJECUTABLE A PARTIR DE LOS ARCHIVOS DE CODIGO FUENTE
@cd /d %RutaGCC%
@gcc -Wall -m32 -o "%RutaBAT%TP2E2_OC2_PESADO_VARGAS.exe" "%RutaBAT%funcionesASM_TP2_E2.obj" "%RutaBAT%Superponer.c"  
@echo EJECUTABLE CREADO CON EXITO EN %RutaBAT%
@echo.

@cd  /d %RutaBAT%
@ECHO ELIMINANDO ARCHIVOS TEMPORALES

@rem del /f /q funcionesASM_TP2_E2.obj
@ECHO ARCHIVOS TEMPORALES ELIMINADOS! 
@echo.

@Echo  ------------------------------------------------------------------
@ECHO  --PRESIONE UNA TECLA PARA COMENZAR LA 1RA EJECUCION DEL PROGRAMA--
@Echo  ------------------------------------------------------------------
@echo.
@PAUSE > nul

@ECHO EJECUTANDO TP2E2_OC2_PESADO_VARGAS.exe , DESDE %RutaBAT%
@ECHO PREPARANDO APLICACION PARA LA PRIMERA EJECUCION...
@ECHO PREPARANDO APLICACION PARA LA PRIMERA EJECUCION..
@ECHO PREPARANDO APLICACION PARA LA PRIMERA EJECUCION.
@echo.
@ECHO LISTO!, EJECUTANDO...
@echo.
@echo.

@echo EJECUTANDO SUPERPOSICION.....
@TP2E2_OC2_PESADO_VARGAS imagen1.rgb imagen2.rgb 256 256 120 240 100 50 resultado.rgb
@rem gm convert -size 256x256 -depth 8 resultado.rgb win:
@echo.
@echo.
@ECHO MUCHAS GRACIAS POR UTILIZAR EL PROGRAMA!!
@ECHO RECUERDE QUE LA APLICACION ESTA EN %RutaBAT%
@echo.
@ECHO PRESIONE UNA TECLA PARA SALIR!!!
@PAUSE > nul
@CLS
EXIT