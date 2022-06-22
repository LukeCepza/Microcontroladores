	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto start
	org 0x08 		; posici�n para interrupciones
	retfie
	org 0x18		; posici�n para interrupciones
	retfie
	org 0x30 		; Origen real (opcional pero recomendado)
start		
	 ; ------ Aqu� ir� nuestro c�digo ------
	Movlw 10
	Movwf 0,A
	Movwf 1,A
	Movwf WREG,A
	Movlw 0
	Addwf .1,W,A
	Addwf .2,F,A
	Addlw .2
	Addwf WREG,F,A	
	nop
	end
