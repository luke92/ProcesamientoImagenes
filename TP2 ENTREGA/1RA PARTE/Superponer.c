#include <stdio.h>
#include "Funciones.h"

void gen_mascara(unsigned char *r, unsigned char *g, unsigned char *b, int cantidad, int rt, int gt, int bt, float t, unsigned char *mascara);

void aplica_mascara(unsigned char *mascara, unsigned char *canal1, unsigned char *canal2, int cantidad, unsigned char *resultado);


int main(int argc, const char * argv[])
{
	if(argc != 10) 
	{
		printf("Los argumentos del programa deben ser: \n");
		printf("imagen1.rgb imagen2.rgb filas columnas rojo verde azul distancia resultado.rgb");
		return 0;
	}
    ///argv[0] Ejecutable (Superponer)
    ///argv[1] Imagen1 rgb
    ///argv[2] Imagen2 rgb
    ///argv[3] filas
    ///argv[4] columnas
    ///argv[5] Valor Rojo Transparente
    ///argv[6] Valor Verde Transparente
    ///argv[7] Valor Azul Transparente
    ///argv[8] Distancia de color del pixel para ser considerado transparente
    ///argv[9] ImagenResultado rgb

	char *nombreImagen1 = argv[1];
	char *nombreImagen2 = argv[2];
	int filas = atoi(argv[3]);
	int columnas = atoi(argv[4]);
	int valorR = argv[5];
	int valorG = argv[6];
	int valorB = argv[7];
    float p = atof(argv[8]);
    char *nombreImagenResultado = argv[9];
	
    unsigned char *img1;
    unsigned char *img2;
    unsigned char *resultado;
	unsigned char *mascara;
	unsigned char *r;
	unsigned char *g;
	unsigned char *b;
	
	int cantidadPixelPorPunto = 3;
    int longitud = filas * columnas * cantidadPixelPorPunto;
    
    img1 = malloc (longitud);
    img2 = malloc (longitud);
    resultado = malloc (longitud);
	r = malloc (longitud / 3);
	g = malloc (longitud / 3);
	b = malloc (longitud / 3);
	
	leer_rgb(nombreImagen1,img1,filas,columnas);
    leer_rgb(nombreImagen2,img2,filas,columnas);
	
	escribir_rgb(nombreImagenResultado,resultado,filas,columnas);
	
    
	return 0;

}
