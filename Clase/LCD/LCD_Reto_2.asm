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
superman
	MOVLW b'01000000' ; go to CGRAM
	call SetProps
s1
	MOVLW b'00000000'
	call WriteLCD
	MOVLW b'00000111'
	call WriteLCD
	MOVLW b'00001000'
	call WriteLCD
	MOVLW b'00001011'
	call WriteLCD
	MOVLW b'00010011'
	call WriteLCD
	MOVLW b'00010010'
	call WriteLCD
	MOVLW b'00010010'
	call WriteLCD
	MOVLW b'00010011'
	call WriteLCD
s2
	MOVLW b'00000000'
	call WriteLCD
	MOVLW b'00011100'
	call WriteLCD
	MOVLW b'00000010'
	call WriteLCD
	MOVLW b'00011010'
	call WriteLCD
	MOVLW b'00011001'
	call WriteLCD
	MOVLW b'00000001'
	call WriteLCD
	MOVLW b'00011001'
	call WriteLCD
	MOVLW b'00011001'
	call WriteLCD
s3
	MOVLW b'00001000'
	call WriteLCD
	MOVLW b'00001011'
	call WriteLCD
	MOVLW b'00001011'
	call WriteLCD
	MOVLW b'00000100'
	call WriteLCD
	MOVLW b'00000100'
	call WriteLCD
	MOVLW b'00000010'
	call WriteLCD
	MOVLW b'00000001'
	call WriteLCD
	MOVLW b'00000000'
	call WriteLCD
s4
	MOVLW b'00001010'
	call WriteLCD
	MOVLW b'00011010'
	call WriteLCD
	MOVLW b'00011010'
	call WriteLCD
	MOVLW b'00000100'
	call WriteLCD
	MOVLW b'00000100'
	call WriteLCD
	MOVLW b'00001000'
	call WriteLCD
	MOVLW b'00010000'
	call WriteLCD
	MOVLW b'00000000'
	call WriteLCD	

LCDproperties 
	MOVLW b'00111000' ; escritura en dos líneas: DL = 8bit; N = 2 lines; F= 5x7
	call SetProps
	MOVLW b'00001100' ; Encender Display, sin cursor activo: D = 1; C = 0;B =0
	call SetProps
	MOVLW b'00000110' ; Configurar desplazamiento incremental: I/D = 1
	call SetProps
	MOVLW b'00000001' ; Clearing display
	call SetProps
	
escribirSuperman
	MOVLW b'10000111' ; MOVE cursor (1,8)
	call SetProps
	MOVLW b'00000000' 
	call WriteLCD
	MOVLW b'00000001' 
	call WriteLCD
	MOVLW b'11000111' ; MOVE cursor (2,8)
	call SetProps
	MOVLW b'00000010' 
	call WriteLCD
	MOVLW b'00000011' 
	call WriteLCD
	goto ending

SetProps
	bcf RS ;RS=0
	bcf RW ;RW=0
	goto Enable
WriteLCD
	bsf RS ;RS=1
	bcf RW ;RW=0
Enable	bsf E ;Enabled = 1
	MOVWF dataLCD 
	nop
	bcf E ;Enabled = 0
	call Delay1m
	return
	

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

