 	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto retardo2
retardo2
	org 0x20
	; Retardo espera2 = 65536 CI o ms (4Mhz) con prescalador de 8 = 524288 CI o ms (4Mhz)
	; Queremos que sean 500000 CI es decir quitamos 24288 / 8 CI de TMR3
	; 3036 = b'0000 1011 1101 1100'
	; TMR3H = 0000 1011
	; TMR3L = 1101 1100
	; Con esto repetimos espera2 20 veces y sera suficiente para tener un retardo de 10s
	movlw b'00110010'
	movwf T3CON, A
	bcf T1GCON,7,A;

	call espera10s
	goto ending 
espera10s movlw .21
	movwf 0x01, A ; usamos registro 0x01 como contador para hacer 20 veces
esp2m   movlw b'00001011' ;Si desborda, comenzar desde donde definimos
	movwf TMR3H, A
	movlw b'11011100'
	movwf TMR3L, A
	bcf PIR2,1 ,A    ;Bajar bandera de desboradamiento
	bsf T3CON, 0, A;
	decf 0x01
	btfss STATUS, Z, A
	goto esp2
	return
esp2	btfss PIR2, 1, A ; espera 500000 CI y 2 de return
	goto esp2
	goto esp2m

ending
	end