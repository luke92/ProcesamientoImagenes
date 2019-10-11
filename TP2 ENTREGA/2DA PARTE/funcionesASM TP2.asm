%include "io.inc"
global CMAIN
global gen_mascara
global aplicar_mascara

section .data 
align 16          ;PARA ALINEAR LAS MASCARAS
PATRON_INT_PF       db 3,255,255,255,2,255,255,255,1,255,255,255,0,255,255,255
PATRON_PF_INT       db 12,8,4,0,255,255,255,255,255,255,255,255,255,255,255,255
PATRON_CARGA_TRANSP db 0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3
VECTOR_1OS          dd 0,0,0,0
;PARA DEBUG
R        db 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16
G        db 0,2,4,8,12,16,20,24,28,32,36,38,40,42,44,48
B        db 10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160
CANTIDAD dd 16
RTransp  dd 40
GTransp  dd 60
BTransp  dd 80
T        dd 200000000
MASCARA  db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
;2DA PARTE
MASCARA2  db 255,255,255,255,0,0,0,0,255,255,255,255,0,0,0,0
CANTIDAD2 db 16
CANAL1    db 255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255
CANAL2    db 8,8,8,8,9,9,9,9,10,10,10,10,4,4,4,4
RESULTADO db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

section .text
CMAIN:
mov ebp, esp; for correct debugging

;1RA PARTE
mov eax, R
push eax
mov eax, G
push eax
mov eax, B
push eax
mov eax, [CANTIDAD]
push eax
mov eax, [RTransp]
push eax
mov eax, [GTransp]
push eax
mov eax, [BTransp]
push eax
mov eax, [T]
push eax
mov eax, MASCARA
push eax

;call gen_mascara
add esp, 36

;2DA PARTE
mov eax,RESULTADO
push eax
mov eax,[CANTIDAD2]
push eax
mov eax,CANAL2
push eax
mov eax,CANAL1
push eax
mov eax, MASCARA2
push eax
call aplicar_mascara
add esp, 20
ret

gen_mascara:
push ebp
mov ebp,esp
;EBP + 0  EBP ACTUAL
;EBP + 4  DIR RETORNO
;EBP + 8  PUNTERO MASCARA
;EBP + 12 FLOAT T
;EBP + 16 INT BP
;EBP + 20 INT GT
;EBP + 24 INT RT
;EBP + 28 INT CANTIDAD
;EBP + 32 PUNTERO B
;EBP + 36 PUNTERO G
;EBP + 40 PUNTERO R

;XMM0 PUNTERO R
;XMM1 PUNTERO G
;XMM2 PUNTERO B
;XMM3 R TRANSP
;XMM4 G TRANSP
;XMM5 B TRANSP
;XMM6 MASCARA PASA PUNTEROS
;XMM7 MASCARA CONVIERTE TRANSPARENTES -> MASCARA PF - VECTOR

cargarT:
mov ebx, [EBP + 12]               ;EBX = VALOR DE T

cargarTransparente:
movdqu xmm7,[PATRON_CARGA_TRANSP] ;MASCARA CARGA TRANSPARENTES
cargaR:
movd xmm3, [EBP + 24]             ;PASO R A REGISTRO
pshufb xmm3,xmm7                  ;ACOMODO R
cargaG:
movd xmm4, [EBP + 20]             ;PASO R A REGISTRO
pshufb xmm4,xmm7                  ;ACOMODO R
cargaB:
movd xmm5, [EBP + 16]             ;PASO R A REGISTRO
pshufb xmm5,xmm7                  ;ACOMODO R

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
mov edx, [EBP + 28]               ;EDX = CANTIDAD TOTAL

ciclar:

cargarCanalR:
mov eax,[EBP + 40]                ;MUEVO PUNTERO DE R
movd xmm0,dword [eax + ecx]       ;COPIO VECTOR DE R
pshufb xmm0, xmm6                 ;ACOMODO VECTOR R 
cargarCanalG:
mov eax,[EBP + 36]                ;MUEVO PUNTERO DE G
movd xmm1,dword [eax + ecx]       ;COPIO VECTOR DE G
pshufb xmm1, xmm6                 ;ACOMODO VECTOR G 
cargarCanalB:
mov eax,[EBP + 32]                ;MUEVO PUNTERO DE B
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
mov eax, [EBP + 8]               ;PUNTERO DE MASCARA
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

aplicar_mascara:
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