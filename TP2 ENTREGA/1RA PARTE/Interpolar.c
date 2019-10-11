#include <stdio.h>
#include <stdlib.h>
#include "Funciones.h"

void interpolar(int longitud, unsigned char* img1, unsigned char* img2,unsigned char* resultado,float p);

int main(int argc, char * argv[])
{
	if(argc != 7) 
	{
		printf("Los argumentos del programa deben ser: \n");
		printf("imagen1.rgb imagen2.rgb filas columnas p(entre 0 y 1) resultado.rgb");
		return 0;
	}
    ///argv[0] Ejecutable (Interpolar)
    ///argv[1] Imagen1 rgb
    ///argv[2] Imagen2 rgb
    ///argv[3] filas
    ///argv[4] columnas
    ///argv[5] Proporcion de interpolacion (FLoat entre 0 y 1)
    ///argv[6] ImagenResultado rgb
	char *nombreImagen1 = argv[1];
	char *nombreImagen2 = argv[2];
	int filas = atoi(argv[3]);
	int columnas = atoi(argv[4]);
    float p = atof(argv[5]);
    char *nombreImagenResultado = argv[6];
    
    unsigned char *img1;
    unsigned char *img2;
    unsigned char *resultado;

    int cantidadPixelPorPunto = 3;
    int longitud = filas * columnas * cantidadPixelPorPunto;
    
    img1 = malloc (longitud);
    img2 = malloc (longitud);
    resultado = malloc (longitud);

    
    leer_rgb(nombreImagen1,img1,filas,columnas);
	
    leer_rgb(nombreImagen2,img2,filas,columnas);
	
    interpolar(longitud,img1,img2,resultado,p);
	
    escribir_rgb(nombreImagenResultado,resultado,filas,columnas);

    free(img1);
    free(img2);
    free(resultado);

    return 0;
}
