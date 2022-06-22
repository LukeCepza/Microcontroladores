	    #include "p18f45k50.inc"
	    processor 18f45k50 	; (opcional)
	    org 0x00
	    goto START
PosR	EQU 0x0a
NegR	EQU 0x0b

START
	comf 0x20
	comf 0x22
	comf 0x26
	
	btfss 0x20, 7, A
	call INCPOS
	btfsc 0x20, 7, A
	call INCNEG
	btfss 0x21, 7, A
	call INCPOS
	btfsc 0x21, 7, A
	call INCNEG
	btfss 0x22, 7, A
	call INCPOS
	btfsc 0x22, 7, A
	call INCNEG	
	btfss 0x23, 7, A
	call INCPOS
	btfsc 0x23, 7, A
	call INCNEG	
	btfss 0x24, 7, A
	call INCPOS
	btfsc 0x24, 7, A
	call INCNEG
	btfss 0x25, 7, A
	call INCPOS
	btfsc 0x25, 7, A
	call INCNEG
	btfss 0x26, 7, A
	call INCPOS
	btfsc 0x26, 7, A
	call INCNEG
	btfss 0x27, 7, A
	call INCPOS
	btfsc 0x27, 7, A
	call INCNEG
	btfss 0x28, 7, A
	call INCPOS
	btfsc 0x28, 7, A
	call INCNEG
	btfss 0x29, 7, A
	call INCPOS
	btfsc 0x29, 7, A
	call INCNEG
	
	goto ending
	
INCNEG  incf NegR
	return
INCPOS  incf PosR
	return	
ending	nop
	end
	
	