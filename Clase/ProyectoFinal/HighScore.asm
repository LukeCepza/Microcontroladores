 	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto SetupAll
	#define RS  LATE, 0, A ;RS 
	#define E   LATE, 2, A ;Estatus 
	#define RW  LATE, 1, A ;Comando E 
	#define dataLCD LATD, A ;Puerto del LCD 
	
LEDStatus	EQU 0x03
ButtonStatus	EQU 0x04
ControlStatus	EQU 0x05
PRandSeed	EQU 0x06 ; 128,64,32,16,8,4,2,1

      
SetupAll
ConfLCD org	0x20
	movlb	d'15' ;Selectlastbank(SFRs)
	clrf	ANSELE, BANKED ;Forces digital I/O
	clrf	TRISE, A  
	clrf	ANSELD, BANKED
	clrf	TRISD,A
ConfButton
	CLRF    ANSELA,BANKED
	MOVLW   B'00111000'  ;A0-A2 Output; A3-A6 Input
	MOVWF   TRISA ;A0-A2 Output; A3-A6 Input
	BCF	INTCON2,7
	MOVWF   WPUB  ; Activar pull-up resistor
ConfLED_Mat_GR
	CLRF    ANSELA,BANKED
	MOVLW   B'00000000'  ;R0-R3 Output Row; R4-R7 Output Column
	MOVWF   TRISA ;R0-R3 Output Row; R4-R7 Output Column
LCDproperties 
	MOVLW b'00111000' ; escritura en dos líneas: DL = 8bit; N = 2 lines; F= 5x7
	call SetProps
	MOVLW b'00001100' ; Encender Display, sin cursor activo: D = 1; C = 0;B =0
	call SetProps
	MOVLW b'00000110' ; Configurar desplazamiento incremental: I/D = 1
	call SetProps
	MOVLW b'00000001' ; Clearing display
	call SetProps
	
StartHighScore
	MOVLW b'10000000' ; setcursor
	call SetProps
	MOVLW 'T' ; Write
	call WriteLCD
	MOVLW 'I' ; Write
	call WriteLCD
	MOVLW 'M' ; Write
	call WriteLCD
	MOVLW 'E' ; Write
	call WriteLCD
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW 'O' ; Write
	call WriteLCD
	MOVLW 'U' ; Write
	call WriteLCD
	MOVLW 'T' ; Write
	call WriteLCD
	goto StartHighScore
	
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

Delay1m 
	movlw .1
	movwf 0x32, A
intDel	incf 0x32,F,A
	btfss STATUS,2,A
	goto intDel
	return	
	
ending
	end
