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
	    clrf 0x42
	    ;bsf REGIF, BITIF, A
	    goto RISE_LR
    RISE_LR
	    btg REGMOV, 0, A
	    btg REGMOV, 1, A
	    btg REGMOV, 2, A
	    btg REGMOV, 3, A
	    btg REGMOV, 4, A
	    btg REGMOV, 5, A
	    btg REGMOV, 6, A
	    btg REGMOV, 7, A

	    btfss REGIF,BITIF,A
	    goto START
	    goto SIT_RL
	    ;BTFSS:Revisa(verdadero) si el bit (salta si bit==1)
	    ;BTFSC:Revisa(verdadero) si el bit (salta si bit==0)
    SIT_LR
	    bcf REGMOV, 0, A
	    bcf REGMOV, 1, A
	    bcf REGMOV, 2, A
	    bcf REGMOV, 3, A
	    bcf REGMOV, 4, A
	    bcf REGMOV, 5, A
	    bcf REGMOV, 6, A
	    bcf REGMOV, 7, A
	    goto ending
    SIT_RL	
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
	    ;goto START
	    nop
	    end
