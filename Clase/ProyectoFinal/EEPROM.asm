#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
; Registros asociados al EEPROM
	;Asociados a 
	#define NAME1_HS_1 0x16, A
	#define NAME1_HS_2 0x17, A
	#define NAME1_HS_3 0x18, A
	#define NAME2_HS_1 0x19, A
	#define NAME2_HS_2 0x1A, A
	#define NAME2_HS_3 0x1B, A
	#define NAME3_HS_1 0x1C, A
	#define NAME3_HS_2 0x1D, A
	#define NAME3_HS_3 0x1E, A
	#define SCR1 0x1F, A
	#define SCR2 0x20, A
	#define SCR3 0x21, A
	;Asociados a ultimo puntaje
	#define HIST1 0x22, A
	#define HIST2 0x23, A
	#define HIST3 0X24, A
Setup	org 0x20 
start
; Escritura
SAVEE_EPROM
    movlw d'0'
    movwf EEADR, A
    movlw A'K'
    movwf EEDATA, A
    movlw b'00000100'
    movwf EECON1, A
    movlw 0x55
    movwf EECON2, A
    movlw 0xAA
    movwf EECON2, A
    bsf EECON1, WR, A ; Empieza a escribir
waitwrite
    btfsc EECON1, WR, A
    goto waitwrite
    
    bcf EECON1, 2, A
    clrf EEDATA, A ; Solo para verificar que se cargue el dato
; Lectura
; Como ya está cargada la dirección y la
;configuración base, se pasa directo a leer
bsf EECON1, 0, A
movff EEDATA,0x23
goto start
end
