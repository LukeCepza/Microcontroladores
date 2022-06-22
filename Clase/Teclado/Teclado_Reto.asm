RADIX	    DEC		;SET DECIMAL AS DEFAULT BASE
    PROCESSOR   18F45K50	;SET PROCESSOR TYPE
    #INCLUDE    <p18F45K50.inc>
    
    ORG 0X00
    
VAR1 EQU	0
VAR2 EQU	1

    movlb   15 ;configuración revisar botones
    CLRF    ANSELB,BANKED
    CLRF    ANSELD,BANKED
    BCF	    INTCON2,7
    MOVLW   B'01111100' 
    MOVWF   TRISB ;B0 B1 output , B2-B6 input
    CLRF    TRISD ;Puerto dsalida -> para los leds
    MOVWF   WPUB  ; Activar pull-up resistors de puerto b en entradas
    ;CLRF    LATD  ;Set A0-A9 Low
    
SETUP ;OUTPUT 
    MOVLW   b'11111110' ;RB0 COLUMNA RB2,RB3,RB4,RB5,RB6 con Valores 0,1,2,3,4
    MOVWF   LATB
    BTFSS   PORTB,6
    GOTO    CERO
    BTFSS   PORTB,5
    GOTO    UNO
    BTFSS   PORTB,4
    GOTO    DOS
    BTFSS   PORTB,3
    GOTO    TRES
    BTFSS   PORTB,2
    GOTO    CUATRO   
    
    MOVLW   b'11111101' ;RB1 COLUMNA RB2,RB3,RB4,RB5,RB6 con Valores 5,6,7,8,9
    MOVWF   LATB
    BTFSS   PORTB,6
    GOTO    CINCO
    BTFSS   PORTB,5
    GOTO    SEIS
    BTFSS   PORTB,4
    GOTO    SIETE
    BTFSS   PORTB,3
    GOTO    OCHO
    BTFSS   PORTB,2
    GOTO    NUEVE   

    goto SETUP
 ;INPUT Si se presiona algún botón, se le asigna ese valor a W y se manda directo a los Leds
CERO ;botón del número cero
    MOVLW   D'0' 
    MOVWF   LATD
    GOTO SETUP 
UNO ;Columna1   botón del número uno
    MOVLW   D'1' 
    MOVWF   LATD
    GOTO SETUP 
DOS ;Columna 2  botón del  número dos
    MOVLW   D'2' 
    MOVWF   LATD
    GOTO SETUP 
TRES ; Columna 3 ;botón del número tres
    MOVLW   D'3' 
    MOVWF   LATD
    GOTO SETUP 
CUATRO ;botón del número cuatro
    MOVLW   D'4' 
    MOVWF   LATD
    GOTO SETUP
CINCO ;botón del número cinco 
    MOVLW   D'5' 
    MOVWF   LATD
    GOTO SETUP 
SEIS ;botón del número seis
    MOVLW   D'6' 
    MOVWF   LATD
    GOTO SETUP 
SIETE ;botón del número siete
    MOVLW   D'7' 
    MOVWF   LATD
    GOTO SETUP 
OCHO ;botón del número ocho
    MOVLW   D'8' 
    MOVWF   LATD
    GOTO SETUP 
NUEVE ;botón del número nueve
    MOVLW   D'9' 
    MOVWF   LATD
    GOTO SETUP 

;   
;    ; CONFIGURATION BITS SETTING, THIS IS REQUIRED TO CONFITURE THE OPERATION OF THE MICROCONTROLLER
;; AFTER RESET. ONCE PROGRAMMED IN THIS PRACTICA THIS IS NOT NECESARY TO INCLUDE IN FUTURE PROGRAMS
;; IF THIS SETTINGS ARE NOT CHANGED. SEE SECTION 26 OF DATA SHEET. 
;;   
;
;
;; CONFIG1L
;  CONFIG  PLLSEL = PLL4X        ; PLL Selection (4x clock multiplier)
;  CONFIG  CFGPLLEN = OFF        ; PLL Enable Configuration bit (PLL Disabled (firmware controlled))
;  CONFIG  CPUDIV = NOCLKDIV     ; CPU System Clock Postscaler (CPU uses system clock (no divide))
;  CONFIG  LS48MHZ = SYS24X4     ; Low Speed USB mode with 48 MHz system clock (System clock at 24 MHz, USB clock divider is set to 4)
;
;; CONFIG1H
;  CONFIG  FOSC = INTOSCIO       ; Oscillator Selection (Internal oscillator)
;  CONFIG  PCLKEN = ON           ; Primary Oscillator Shutdown (Primary oscillator enabled)
;  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor (Fail-Safe Clock Monitor disabled)
;  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover (Oscillator Switchover mode disabled)
;
;; CONFIG2L
;  CONFIG  nPWRTEN = OFF         ; Power-up Timer Enable (Power up timer disabled)
;  CONFIG  BOREN = SBORDIS       ; Brown-out Reset Enable (BOR enabled in hardware (SBOREN is ignored))
;  CONFIG  BORV = 190            ; Brown-out Reset Voltage (BOR set to 1.9V nominal)
;  CONFIG  nLPBOR = OFF          ; Low-Power Brown-out Reset (Low-Power Brown-out Reset disabled)
;
;; CONFIG2H
;  CONFIG  WDTEN = OFF           ; Watchdog Timer Enable bits (WDT disabled in hardware (SWDTEN ignored))
;  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscaler (1:32768)
;
;; CONFIG3H
;  CONFIG  CCP2MX = RC1          ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
;  CONFIG  PBADEN = ON           ; PORTB A/D Enable bit (PORTB<5:0> pins are configured as analog input channels on Reset)
;  CONFIG  T3CMX = RC0           ; Timer3 Clock Input MUX bit (T3CKI function is on RC0)
;  CONFIG  SDOMX = RB3           ; SDO Output MUX bit (SDO function is on RB3)
;  CONFIG  MCLRE = ON            ; Master Clear Reset Pin Enable (MCLR pin enabled; RE3 input disabled)
;
;; CONFIG4L
;  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset (Stack full/underflow will cause Reset)
;  CONFIG  LVP = ON              ; Single-Supply ICSP Enable bit (Single-Supply ICSP enabled if MCLRE is also 1)
;  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port Enable (ICPORT disabled)
;  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled)
;  
   END