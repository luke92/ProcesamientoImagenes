#include <stdio.h>
#include <stdlib.h>
#include "Funciones.h"

void gen_mascara(unsigned char *r, unsigned char *g, unsigned char *b, int cantidad, int rt, int gt, int bt, float t, unsigned char *mascara);
void aplica_mascara(unsigned char *mascara, unsigned char *canal1, unsigned char *canal2, int cantidad, unsigned char *resultado);

int main(int argc, char * argv[])
{
	if(argc != 10) 
	{
		printf("Los argumentos del programa deben ser: \n");
		printf("imagen1.rgb imagen2.rgb filas(entero) columnas(entero) rojo(0-255) verde(0-255) azul(0-255) distancia(Decimal) resultado.rgb");
		return 0;
	}
    ///argv[0] Ejecutable (Superponer)
    ///argv[1] Imagen1 rgb Figura
    ///argv[2] Imagen2 rgb Fondo
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
	char *rt = argv[5];
	char *gt = argv[6];
	char *bt = argv[7];
	int valorR = atoi(rt);
	int valorG = atoi(gt);
	int valorB = atoi(bt);
    float t = atof(argv[8]);
    char *nombreImagenResultado = argv[9];

    unsigned char *img1;
    unsigned char *img2;
    unsigned char *resultado;
	
	unsigned char *r1;
	unsigned char *g1;
	unsigned char *b1;
	
	unsigned char *r2;
	unsigned char *g2;
	unsigned char *b2;

	unsigned char *resultadoRojo;
	unsigned char *resultadoVerde;
	unsigned char *resultadoAzul;

	unsigned char *mascara;	

	int cantidadPixelPorPunto = 3;
    int longitud = filas * columnas * cantidadPixelPorPunto;
    int cantPixeles = filas * columnas;
    int cantidadBytesMascara = cantBytesMascara(cantPixeles);

    img1 = reservarMemoria(longitud);
    img2 = reservarMemoria(longitud);
    resultado = reservarMemoria(longitud);
	
	r1 = reservarMemoria(cantPixeles);
	g1 = reservarMemoria(cantPixeles);
	b1 = reservarMemoria(cantPixeles);

	r2 = reservarMemoria(cantPixeles);
	g2 = reservarMemoria(cantPixeles);
	b2 = reservarMemoria(cantPixeles);
	
	resultadoRojo = reservarMemoria(cantPixeles);
	resultadoVerde = reservarMemoria(cantPixeles);
	resultadoAzul = reservarMemoria(cantPixeles);

	mascara = reservarMemoria(cantidadBytesMascara);
	
	leer_rgb(nombreImagen1,img1,filas,columnas);
    leer_rgb(nombreImagen2,img2,filas,columnas);
	
	separar_rgb(img1,longitud,r1,g1,b1);
	separar_rgb(img2,longitud,r2,g2,b2);
	
	gen_mascara(r1,g1,b1,cantPixeles,valorR,valorG,valorB,t,mascara);

	aplica_mascara(mascara, r1, r2, cantidadBytesMascara, resultadoRojo);
	aplica_mascara(mascara, g1, g2, cantidadBytesMascara, resultadoVerde);
	aplica_mascara(mascara, b1, b2, cantidadBytesMascara, resultadoAzul);

	combinar_rgb(resultadoRojo,resultadoVerde,resultadoAzul,cantPixeles,resultado);

	escribir_rgb(nombreImagenResultado,resultado,filas,columnas);
	
	///Liberamos toda la memoria
	free(img1);
	free(img2);
    free(resultado);
	
	free(r1);
	free(g1);
	free(b1);

	free(r2);
	free(g2);
	free(b2);
	
	free(resultadoRojo);
	free(resultadoVerde);
	free(resultadoAzul);

	free(mascara);

	return 0;

}
