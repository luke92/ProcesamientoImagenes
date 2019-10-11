@SET /P rojo=Ingrese el valor del Rojo:  
@SET /P verde=Ingrese el valor del Verde:  
@SET /P azul=Ingrese el valor del Azul:  
@SET /P d=Ingrese la tolerancia de color:  
@SET /P ancho=Ingrese el ancho de la imagen: 
@SET /P alto=Ingrese el alto de la imagen: 
@TP2E2_OC2_PESADO_VARGAS imagen1.rgb imagen2.rgb %ancho% %alto% %rojo% %verde% %azul% %d% resultado.rgb
@gm convert -size %ancho%x%alto% -depth 8 resultado.rgb win:
@EXIT