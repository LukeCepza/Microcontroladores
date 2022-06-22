 	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto SetupAll
	#define RS  LATE, 0, A ;RS 
	#define E   LATE, 2, A ;Estatus 
	#define RW  LATE, 1, A ;Comando E 
	#define dataLCD LATD, A ;Puerto del LCD 
R1 EQU 0x32
R2 EQU 0x33
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
	CLRF   TRISA, A ;A0-A7 Output
	Call OffAll
	CLRF ANSELC, BANKED
	CLRF TRISC, A
	
LCDproperties 
	MOVLW b'00111000' ; escritura en dos líneas: DL = 8bit; N = 2 lines; F= 5x7
	call SetProps
	MOVLW b'00001100' ; Encender Display, sin cursor activo: D = 1; C = 0;B =0
	call SetProps
	MOVLW b'00000110' ; Configurar desplazamiento incremental: I/D = 1
	call SetProps
 	MOVLW b'00000001' ; Clearing display
	call SetProps
	
DispLEDS
	call On1
	call QrtSc
	call On2
	call QrtSc
	call On3
	call QrtSc
	call On4
	call QrtSc
	call On5
	call QrtSc
	call On6
	call QrtSc
	call On7
	call QrtSc
	call OnAll
	call QrtSc
	call On9
	call QrtSc
	
	call OnGreen
	call QrtSc
	call OnRed
	call QrtSc
	
	call OffAll
	call QrtSc
	goto DispLEDS
	
OnRed	bcf LATC, 1, A
	bsf LATC, 0, A
	return
	
OnGreen bsf LATC, 1, A
	bcf LATC, 0, A
	return 
	
On1	movlw b'00001110'
	movwf LATA, A
	return
On2	movlw b'00010110'
	movwf LATA, A
	return	
On3	movlw b'00100110'
	movwf LATA, A
	return
On4	movlw b'00001101'
	movwf LATA, A 
	return
On5	movlw b'00010101'
	movwf LATA, A
	return
On6	movlw b'00100101'
	movwf LATA, A
	return
On7	movlw b'00001011'
	movwf LATA, A
	return
On8	movlw b'00010011'
	movwf LATA, A
	return
On9     movlw b'00100011'
	movwf LATA, A
	return
	
OffAll
	Movlw b'00000111' ; A543 , A210
	movwf LATA, A
	return
OnAll
	movlw b'00111000'
	movwf LATA, A
	return
	
ConfButton
	movlb   .15 ;configuración revisar botones
	CLRF    ANSELB,BANKED
	BCF	INTCON2,7
	MOVLW   B'00111000'  ;A0-A2 Output; A3-A6 Input
	MOVWF   TRISB ;A0-A2 Output; A3-A6 Input
	MOVWF   WPUB  ; Activar pull-up resistor


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

QrtSc	nop
	nop
	nop
	nop
	movlw .8	;  1C
	movwf R1, A	;  1C
		        ; COU2 = .12 ... R1 = 256-7 = 248  
ret	nop		;  1C*R1
	movlw .6	;  1C*R1
	movwf R2, A	;  1C*R1		
		        ;  R2 = .14 ... R2 = 256-6 = 250
	incf R1,F,A	;  1C*R1
	btfsc STATUS,C,A;  2C*(R1-1) + 1C
	return		;  2C
reta	incf R2, F,A	;  1C*R2*R1
	btfss STATUS,C, A; 1C*R2*(R1-1) + 2*R1
	goto reta	;  2C*(R2-1)*R1
	goto ret	;  2C*R1
	
ending
	end
