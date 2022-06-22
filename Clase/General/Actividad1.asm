	    #include "p18f45k50.inc"
	    processor 18f45k50 	; (opcional)
	    org 0x00
	    goto START
	    org 0x08 		; posición para interrupciones
	    retfie
	    org 0x18		; posición para interrupciones
	    retfie
	    org 0x30 		; Origen real (opcional pero recomendado)

    BITIF   EQU 0x01
    REGIF   EQU 0x30
    REGMOV  EQU 0x42
  
  
    START
	    setf 0x20
	    setf 0x2a
	    clrf 0x42
	    ;bsf REGIF, BITIF, A
	    goto RISE_RL
    RISE_RL
	    bsf REGMOV, 0, A
	    bsf REGMOV, 1, A
	    bsf REGMOV, 2, A
	    bsf REGMOV, 3, A
	    bsf REGMOV, 4, A
	    bsf REGMOV, 5, A
	    bsf REGMOV, 6, A
	    bsf REGMOV, 7, A

	    btfss REGIF,BITIF,A
	    goto SIT_RL
	    goto SIT_LR
	    ;BTFSS:Revisa(verdadero) si el bit (salta si bit==1)
	    ;BTFSC:Revisa(verdadero) si el bit (salta si bit==0)
    SIT_RL
	    bcf REGMOV, 0, A
	    bcf REGMOV, 1, A
	    bcf REGMOV, 2, A
	    bcf REGMOV, 3, A
	    bcf REGMOV, 4, A
	    bcf REGMOV, 5, A
	    bcf REGMOV, 6, A
	    bcf REGMOV, 7, A
	    goto ending
    SIT_LR	
	    bcf REGMOV, 7, A
	    bcf REGMOV, 6, A
	    bcf REGMOV, 5, A
	    bcf REGMOV, 4, A
	    bcf REGMOV, 3, A
	    bcf REGMOV, 2, A
	    bcf REGMOV, 1, A
	    bcf REGMOV, 0, A
	    goto ending
    ending
	    goto START
	    nop
	    end


	
