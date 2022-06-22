 	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto retardo1
retardo1
	org 0x20
	movlw b'00110010'
	movwf T1CON, A
	clrf TMR1L, A
	clrf TMR1H, A
	bcf T1GCON,7,A;
	bsf T1CON, 0, A;
	
	call espera
	call espera
	goto ending
	
espera btfss PIR1, 0, A ; espera 524288 CI + 2CI del bcf PIR1 y 2 de return
	goto espera
	bcf PIR1, 0 ,A
	return
ending
	end
	
	
