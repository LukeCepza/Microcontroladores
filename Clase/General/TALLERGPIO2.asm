	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto START
	
W0	equ b'00111111'  ;0     
W1	equ b'00000110'  ; 1         
W2	equ b'01011011'  ;  2        
W3	equ b'01001111'  ;   3       
W4	equ b'01100110'  ;    4      
W5	equ b'01101101'  ;     5     
W6	equ b'01111101'  ;      6    
W7	equ b'00000111'  ;       7   
W8	equ b'01111111'  ;        8 
W9	equ b'01101111'  ;         9

CHK	equ 0x10
	
START 	
	bcf INTCON2, 7, A ; INTCON = 1~~~ ~~~~
	bsf WPUB, 7, A ; WPUB = 1~~~ ~~~~
	movlb .15
	clrf ANSELB, BANKED ; ANSELB = 0000 0000 = 0 digital 1 analogo 
	movlw b'10000000'
	movwf TRISB, BANKED ; TRISB = 1000 0000 = 0 output 1 input
	
set0	movlw cero
 	movwf LATB, BANKED ; LATB = cero decimal
	call READ
set1    movlw uno
 	movwf LATB, BANKED ; LATB = cero decimal
	call READ
set2	movlw dos
 	movwf LATB, BANKED ; LATB = cero decimal
	call READ
set3	movlw tres
 	movwf LATB, BANKED ; LATB = cero decimal
	call READ
set4    movlw cuatro
 	movwf LATB, BANKED ; LATB = cero decimal
	call READ
set5	movlw cinco
 	movwf LATB, BANKED ; LATB = cero decimal
	call READ
set6	movlw seis
 	movwf LATB, BANKED ; LATB = cero decimal
	call READ
set7    movlw siete
 	movwf LATB, BANKED ; LATB = cero decimal
	call READ
set8	movlw ocho
 	movwf LATB, BANKED ; LATB = cero decimal
	call READ
set9	movlw nueve
 	movwf LATB, BANKED ; LATB = cero decimal
	call READ
	goto set0

READ 
kRead	btfss PORTB, 7,A
	goto kRead
	return
	end
