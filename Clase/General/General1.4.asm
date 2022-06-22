	    #include "p18f45k50.inc"
	    processor 18f45k50 	; (opcional)
	    org 0x00
	    goto START
CpR equ 0x10
START	
	    movlw 55
	    clrf CpR
	    btfsc WREG, 6, A
	    bsf CpR, 4, A
	    btfsc WREG, 5, A
	    bsf CpR, 3, A
	    btfsc WREG, 4, A
	    bsf CpR, 2, A
	    btfsc WREG, 3, A
	    bsf CpR, 1, A
	    btfsc WREG, 2, A
	    bsf CpR, 0, A
	    nop
	    end