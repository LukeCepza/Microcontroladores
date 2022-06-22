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
configura org 0x20
	movlb d'15' ;Selectlastbank(SFRs)
	clrf ANSELA, BANKED ;Forces digital I/O
	clrf ANSELB, BANKED
	clrf TRISA, A  
	clrf TRISD,A
smile
	MOVLW b'01000000' ; go to CGRAM
	call SetProps

	MOVLW b'10000000' ; CArita feliz
	call WriteLCD	
	MOVLW b'10001010' ; CArita feliz
	call WriteLCD
	MOVLW b'10001010' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10011111' ; CArita feliz
	call WriteLCD
	MOVLW b'10010001' ; CArita feliz
	call WriteLCD
	MOVLW b'10001110' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	
LCDproperties 
	MOVLW b'00111000' ; escritura en dos líneas: DL = 8bit; N = 2 lines; F= 5x7 y Go to DDRAM
	call SetProps
	MOVLW b'00001100' ; Encender Display, sin cursor activo: D = 1; C = 0;B =0
	call SetProps
	MOVLW b'00000110' ; Configurar incremento del cursor a la derecha
	call SetProps
	MOVLW b'00000001' ; Clearing display
	call SetProps
	
escribirHW
	MOVLW b'10000000' ; setcursor
	call SetProps
	
	MOVLW 'H' ; setcursor
	call WriteLCD
	MOVLW 'O' ; setcursor
	call WriteLCD
	
	MOVLW b'11000010' ; setcursor
	call SetProps
	
	MOVLW 'L' ; setcursor
	call WriteLCD
	MOVLW 'A' ; setcursor
	call WriteLCD
	
	MOVLW b'10000111' ; setcursor
	call SetProps
	
	MOVLW 'M' ; setcursor
	call WriteLCD
	MOVLW 'U' ; setcursor
	call WriteLCD
	
	MOVLW b'11001001' ; setcursor
	call SetProps
	
	MOVLW 'N' ; setcursor
	call WriteLCD
	MOVLW 'D' ; setcursor
	call WriteLCD
	MOVLW 'O' ; setcursor
	call WriteLCD
	MOVLW '!' ; setcursor
	call WriteLCD
	
	MOVLW b'00000000' ; setcursor
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
