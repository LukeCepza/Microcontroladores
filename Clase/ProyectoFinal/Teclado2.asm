 	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto SetupAll
	#define RS  LATE, 0, A ;RS 
	#define E   LATE, 2, A ;Estatus 
	#define RW  LATE, 1, A ;Comando E 
	#define dataLCD LATD, A ;Puerto del LCD 
VAR1 EQU	0
VAR2 EQU	1
 
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
	MOVLW   B'00000111'  ;A0-A2 Output; A3-A6 Input
	MOVWF   TRISA ;A0-A2 Output; A3-A6 Input
	BCF	INTCON2,7
	MOVWF   WPUB  ; Activar pull-up resistor
ConfLED_Mat_GR
	CLRF    ANSELB,BANKED
	MOVLW   B'00000000'  ;R0-R3 Output Row; R4-R7 Output Column
	MOVWF   TRISB ;R0-R3 Output Row; R4-R7 Output Column
LCDproperties 
	MOVLW b'00111000' ; escritura en dos líneas: DL = 8bit; N = 2 lines; F= 5x7
	call SetProps
	MOVLW b'00001100' ; Encender Display, sin cursor activo: D = 1; C = 0;B =0
	call SetProps
	MOVLW b'00000110' ; Configurar desplazamiento incremental: I/D = 1
	call SetProps
	MOVLW b'00000001' ; Clearing display
	call SetProps
SETUP
	MOVLW   b'11101111' ;RB4 COLUMNA 1 1,4,7,*
	MOVWF   LATA
	BTFSS   PORTA,0
	GOTO    UNO
	BTFSS   PORTA,1
	GOTO    CUATRO
	BTFSS   PORTA,2
	GOTO    SIETE


	MOVLW b'11011111'  ;RB5 COLUMNA 2 DOS, CINCO, OCHO, CERO
	MOVWF LATB

	BTFSS   PORTA,0
	GOTO    DOS
	BTFSS   PORTA,1
	GOTO    CINCO
	BTFSS   PORTA,2
	GOTO    OCHO


	MOVLW b'10111111' ;RB6 COLUMNA 3 TRES,SEIS,NUEVE, #
	MOVWF    LATA

	BTFSS   PORTA,0
	GOTO    TRES
	BTFSS   PORTA,1
	GOTO    SEIS
	BTFSS   PORTA,2
	GOTO    NUEVE

	GOTO SETUP 

     ;INPUT Si se presiona algún botón, se le asigna ese valor a W y se manda directo a los Leds
UNO: ;Columna1   botón del número uno

CUATRO: ;botón del número cuatro

SIETE: ;botón del número siete

ASTERISCO: ;botón del asterisco

DOS: ;Columna 2  botón del  número dos

CINCO: ;botón del número cinco 

OCHO: ;botón del número ocho

CERO: ;botón del número cero

TRES: ; Columna 3 ;botón del número tres

SEIS: ;botón del número seis

NUEVE: ;botón del número nueve

GATO: ;botón del gato
	MOVLW b'10000000' ; setcursor
	call SetProps
	incf 0x01,f,A
        MOVF 0x01,W,A
	call WriteLCD
	GOTO SETUP

DELAY:  ;rutina anti rebote
    MOVLW   0XFF
    MOVWF   VAR1
    MOVWF   VAR2
LOOP1:
    DECFSZ  VAR2
    GOTO    LOOP1
    DECFSZ  VAR1
    GOTO    LOOP1
    RETURN
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
END