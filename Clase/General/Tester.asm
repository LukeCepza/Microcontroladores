	    #include "p18f45k50.inc"
	    org 0x00
	    goto START
;W equ 0
;F equ 1
;A equ 0
;BANKED equ 1
	    
START	
	    movlb .15
	    clrf ANSELB, BANKED
	    clrf TRISB, A
	    movlw  b'01010101'
	    movwf LATB, A
loop	    goto loop
	    end
	    
e1	    org 0x44
	    movlb .7
	    org 0x50
e2	    movlw 0x40
	    movwf 0x40, BANKED
	    movlb b'11'
	    movwf 0x40, 1
	    addwf 0x40,0,A
	    dcfsnz BSR,0,0
	    setf BSR, 0
	    movwf 0x33, A
	    incfsz BSR, 1,0
	    movlw 0x01
	    movwf 0x30,A
	    btfss BSR,2,A
	    goto e1
	    nop
	    nop
	    end