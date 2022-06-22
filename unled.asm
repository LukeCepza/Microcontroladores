/// Main.asm
 // Programa para familiarizarse con MPLAB
 // Luis Kevin Cepeda Zapata A00824840
 // Rodrigo Hugues Gudiño    A01620071
    RADIX DEC	
    PROCESSOR 18F45K50
    #include "pic18f45k50.inc"
    #define Led_status 0x01
    #define bf 0x02
    #define vara 0x10
    #define varb 0x11
// Memory Allocation
    
    PSECT resetVec, class=CODE, reloc=2, abs
    ORG 0 //indica que es el inicio del codigo 
// Reset Vector
    
resetVec:
    ORG 32  //La instrucción Start se guarda en 32
    GOTO Start // Ir a etiqueta Start
    
// Start: 
Start:
    MOVLB 15	  //Carga el valor 15 al registro BSR
    clrf LATB, 0  // Limpiamos la salida de puerto B
    clrf TRISB, 0 // Cnfiguramos puerto B como salida
    clrf LATC, 0
    setf TRISC, 0
    clrf ANSELC, 0
    bcf ANSELC,2
    bcf ANSELC,6
    bcf ANSELC,7
    movlw 1	  
    movwf Led_status, 0
    goto blink

main:
blink_i:
    clrf bf
    call delay_20ms
    btfss PORTC, 0,0 
    goto blink_i
    btfss PORTC, 1,0
    goto blink_i
    btfss PORTC, 2,0
    goto blink_i
blink:
    //mover a wreg el ultimo valor del led
    movf Led_status, 0, 0
    //Blink
    movwf LATB, 0
    call delay_800ms
    clrf LATB, 0
    call delay_800ms
    //Checar si se presionon algun boton
    btfss PORTC, 0,0
    goto rot_lr_i
    btfss PORTC, 1,0
    goto rot_rl_i
    btfss PORTC, 2,0
    goto rot_bf_i
    goto blink
    
rot_lr_i:
    call delay_20ms
    btfss PORTC, 0, 0
    goto rot_lr_i
    
rot_lr:
    RRNCF Led_status, 1, 0
    movf Led_status,0,0
    clrf LATB, 0
    movwf LATB, 0
    call delay_800ms
    
    //Si estamos en adelante a atra'. No continua a revisar PC1
    btfsc bf, 0,0
    goto rot_bf
    
    btfss PORTC, 0, 0
    goto blink_i
    goto rot_lr

rot_rl_i:
    call delay_20ms
    btfss PORTC, 1, 0
    goto rot_rl_i
    
rot_rl:
    RLNCF Led_status, 1, 0
    movf Led_status,0,0
    clrf LATB, 0
    movwf LATB, 0
    call delay_800ms
    //Si estamos en adelante a atra'. No continua a revisar PC1
    btfsc bf, 0,0
    goto rot_bf
    
    btfss PORTC, 1, 0
    goto blink_i
    goto rot_rl

rot_bf_i:
    call delay_20ms
    btfss PORTC, 2, 0
    goto rot_bf_i
    movlw 1 //Primer bit significa que estamos en adelante a atras 
    movwf bf, 0
    
rot_bf:
    btfss PORTC, 2, 0
    goto blink_i
    btfsc Led_status, 7, 0
	call chg_bf_lr
    btfsc Led_status, 0, 0
	call chg_bf
    btfsc bf, 1, 0
	goto rot_rl
    btfss bf, 1, 0
	goto rot_lr

    goto rot_bf
chg_bf_lr:
    bsf bf, 1
chg_bf:
    btg bf, 1
    return
    
delay_800ms:
    movlw 50
    movwf vara, 0
    movwf varb, 0
loop:
    decfsz varb,1,0
    goto loop
    decfsz vara,1,0
    goto loop
    return

delay_20ms:
    movlw 10
    movwf vara, 0
    movwf varb, 0
loop2:
    decfsz varb,1,0
    goto loop
    decfsz vara,1,0
    goto loop2
    return
//
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


