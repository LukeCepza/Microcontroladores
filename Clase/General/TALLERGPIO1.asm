	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto START
START
	movlb .15
	clrf ANSELB, BANKED ; ANSELB = 0000 0000 = 0 digital 1 analogo 
	clrf TRISB, BANKED ; TRISB = 0000 0000 = 0 output 1 input
	
RESTART clrf WREG, A
PRINT   movwf LATB, BANKED ; LATB = WREG = 0 LOW 1 HIGH 
	incf WREG, A
	btfss STATUS,C,A 
	goto PRINT  
	goto RESTART
	end 
	nop
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	