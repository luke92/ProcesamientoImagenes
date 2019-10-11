@SET /P imagen1=Ingrese el nombre de archivo con extension de la imagen a convertir a RGB: 
@SET /P imagen2=Ingrese el nombre de archivo con extension de la otra imagen a convertir a RGB: 
@gm convert %imagen1% imagen1.rgb
@gm convert %imagen2% imagen2.rgb