@SET /P archivo=Ingrese el nombre del archivo con extension .rgb que quiere visualizar:
@SET /P ancho=Ingrese el ancho de la imagen: 
@SET /P alto=Ingrese el alto de la imagen: 
@gm convert -size %ancho%x%alto% -depth 8 %archivo%.rgb win: