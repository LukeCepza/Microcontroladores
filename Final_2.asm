// Final.asm
 // Demostración #10 - Comunicacion EUSART
 // Luis Kevin Cepeda Zapata A00824840
 // Rodrigo Hugues Gudiño    A01620071
    RADIX DEC	
    PROCESSOR 18F45K50
    #include "pic18f45k50.inc"
    #define RXread 0x01
    #define TMR0_FB INTCON, 2
    #define Led_status_bit 0x02, 0
// Memory Allocation
    PSECT resetVec, class=CODE, reloc=2, abs
    ORG 0	    //indica que es el inicio del codigo 

    ORG 8 
    btfsc TMR0_FB, 0 //Revisar si la bandera de interrupción se activó 
    goto blinker
    
resetVec:
    ORG 32	    //La instrucción Start se guarda en 32
    goto setup
setup:
//puertos
    MOVLB 15	    

//RX    
    clrf ANSELC
    bsf TRISC, 7 //Configuramos puerto C como entrada RX 
    bcf TRISC, 6
    bcf ANSELC, 7  //Configuramos el puerto B como entrada digital	   (2)**
    bcf ANSELC, 6
    
    movlw 25	//Carga el valor 12 al registro high y low de SPBRG	   (1)**
    movwf SPBRG1
    clrf SPBRGH1

    movlw 0b10010000
    movwf RCSTA1
    movlw 0b00100000
    movwf TXSTA1
    
    MOVLW   114//0x72//0b00110010
    MOVWF   OSCCON
    
// timer0    
    MOVLW   0b00000101
    MOVWF   T0CON, 0
    BSF INTCON, 7 //Global INterrupt enable 
    BSF INTCON, 5 //Overflow enable
    BCF INTCON2, 2
    call RSTMR0

// PWM
    bcf TRISC, 2
    MOVLW   199
    MOVWF   PR2
    
    MOVLW   180
    MOVF    CCPR1L
   
    clrf TMR2 //Timer en Zero
    clrf    T2CON   //PRESCALADOR DE CERO
    MOVLW 0b00001100  //= PWM mode: PxA active-high; PxB active-high
    MOVWF CCP1CON 
    bsf T2CON, 2 //TMR2 ON
WAITSERIAL: 
    BTFSS PIR1, 5; /RCIF: EUSART Receibe interrupt Flag bit (full 1)	   (8)**
    goto WAITSERIAL
    movf RCREG1, 1				 //(9)**
LED:
    movff RCREG1, RXread
    movf 0x01, 0 //Pasamos la lectura a WREG
    sublw '0' 
    btfsc STATUS, 2, A	//Si la resta del valor de la lectura 
    goto CERO
    
    movf 0x01, 0
    sublw '1'
    btfsc STATUS, 2, A
    goto UNO
    
    movf 0x01, 0
    sublw '2'
    btfsc STATUS, 2, A
    goto DOS

    movf 0x01, 0
    sublw '3'
    btfsc STATUS, 2, A
    goto TRES
    
    movf 0x01, 0
    sublw '4'
    btfsc STATUS, 2, A
    goto CUATRO
    
    movf 0x01, 0
    sublw '5'
    btfsc STATUS, 2, A
    goto CINCO
    goto NIUNO

CERO: 
    bcf T0CON, 7    
    MOVLW 180
    MOVWF CCPR1L
    goto WAITSERIAL
UNO:
    bcf T0CON, 7    
    MOVLW 140
    MOVWF CCPR1L
    goto WAITSERIAL
DOS:
    bcf T0CON, 7    
    MOVLW 120
    MOVWF CCPR1L    
    goto WAITSERIAL
TRES:
    bcf T0CON, 7    
    MOVLW 80
    MOVWF CCPR1L    
    goto WAITSERIAL
CUATRO:
    bcf T0CON, 7    
    MOVLW 40
    MOVWF CCPR1L    
    goto WAITSERIAL
CINCO:
    bcf T0CON, 7    
    MOVLW 5
    MOVWF CCPR1L
    goto WAITSERIAL
NIUNO:
    //Se quiere que el timer haga 62500 cuentas es decir se precarga con el
    // valor 3036 = 0b 0000 1011 1101 1100
    bsf T0CON, 7
    goto WAITSERIAL    
    
blinker:
    btfsc Led_status_bit
    goto off
    goto on
off:
    MOVLW 180
    MOVWF CCPR1L
    call RSTMR0
    retfie
on:    
    MOVLW 5
    MOVWF CCPR1L  
    call RSTMR0
    retfie
    
RSTMR0:
    MOVLW   0b10000000
    MOVWF   TMR0L, 0
    MOVLW   0b11100001
    MOVWF   TMR0H,0 
    bcf TMR0_FB // clear flag
    bsf T0CON, 7 //STart timer
    return
 // CONFIGURATION BITS SETTING, THIS IS REQUIRED TO CONFITURE THE OPERATION OF THE MICROCONTROLLER
// AFTER RESET. ONCE PROGRAMMED IN THIS PRACTICA THIS IS NOT NECESARY TO INCLUDE IN FUTURE PROGRAMS
// IF THIS SETTINGS ARE NOT CHANGED. SEE SECTION 26 OF DATA SHEET. 
//   
// CONFIG1L
    CONFIG  PLLSEL = PLL4X        // PLL Selection (4x clock multiplier)
    CONFIG  CFGPLLEN = OFF        // PLL Enable Configuration bit (PLL Disabled (firmware controlled))
    CONFIG  CPUDIV = NOCLKDIV     // CPU System Clock Postscaler (CPU uses system clock (no divide))
    CONFIG  LS48MHZ = SYS24X4     // Low Speed USB mode with 48 MHz system clock (System clock at 24 MHz, USB clock divider is set to 4)
// CONFIG1H
    CONFIG  FOSC = INTOSCIO       // Oscillator Selection (Internal oscillator) 
    CONFIG  PCLKEN = ON           // Primary Oscillator Shutdown (Primary oscillator enabled)
    CONFIG  FCMEN = OFF           // Fail-Safe Clock Monitor (Fail-Safe Clock Monitor disabled)
    CONFIG  IESO = OFF            // Internal/External Oscillator Switchover (Oscillator Switchover mode disabled)
// CONFIG2L
    CONFIG  nPWRTEN = OFF         // Power-up Timer Enable (Power up timer disabled)
    CONFIG  BOREN = SBORDIS       // Brown-out Reset Enable (BOR enabled in hardware (SBOREN is ignored))
    CONFIG  BORV = 190            // Brown-out Reset Voltage (BOR set to 1.9V nominal)
    CONFIG  nLPBOR = OFF          // Low-Power Brown-out Reset (Low-Power Brown-out Reset disabled)
// CONFIG2H
    CONFIG  WDTEN = OFF           // Watchdog Timer Enable bits (WDT disabled in hardware (SWDTEN ignored))
    CONFIG  WDTPS = 32768         // Watchdog Timer Postscaler (1:32768)
// CONFIG3H
    CONFIG  CCP2MX = RC1          // CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
    CONFIG  PBADEN = OFF          // PORTB A/D Enable bit (PORTB<5:0> pins are configured as analog input channels on Reset)
    CONFIG  T3CMX = RC0           // Timer3 Clock Input MUX bit (T3CKI function is on RC0)
    CONFIG  SDOMX = RB3           // SDO Output MUX bit (SDO function is on RB3)
    CONFIG  MCLRE = ON            // Master Clear Reset Pin Enable (MCLR pin enabled; RE3 input disabled)
// CONFIG4L
    CONFIG  STVREN = ON           // Stack Full/Underflow Reset (Stack full/underflow will cause Reset)
    CONFIG  LVP = ON              // Single-Supply ICSP Enable bit (Single-Supply ICSP enabled if MCLRE is also 1)
    CONFIG  ICPRT = OFF           // Dedicated In-Circuit Debug/Programming Port Enable (ICPORT disabled)
    CONFIG  XINST = OFF           // Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled)
//
// DEFAULT CONFIGURATION FOR THE REST OF THE REGISTERS
//
    CONFIG  CONFIG5L = 0x0F	  // BLOCKS ARE NOT CODE-PROTECTED
    CONFIG  CONFIG5H = 0xC0	  // BOOT BLOCK IS NOT CODE-PROTECTED
    CONFIG  CONFIG6L = 0x0F	  // BLOCKS NOT PROTECTED FROM WRITING
    CONFIG  CONFIG6H = 0xE0	  // CONFIGURATION REGISTERS NOT PROTECTED FROM WRITING
    CONFIG  CONFIG7L = 0x0F	  // BLOCKS NOT PROTECTED FROM TABLE READS
    CONFIG  CONFIG7H = 0x40	  // BOOT BLOCK IS NOT PROTECTED FROM TABLE READS
       
    END resetVec





