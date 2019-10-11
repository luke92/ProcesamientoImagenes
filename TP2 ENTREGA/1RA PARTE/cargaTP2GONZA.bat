@Title OC2 - TP2 (PARTE 1) - Pesado , Vargas
@echo.
@echo  -----------------------------------------------------------
@echo  --Bienvenido al programa de compilacion de codigo fuente!--
@echo  -----------------------------------------------------------
@echo.
@set RutaBAT=%~d0%~p0
@set RutaNASM="C:\Users\Gonza\AppData\Local\bin\NASM" 
@set RutaGCC="C:\Program Files\CodeBlocks\MinGW\bin"

@REM  **********ESTOS PARAMETROS SON LOS CONFIGURABLES ************
@REM  *
@echo LAS RUTAS USADAS PARA COMPILAR LA APLICACION SERAN:			
@echo  ---------------------------------------------------------	
@echo RUTA DE LOS ARCHIVOS FUENTE = %RutaBAT%						
@echo RUTA DE NASM = %RutaNASM%
@echo RUTA DE GCC = %RutaGCC%
@echo RUTA DEL EJECUTABLE FINAL = %RutaBAT%
@echo.
@REM  *
@REM  *************************************************************

@echo  -----------------------------------------------------------
@echo  --PRESIONE UNA TECLA PARA COMENZAR A COMPILAR EL PROGRAMA--
@echo  -----------------------------------------------------------
@PAUSE > nul

@cd /d %RutaNASM%
@echo CREANDO OBJ DE ASM
@nasm -f win32 -o "%RutaBAT%fuenteASM.obj" "%RutaBAT%funcionesASM.asm" 
@echo OBJ CREADO CON EXITO!
@cd /d %RutaGCC%
@echo.

@echo CREANDO EJECUTABLE A PARTIR DE LOS ARCHIVOS DE CODIGO FUENTE
@ gcc -m32 -o "%RutaBAT%TP2_OC2_PESADO_VARGAS.exe" "%RutaBAT%fuenteASM.obj" "%RutaBAT%Interpolar.c"  
@echo EJECUTABLE CREADO CON EXITO EN %RutaBAT%
@echo.

@cd  /d %RutaBAT%
@echo ELIMINANDO ARCHIVOS TEMPORALES
@del /f /q fuenteASM.obj
@echo ARCHIVOS TEMPORALES ELIMINADOS! 
@echo.

@echo  ------------------------------------------------------------------
@echo  --PRESIONE UNA TECLA PARA COMENZAR LA 1RA EJECUCION DEL PROGRAMA--
@echo  ------------------------------------------------------------------
@echo.
@PAUSE > nul

@echo EJECUTANDO TP2_OC2_PESADO_VARGAS.exe , DESDE %RutaBAT%
@echo PREPARANDO APLICACION PARA LA PRIMERA EJECUCION...
@ping localhost -n 2 >nul
@echo.
@echo.

@REM 					 INTERPOLACION 1
@gm convert rojo200x200.png rojo200x200.rgb
@gm convert verde200x200.png verde200x200.rgb

@echo EJECUTANDO INTERPOLACION rojo200x200 y verde200x200 p = 0,5 ...
@TP2_OC2_PESADO_VARGAS rojo200x200.rgb verde200x200.rgb 200 200 0.5 InterpolarImagenResultado.rgb
@gm convert -size 200x200 -depth 8 InterpolarImagenResultado.rgb win:
@echo.
@echo  ------------------------------------------------------------------
@echo  --PRESIONE UNA TECLA PARA INTERPOLAR LA SEGUNDA IMAGEN          --
@echo  ------------------------------------------------------------------
@echo.
@PAUSE > nul

@REM                     INTERPOLACION 2
@gm convert InterpolarImagen1.png InterpolarImagen1.rgb
@gm convert InterpolarImagen2.png InterpolarImagen2.rgb

@echo EJECUTANDO INTERPOLACION InterpolarImagen1 y InterpolarImagen2 p = 0,5 ...
@TP2_OC2_PESADO_VARGAS InterpolarImagen1.rgb InterpolarImagen2.rgb 300 300 0.3 InterpolarImagenResultado.rgb
@gm convert -size 300x300 -depth 8 InterpolarImagenResultado.rgb win:

@echo.
@echo.
@echo MUCHAS GRACIAS POR UTILIZAR EL PROGRAMA!!
@echo RECUERDE QUE LA APLICACION Y LAS IMAGENES INTERPOLADAS ESTAN EN %RutaBAT%
@echo.
@echo PRESIONE UNA TECLA PARA SALIR!!!
@PAUSE > nul
@CLS
EXIT