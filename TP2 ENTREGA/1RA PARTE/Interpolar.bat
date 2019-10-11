@SET /P valorP=Ingresa un valor entre 0 y 1:
@TP2E1_OC2_PESADO_VARGAS imagen1.rgb imagen2.rgb 256 256 %valorP% resultado.rgb
@gm convert -size 256x256 -depth 8 resultado.rgb win: