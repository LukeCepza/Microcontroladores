;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;/// CODE IN ASSEMBLER TO PRINT CHARACTERS IN AN LCD
;/// USING PIC16f877A
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
LIST P=16f877A ;Indica el tipo de procesador a programar
 INCLUDE "P16F877A.INC" ;Incluye en el programa el fichero de definiciones del uC seleccionado
 __CONFIG _CP_OFF& _DEBUG_OFF& _WRT_OFF& _CPD_OFF& _LVP_OFF& _BODEN_OFF& _PWRTE_ON& _WDT_OFF& _XT_OSC
 
ORG 0x00 
 BCF STATUS,RP1 ; Selection of memory bank 1
 BSF STATUS,RP0 
 CLRF TRISB ; Configuration of PORT B as output (Data pins LCD)
 CLRF TRISD ; Configuration of PORT D as output (RD0-R/S, RD1-E)
 
MOVLW b'00000111'
 MOVWF OPTION_REG ; Configuration of Option Register (TMR0 Rate = 1:256)
 
BCF STATUS,RP0 ; Selection of memory bank 0
 CLRF PORTB ; Setting PORTB to "0000000"
 CLRF PORTD ; Setting PORTD to "0000000"
 
CALL InitiateLCD
 
LOOP2 CALL PRINTCHAR
 
 GOTO LOOP2
 
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
;///// LCD RUTINA ////////////////////////////////////////////////////////////////////////////////////////////////
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
    InitiateLCD BCF PORTD,RD0 ; Setting RS as 0 (Sends commands to LCD)
 
 CALL DELAY_5ms
 
MOVLW b'00000001' ; Clearing display
 MOVWF PORTB 
 CALL Enable
 CALL DELAY_5ms
 
MOVLW b'00111000' ; Funtion set
 MOVWF PORTB 
 CALL Enable
 CALL DELAY_5ms
 
MOVLW b'00001111' ; Display on off
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms
 
MOVLW b'00000110' ; Entry mod set
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms 
 
 RETURN
 
PRINTCHAR BCF PORTD,RD0 ; Setting RS as 0 (Sends commands to LCD)
 
MOVLW b'00000010' ; Set cursor home
 MOVWF PORTB 
 CALL Enable
 CALL DELAY_5ms
 
 BSF PORTD,RD0 ; Setting RS as 1 (Sends information to LCD)
 
 CALL DELAY_5ms
 
MOVLW d'72' ; Print character "H"
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms
 
MOVLW d'101' ; Print character "e"
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'108' ; Print character "l"
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'108' ; Print character "l"
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'111' ; Print character "o"
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'0' ; Print caracter " "
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms
 
MOVLW d'87' ; Print caracter "W"
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'111' ; Print character "o"
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'114' ; Print character "r"
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'108' ; Print character "l"
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms 
 
 MOVLW d'100' ; Print character "d"
 MOVWF PORTB
 CALL Enable
 CALL DELAY_5ms 
 
 RETURN
 
Enable BSF PORTD,1 ; E pin is high, (LCD is processing the incoming data)
 NOP
 BCF PORTD,1 ; E pin is low, (LCD does not care what is happening)
 RETURN
 
DELAY_5ms MOVLW .5 ; Delay of 5 ms
 MOVWF TMR0
 
LOOP BTFSS INTCON,2
 GOTO LOOP
 BCF INTCON,2
 RETURN
 
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
 
END