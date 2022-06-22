 	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)7 
	;Registro asociado al RNGsus
	#define RNGsus 0x08, A
	; Registros para orden Sequence
	#define Seq1 0x09, A
	#define Seq2 0x0A, A
	#define Seq3 0x0B, A
	#define Seq4 0x0C, A
	#define Seq5 0x0D, A
	#define Seq6 0x0E, A
	#define Seq7 0x0F, A
	#define Seq8 0x10, A
	#define Seq9 0x11, A
	#define Seq10 0x12, A
; Registro asociado al LCD
        org 0x20
start

	movlw .199
	movwf RNGsus
	movlw .7
	movwf Seq1
	mulwf WREG, W	
	Mulwf Seq1
	nop
    end