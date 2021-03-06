#include "p18f45k50.inc"
    processor 18f45k50
    
    org 0x00
    GOTO SETUP
    
    #define RS LATE,0,A
    #define RW LATE,1,A
    #define E  LATE,2,A
    #define dataLCD LATD,A
    
LEDSTATUS     EQU 0x03
BUTTONSTATUS  EQU 0x04
CONTROLSTATUS EQU 0x05
PRandSEED     EQU 0x06
CONFIG0	      EQU 0x07
TIMER0L	      EQU 0x08
TIMER0H	      EQU 0x10
     
SETUP:  
CONFLCD org   0x20
	MOVLB d'15'
	CLRF  ANSELE, BANKED
	CLRF  TRISE,A
	CLRF  ANSELD, BANKED
	CLRF  TRISD,A
    
LCDProps:
    MOVLW b'00111000'
    CALL SETPROPS
    MOVLW b'00001100'
    CALL SETPROPS
    MOVLW b'00000110'
    CALL SETPROPS
    MOVLW b'00000001'
    CALL SETPROPS
    
ESCRIBIR_LCD:
    MOVLW A'T'
    CALL  MANDAR_LCD
    MOVLW A'I'
    CALL  MANDAR_LCD
    MOVLW A'M'
    CALL  MANDAR_LCD
    MOVLW A'E'
    CALL  MANDAR_LCD
    MOVLW A'-'
    CALL  MANDAR_LCD
    MOVLW A'O'
    CALL  MANDAR_LCD
    MOVLW A'U'
    CALL  MANDAR_LCD
    MOVLW A'T'
    CALL  MANDAR_LCD
    MOVLW A'!'
    CALL  MANDAR_LCD
    CALL  TIMER_5
    RETURN
    
    LOOP GOTO LOOP
    
TIMER_CONFIG:
    MOVFF CONFIG0,T0CON
    MOVFF TIMER0H,TMR0H
    MOVFF TIMER0L,TMR0L
    BCF   INTCON,2
    BSF   T0CON,7
    GOTO  TIMER

SETPROPS:
    BCF RS
    BCF RW
    GOTO Enable
    
MANDAR_LCD:
    BSF RS
    BCF RW
    RETURN

Enable:
    BSF E
    MOVWF dataLCD
    NOP
    BCF E
    CALL DELAY
    RETURN
    
DELAY:
       MOVLW .1
       MOVWF 0x32,A
IntDel INCF  0x32,F,A
       BTFSS STATUS,2,A
       GOTO  IntDel
       RETURN

TIMER:
    BTFSS INTCON,2
    BRA   TIMER
    SETF   LATA,A	    ;Prende el led, MODIFICAR AL TERMINAR EL C?DIGO
    BCF   INTCON,2
    MOVFF TIMER0H,TMR0H
    MOVFF TIMER0L,TMR0L
    GOTO CLEARLCD
    
TIMER_5:
    ;BRA TIMER_5
    MOVLW b'00000110'
    MOVWF CONFIG0
    MOVLW b'01100111'
    MOVWF TIMER0H
    MOVLW b'01101010'
    MOVWF TIMER0L
    GOTO TIMER_CONFIG
    
 CLEARLCD:
    BCF  RS
    BCF  RW
    MOVLW b'00000001'
    MOVWF dataLCD
    RETURN
       END