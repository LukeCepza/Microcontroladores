#include"p18f45k50.inc"
    org 0x00
    goto configura
configura
    org 0x20
    movlb d'15' ;Selectlastbank(SFRs)
    clrf ANSELB, BANKED ;Forces digital I/O
    bcf INTCON2,7,A ;Enables global pull-up
    movlw b'11110000';50 - 50 I/O 
    movwf TRISB, A  
    movwf WPUB, A ;Enables pull-up on inputs
    clrf TRISD,A
    setf LATB,A;'Normal'logiclevels
start
    clrf LATD,A;Clearoutputs
chkC3	
    movlw b'10111111'
    movwf LATB,A;Enablesscanningofthirdcolumn
    btfss PORTB,2,A;ChecksA
    goto keyA
    btfss PORTB,3,A;ChecksB
    goto keyB
    goto chkC3
keyA 
    call espera20
    btfss PORTB,2,A;ChecksifAreleased
    goto keyA
    decf LATD,F,A;Increasebinarycounter
    goto chkC3;backtomain
keyB
    call espera20
    btfss PORTB,3,A
    goto keyB
    incf LATD,F,A
    goto chkC3
espera20
    ;20msdelay
    return
    end