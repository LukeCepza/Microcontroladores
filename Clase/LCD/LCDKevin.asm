 	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto start
	#define RS  LATA, 1, A ;RS 
	#define E   LATA, 2, A ;Estatus 
	#define RW  LATA, 3, A ;Comando E 
	#define dataLCD LATD, A ;Puerto del LCD 
start 
	goto configura
	
configura
	org 0x20
	movlb d'15' ;Selectlastbank(SFRs)
	clrf ANSELA, BANKED ;Forces digital I/O
	movlw b'00000000';50 - 50 I/O 
	movwf TRISA, A  
	clrf TRISD,A
	setf LATA,A;'Normal'logiclevels
	
LCDproperties
	MOVLW b'00111000' ; funcionamiento de dos lineas
	call SetProps

	MOVLW b'00001111' ; Encender Display, Cursor y Parapdeo
	call SetProps

	MOVLW b'00000110' ; Configurar incremento del cursor a la derecha
	call SetProps

	MOVLW b'00000001' ; Clearing display
	call SetProps

	MOVLW b'11000100' ; setcursor
	call SetProps

LCDwrite
	MOVLW a'C' ; write
	call WriteLCD
	
	MOVLW a'4' ; write
	call WriteLCD
	
	goto ending

SetProps
	bcf RS ;RS=0
	bcf RW ;RW=0
	bsf E ;Enabled = 1
	MOVWF dataLCD 
	nop
	bcf E ;Enabled = 0
	call Delay1m
	return
	
WriteLCD
	bsf RS ;RS=1
	bcf RW ;RW=0
	bsf E ;Enabled = 1
	MOVWF dataLCD 
	nop
	bcf E ;Enabled = 0
	call Delay1m
	return
	
Delay1m 
	movlw .8
	movwf 0x32, A
intDel	incf 0x32,F,A
	btfss STATUS,2,A
	goto intDel
	return	
	
ending
	end
