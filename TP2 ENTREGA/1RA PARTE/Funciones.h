#ifndef FUNCIONES_H_INCLUDED
#define FUNCIONES_H_INCLUDED

void leer_rgb(char *archivo, unsigned char *buffer, int filas, int columnas)
{
    FILE *fp;
    fp = fopen(archivo, "rb");
    fread (buffer, filas * columnas * 3, 1, fp);
    fclose (fp);
}

void escribir_rgb(char *archivo, unsigned char *buffer, int filas, int columnas)
{
    FILE *fpNuevo;
    fpNuevo = fopen(archivo,"wb");
    fwrite(buffer,filas*columnas*3,1,fpNuevo);
    fclose(fpNuevo);
}

void separar_rgb(unsigned char *rgb, int cantidad, unsigned char *r, unsigned char *g, unsigned char *b)
{
    int i;
    int cont = 0;
    for(i = 0; i < cantidad; i+=3)
    {
        r[cont] = rgb[i];
        g[cont] = rgb[i+1];
        b[cont] = rgb[i+2];
        cont++;
    }
}

void combinar_rgb(unsigned char *r, unsigned char *g, unsigned char *b, int cantidad, unsigned char *rgb)
{
    int i;
    int cont = 0;
    for(i = 0; i < cantidad; i++)
    {
        rgb[cont] = r[i];
        cont++;
        rgb[cont] = g[i];
        cont++;
        rgb[cont] = b[i];
        cont++;
    }
}

void mostrarRGB(unsigned char *vector, int cantidad)
{
	printf("Mostrando vector\n");
	int i;
	for(i = 0; i < cantidad; i++)
	{
		printf("%d",vector[i]);
	}
	printf("\n");
}
#endif // FUNCIONES_H_INCLUDED
