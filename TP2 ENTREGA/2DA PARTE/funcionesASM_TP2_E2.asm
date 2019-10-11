global _gen_mascara
global _aplica_mascara

section .data 
align 16          ;PARA ALINEAR LAS MASCARAS
PATRON_INT_PF       db 3,255,255,255,2,255,255,255,1,255,255,255,0,255,255,255
PATRON_PF_INT       db 12,8,4,0,255,255,255,255,255,255,255,255,255,255,255,255
PATRON_CARGA_TRANSP db 0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3

section .text

_gen_mascara:
push ebp
mov ebp,esp
;EBP + 0  EBP ACTUAL
;EBP + 4  DIR RETORNO
;EBP + 8  PUNTERO R
;EBP + 12 PUNTERO G
;EBP + 16 PUNTERO B
;EBP + 20 INT CANTIDAD
;EBP + 24 INT RT
;EBP + 28 INT GT
;EBP + 32 INT BT
;EBP + 36 FLOAT T
;EBP + 40 PUNTERO MASCARA

;XMM0 PUNTERO R
;XMM1 PUNTERO G
;XMM2 PUNTERO B
;XMM3 R TRANSP
;XMM4 G TRANSP
;XMM5 B TRANSP
;XMM6 MASCARA PASA PUNTEROS
;XMM7 MASCARA CONVIERTE TRANSPARENTES -> MASCARA PF - VECTOR

cargarT:
mov ebx, [EBP + 36]               ;EBX = VALOR DE T

cargarTransparente:
movdqu xmm7,[PATRON_CARGA_TRANSP] ;MASCARA CARGA TRANSPARENTES
cargaR:
movd xmm3, [EBP + 24]             ;PASO RT A REGISTRO
pshufb xmm3,xmm7                  ;ACOMODO RT
cargaG:
movd xmm4, [EBP + 28]             ;PASO BT A REGISTRO
pshufb xmm4,xmm7                  ;ACOMODO BT
cargaB:
movd xmm5, [EBP + 32]             ;PASO GT A REGISTRO
pshufb xmm5,xmm7                  ;ACOMODO GT

cargarPatrones:
movdqu xmm6,[PATRON_INT_PF]       ;MASCARA DE VECTOR - PF
movdqu xmm7,[PATRON_PF_INT]       ;MASCARA DE PF - VECTOR

convertirPF_TRANSP_RGB:
;CONVIERTO VECTOR DE Rt EN PF
cvtdq2ps xmm3,xmm3          
;CONVIERTO VECTOR DE Gt EN PF
cvtdq2ps xmm4,xmm4          
;CONVIERTO VECTOR DE Bt EN PF
cvtdq2ps xmm5,xmm5     

cargarContadores:
mov ecx, 0                        ;ECX = CONTADOR, LO PONGO EN 0
mov edx, [EBP + 20]               ;EDX = CANTIDAD TOTAL

ciclar:

cargarCanalR:
mov eax,[EBP + 8]                ;MUEVO PUNTERO DE R
movd xmm0,dword [eax + ecx]       ;COPIO VECTOR DE R
pshufb xmm0, xmm6                 ;ACOMODO VECTOR R 
cargarCanalG:
mov eax,[EBP + 12]                ;MUEVO PUNTERO DE G
movd xmm1,dword [eax + ecx]       ;COPIO VECTOR DE G
pshufb xmm1, xmm6                 ;ACOMODO VECTOR G 
cargarCanalB:
mov eax,[EBP + 16]                ;MUEVO PUNTERO DE B
movd xmm2,dword [eax + ecx]       ;COPIO VECTOR DE B
pshufb xmm2, xmm6                 ;ACOMODO VECTOR B

convertirINT_PF:
;CONVIERTO VECTOR DE R EN PF
cvtdq2ps xmm0,xmm0          
;CONVIERTO VECTOR DE G EN PF
cvtdq2ps xmm1,xmm1          
;CONVIERTO VECTOR DE B EN PF
cvtdq2ps xmm2,xmm2     

operarVectores:
subps xmm0  , xmm3                   ;(r1 - r)   
subps xmm1  , xmm4                   ;(g1 - g)   
subps xmm2  , xmm5                   ;(b1 - b)
mulps xmm0  , xmm0                   ;(r1 - r) * (r1 - r)
mulps xmm1  , xmm1                   ;(g1 - g) * (g1 - g)
mulps xmm2  , xmm2                   ;(b1 - b) * (b1 - b)
addps xmm0  , xmm1                   ;(r1 - r)2 + (g1 - g)2
addps xmm0  , xmm3                   ;(r1 - r)2 + (g1 - g)2 + (b1 + b)2
sqrtps xmm0 , xmm0                   ;v[ (r1 - r)2 + (g1 - g )2 +  (b1 -b)2 ] 

recuperarResultado:
;TRASFORMAR PF A VECTOR
;cvtps2dq xmm0,xmm0 ;CONVIERTE D A VECTOR

cargarT_Vector:
movdqu xmm2,[PATRON_CARGA_TRANSP]    ;MASCARA CARGA TRANSPARENTES
movd xmm1, EBX                       ;PASO T A REGISTRO
pshufb xmm1, xmm2                    ;ACOMODO T

;sacar esto, es para debug del numero
determinarTransparencia:
CMPPS xmm0, xmm1, 2                  ;comparo por <= con el valor de t, 
                                     ;tengo 0's en las que no son trans
recuperarResultadoComparacion:
pshufb xmm0, xmm7                    ;PF A INT

copiarResultado:
mov eax, [EBP + 40]               ;PUNTERO DE MASCARA
movd [eax + ecx],xmm0            ;COPIO EL RESULTADO AL VECTOR
                                 ;EN LA POSICION INDICADA
operarConLosRestantes:
add ecx,4                        ;ACCEDO A LOS PROXIMOS 4 VECTORES
cmp ecx, edx
jl ciclar

mov esp,ebp
pop ebp
ret

;***************************************************************************

_aplica_mascara:
push ebp
mov ebp,esp

;EBP + 0  EBP ACTUAL
;EBP + 4  DIR RETORNO
;EBP + 8  PUNTERO MASCARA
;EBP + 12 PUNTERO CANAL 1
;EBP + 16 PUNTERO CANAL 2
;EBP + 20 INT CANTIDAD
;EBP + 24 PUNTERO RESULTADO

;ASUMO EL CANAL 1 COMO FIGURA, UTILIZO DE A 16 BITS A LA VEZ

;XMM0 = CANAL   1
;XMM1 = CANAL   2
;XMM2 = MASCARA / RESULTADO

cargar_Contadores:
mov ecx, 0                        ;ECX = CONTADOR, LO PONGO EN 0
mov edx, [EBP + 20]               ;EDX = CANTIDAD TOTAL

ciclo:

cargarCanal1:
mov eax,[EBP + 12]                ;MUEVO PUNTERO DE CANAL1
movdqu xmm0,[eax + ecx]           ;COPIO VECTOR DE CANAL1
cargarCanal2:
mov eax,[EBP + 16]                ;MUEVO PUNTERO DE CANAL2
movdqu xmm1,[eax + ecx]           ;COPIO VECTOR DE CANAL2
cargarMASCARA:
mov eax,[EBP + 8]                 ;MUEVO PUNTERO DE MASCARA
movdqu xmm2,[eax + ecx]           ;COPIO VECTOR DE MASCARA

determinarTraspolacion:
PAND xmm1,xmm2                    ;SACO LA FIGURA DEL FONDO
PANDN xmm2,xmm0                   ;SACO EL FONDO DE LA FIGURA
POR xmm2,xmm1                     ;JUNTO EL FONDO Y LA FIGURA

copiarResultadoTraspolacion:
mov eax, [EBP + 24]               ;PUNTERO DE RESULTADO
movdqu [eax + ecx],xmm2           ;COPIO EL RESULTADO AL VECTOR
                                  ;EN LA POSICION INDICADA
evaluarRestantes:
add ecx,16                        ;ACCEDO A LOS PROXIMOS 4 VECTORES
cmp ecx, edx
jl ciclo

mov esp,ebp
pop ebp
ret