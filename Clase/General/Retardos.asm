	#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
	org 0x00
	goto START

START
R1 EQU 0x32
R2 EQU 0x33
	
START
	nop
	CALL DELAY_5ms
	nop
	call OneSec	; 2C
	nop
	goto START
	
OneSec  call QrtSc    ;2C  -> 250.001ms (250001 Cycles)
        call QrtSc	;2C
        call QrtSc	;2C
        call QrtSc	;2C
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
	
;DELAY_5ms MOVLW .5 ; Delay of 5 ms
; MOVWF TMR0
; 
;LOOP BTFSS INTCON,2
; GOTO LOOP
; BCF INTCON,2
; RETURN
 
	end	