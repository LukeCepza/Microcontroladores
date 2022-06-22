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

ConfLED_Mat_GR
	movlb   .15 ;configuración revisar botones
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
ConfButton
	movlb   .15 ;configuración revisar botones
	CLRF    ANSELB,BANKED
	BCF	INTCON2,7
	MOVLW   B'00111000'  ;A0-A2 Output; A3-A6 Input
	MOVWF   TRISB ;A0-A2 Output; A3-A6 Input
	MOVWF   WPUB  ; Activar pull-up resistor
MultiKey
	MOVLW   b'11111110' ;RA0 COLUMNA RB3,RB4,RB5 Valores 0,1,2,3,4
	MOVWF   LATB
	BTFSS   PORTB,3
	GOTO    D1
	BTFSS   PORTB,4
	GOTO    D4
	BTFSS   PORTB,5
	GOTO    D7

	MOVLW   b'11111101' ;RA1 COLUMNA RB3,RB4,RB5 Valores 0,1,2,3,4
	MOVWF   LATB
	BTFSS   PORTB,3
	GOTO    D2
	BTFSS   PORTB,4
	GOTO    D5
	BTFSS   PORTB,5
	GOTO    D8

	MOVLW   b'11111011' ;RA2 COLUMNA RB3,RB4,RB5 Valores 0,1,2,3,4
	MOVWF   LATB
	BTFSS   PORTB,3
	GOTO    D3
	BTFSS   PORTB,4
	GOTO    D6
	BTFSS   PORTB,5
	GOTO    D9
        GOTO    MultiKey
	
 ;INPUT Si se presiona algún botón, se le asigna ese valor a W y se manda directo a los Leds
D1 		
	BTFSC PORTB, 3
	goto D1
;	MOVLW b'10000000' ; setcursor
;	call SetProps
	MOVLW '1' ; setcursor
	call WriteLCD
	GOTO    MultiKey

D4
	BTFSC PORTB, 4
	goto D4
;	MOVLW b'10000000' ; setcursor
;	call SetProps
	MOVLW '4' ; setcursor
	call WriteLCD
	GOTO    MultiKey
D7
	BTFSC PORTB, 5
	goto D7
;	MOVLW b'10000000' ; setcursor
;	call SetProps
	MOVLW '7' ; setcursor
	call WriteLCD
	GOTO    MultiKey
D2
		BTFSC PORTB, 3
	goto D2
;	MOVLW b'10000000' ; setcursor
;	call SetProps
	MOVLW '2' ; setcursor
	call WriteLCD
	GOTO    MultiKey
D5
	BTFSC PORTB, 4
	goto D5
;	MOVLW b'10000000' ; setcursor
;	call SetProps
	MOVLW '5' ; setcursor
	call WriteLCD
	GOTO    MultiKey
D8
	BTFSC PORTB, 5
	goto D8
;	MOVLW b'10000000' ; setcursor
;	call SetProps
	MOVLW '8' ; setcursor
	call WriteLCD
	GOTO    MultiKey
D3
	BTFSC PORTB, 3
	goto D3
;	MOVLW b'10000000' ; setcursor
;	call SetProps
	MOVLW '3' ; setcursor
	call WriteLCD
	GOTO    MultiKey
D6
	BTFSC PORTB, 4
	goto D6
;	MOVLW b'10000000' ; setcursor
;	call SetProps
	MOVLW '6' ; setcursor
	call WriteLCD
	GOTO    MultiKey
D9
	BTFSS PORTB, 5
	goto D9
;	MOVLW b'10000000' ; setcursor
;	call SetProps
	MOVLW '9' ; setcursor
	call WriteLCD
	GOTO    MultiKey

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

Delay25ms
	movlw .235
	movwf 0x33, A
	incf 0x33,F,A
	btfss STATUS,2,A
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


