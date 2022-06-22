	    #include "p18f45k50.inc"
	    processor 18f45k50 	; (opcional)
	    org 0x00
	    goto START
Reg1 equ .16
SIGN equ .32
 
START
	    btfss Reg1, 0, A
	    bsf SIGN, 0, A
	    btfsc Reg1, 0 ,A
	    bsf SIGN, 1, A
	    nop 
	    end
	    
	    
;	    btfsc Reg1, 0, A
;		goto case1
;		goto casi2
;	case1
;	    bsf SIGN, 1, A
;	    goto enging
;	case2
;	    bsf SIGN, 0, A
;enging	    end