%include "io.inc"
global CMAIN

;NOTA: PSHUFD 3 parametros origen,destino,bit extra 
;OBS IMPORTANTE: LOS PATRONES SE CARGAN AL REVEZ!

section .data
PATRON_INT_PF db 3,255,255,255,2,255,255,255,1,255,255,255,0,255,255,255
PATRON_PF_INT db 0,4,8,12,255,255,255,255,255,255,255,255,255,255,255,255
PATRON_CARGA_P db 0,1,2,3,0,1,2,3,0,1,2,3,0,1,2,3,
unoXMM dd 1.0,1.0,1.0,1.0

;PARA DEBUG
IMG1 db 1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8,1,2,3,4,5,6,7,8
IMG2 db 8,7,6,5,4,3,2,2,1,0,8,7,6,5,4,3,2,2,1,0,8,7,6,5,4,3,2,2,1,0,8,7,6
RES db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
P dd 0.5
TAMANIO dd 32

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

mov ecx,0
mov edx,[EBP + 24] ;contadores para ciclar
 
mov eax ,[EBP + 20]
push eax ;img1
mov eax ,[EBP + 16]
push eax ;img2
mov eax ,[EBP + 12]
push eax ;res

mov eax,1 ;señal de error, si no se cambia al final
          ;significa que no se realizo con exito
movdqu xmm5,[PATRON_INT_PF] ;mascara shuffle INT PF
movdqu xmm6,[PATRON_PF_INT] ;mascara shuffle PF INT

;armo vector de p
movdqu xmm4,[PATRON_CARGA_P];mascara shuffle carga P
movd xmm2,[EBP + 8] ;PASO P A REGISTRO
pshufb xmm2,xmm4    ;ACOMODO P
movdqu xmm3,[unoXMM];CARGO 1
subps xmm3,xmm2     ;(1-P)
call recur ;instacia inicial 
add esp,12
mov eax,0 ;envio señal de que se pudo hacer bien
jmp salir

recur:
push ebp
mov ebp,esp
;EBP +0  ebp actual
;EBP +4  DIR RETORNO
;EBP +8  PUNTERO CHAR RESULTADO
;EBP +12  PUNTERO CHAR IMG2
;EBP +16 PUNTERO CHAR IMG1

;XMM2 VECTOR DE 4 1`S EN PF
;XMM3 VECTOR DE 1-P EN PF
;XMM4 MASCARA CARGA P
;XMM5 MASCARA INT A PF
;XMM6 MASCARA PF  A INT

cmp edx,ecx
je salir
jl salir

;***************
;*COLOCO EN MMX*
;***************

;PASO EL VECTOR DE IMG 1 A XMM0
mov eax,[EBP + 16]
movd xmm0,dword [eax]
pshufb xmm0, xmm5 ;paso a PF vect 1
;paso el vecto de IMG 2 A XMM1
mov eax,[EBP + 12]
movd xmm1,dword [eax]
pshufb xmm1,xmm5

;***********************************
;*CONVIERTO DE INT A PF PARA OPERAR*
;***********************************

;convierto img 1 a PF
cvtdq2ps xmm0,xmm0;conv int - PF
;convierto img 2 a PF
cvtdq2ps xmm1,xmm1;conv int - PF

;********************
;*OPERACIONES CON PF*
;********************

;REALIZAR: P x V1 + (1-p) x V2
;PARA ELLO MULTIPLICAMOS ENTRE REGISTROS XMM
;XMM2 =   1
;XMM3 = (1-P)
mulps xmm0, xmm2 ;p x v1
mulps xmm1, xmm3;(1-p)x V2
addps xmm0,xmm1 ;P x V1 + (1-p) x V2
;ahora en XMM0 estan los 4 vectores resultado

;*********************
;*RECUPERAR RESULTADO*
;*********************

;VOLVER DE PF A BYTES
cvtps2dq xmm0,xmm0 ;convierte el resultado en FLOAT
;ahora hay que volver a armarlos
;ya que quedaron en la parte baja de cada numero flotante
pshufb xmm0, xmm6 ;recupero resultado

;AHORA EN XMM0, EN LA PARTE BAJA,TENGO LOS 4 BYTES DE RESU
;los voy a pasar directamente al vector resultado
mov eax,[EBP + 8]
movd [eax],xmm0

;ahora vuelvo a llamar a la funcion pero pasandole
;el resto de los vectores
mov eax , [EBP + 16] ;dir IMG1
add eax, 4 ;me muevo al proximo vector
push eax ;paso IMG1

mov eax , [EBP + 12] ;dir IMG2
add eax, 4 ;me muevo al proximo vector
push eax ;paso IMG2

mov eax , [EBP + 8] ;dir IMG RESULTADO
add eax, 4 ;me muevo al proximo vector
push eax ;paso IMG RESULTADO

add ecx,4

call recur
add esp,12 ;desapilo
jmp salir  ;sacar esto si es posible

salir:
mov esp,ebp
pop ebp
ret ;no corta bien en algun lado me falta un pop

;2DA ETAPA
;_superponer:
;push ebp
;mov ebp, esp
;EBP EBP ACTUAL
;EBP +4 DIR RETORNO
;EBP +8 PUNTERO CHAR RESULTADO
;EBP +12 FLOAT P (4 bytes se pasa de 1)
;EBP +16 int b 
;EBP +20 int g 
;EBP +24 int r 
;EBP +28 puntero fondo
;EBP +32 puntero figura

;pop ebp
;mov esp,ebp
;ret

CMAIN:
    mov ebp, esp; for correct debugging
    
    mov eax,[TAMANIO]
    push eax
    
    mov eax,IMG1
    push eax
    
    mov eax,IMG2
    push eax
    
    mov eax,RES
    push eax
    
    mov eax,[P]
    push eax
    
    call _interpolar
    add esp,20  
    xor eax,eax
    ret