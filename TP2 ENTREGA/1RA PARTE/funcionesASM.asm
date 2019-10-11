global _interpolar

section .data 
align 16          ;PARA ALINEAR LAS MASCARAS
PATRON_INT_PF  db 3,255,255,255,2,255,255,255,1,255,255,255,0,255,255,255
PATRON_PF_INT  db 12,8,4,0,255,255,255,255,255,255,255,255,255,255,255,255
PATRON_CARGA_P db 0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3
unoXMM         dd 1.0,1.0,1.0,1.0
section .text
;1RA ETAPA
_interpolar:
push ebp
mov ebp,esp
;EBP +0  PUSH EBP RECIEN
;EBP +4  DIR RETORNO
;EBP +8  FLOAT P
;EBP +12 PUNTERO CHAR RESULTADO
;EBP +16 PUNTERO CHAR IMG2
;EBP +20 PUNTERO CHAR IMG1
;EBP +24 INT TAMAÑO

;EBP +4  DIR RETORNO
;EBP +8  INT TAMAÑO
;EBP +12 PUNTERO CHAR IMG 1
;EBP +16 PUNTERO CHAR IMG 2
;EBP +20 PUNTERO CHAR RESULTADO
;EBP +24 FLOAT P

mov edx,[EBP + 8] ;tamaño
mov ecx,0         ;contador

cargarPatrones:
movdqu xmm5,[PATRON_INT_PF] ;MASCARA DE VECTOR - PF
movdqu xmm6,[PATRON_PF_INT] ;MASCARA DE PF - VECTOR
cargarP:
movdqu xmm4,[PATRON_CARGA_P];MASCARA CARGA P
movd xmm2,[EBP + 24]         ;PASO P A REGISTRO
pshufb xmm2,xmm4            ;ACOMODO P
cargar1menosP:
movdqu xmm3,[unoXMM]        ;CARGO 1
subps xmm3,xmm2             ;(1-P)

ciclar:
llenarVectorIMG1:
mov eax,[EBP + 12] ;muevo puntero de IMG1
movd xmm0,dword [eax + ecx] ;copio vector IMG1
pshufb xmm0, xmm5 ;ACOMODO VECTOR IMG 1 
llenarVectorIMG2:
mov eax,[EBP + 16] ;MUEVO PUNTERO DE IMG2
movd xmm1,dword [eax + ecx] ;COPIO VECTOR IMG2
pshufb xmm1,xmm5 ;ACOMODO VECTOR IMG 2

convertirINT_PF:
;CONVIERTO VECTOR DE IMG 1 EN PF
cvtdq2ps xmm0,xmm0;CONVIERTO VECTOR - PF
;CONVIERTO VECTOR DE IMG 2 EN PF
cvtdq2ps xmm1,xmm1;CONVIERTO VECT - PF

operarConPF:
;XMM0 = VECTOR IMG 1
;XMM1 = VECTOR IMG 2
;XMM2 =   1
;XMM3 = (1-P)
mulps xmm0, xmm2 ;P x v1
mulps xmm1, xmm3;(1-P)x V2
addps xmm0,xmm1 ;P x V1 + (1-p) x V2
;AHORA EN XMM0 ESTA EL RESULTADO

recuperarResultado:
;TRASFORMAR PF A VECTOR
cvtps2dq xmm0,xmm0 ;CONVIERTE EL RESULTADO A VECTOR
;ahora hay que volver a armarlos
;ya que quedaron en la parte baja
;de cada numero flotante
pshufb xmm0, xmm6

copiarResultado:
mov eax,[EBP + 20] ;PUNTERO DE IMG RESULTADO
movd [eax + ecx],xmm0 ;COPIO EL RESULTADO AL VECTOR
                      ;EN LA POSICION INDICADA

operarConLosRestantes:
add ecx,4 ;ACCEDO A LOS PROXIMOS 4 VECTORES
cmp ecx, edx
jl ciclar

mov esp,ebp ;RETORNO EL STACK
pop ebp     ;RECUPERO EBP
ret         ;FIN DE LA FUNCION