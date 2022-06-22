	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto start
start
	movlw b'00000011'
	movwf T0CON, A;
	
	movlw b'10010111'
	movwf TMR0H, A;
	movlw b'01000000'
	movwf TMR0L, A;
	
	bsf T0CON, 7, A;
	call espera
	goto start
	
espera	    btfss INTCON, 2, A
	    goto espera
	    bcf INTCON, 2,A
	return
end