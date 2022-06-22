/// P8_2.asm
 // Demostración #8 - Ejercicio 2
 // Luis Kevin Cepeda Zapata A00824840
 // Rodrigo Hugues Gudiño    A01620071
    RADIX DEC	
    PROCESSOR 18F45K50
    #include "pic18f45k50.inc"
    #define vara	0x01 //timer
    #define varb	0x02 //timer
    #define SUMADOR	0x03 //Guarda el valor del prescalador
    #define LED_status	0x04
// Memory Allocation
    PSECT resetVec, class=CODE, reloc=2, abs
    ORG 0	    //indica que es el inicio del codigo

// Reset Vector
resetVec:
    ORG 32		//La instrucción Start se guarda en 32
    goto Start
    
Start:   
    MOVLB 15	    //Carga el valor 15 al registro BSR
    // LEDS
    clrf LATA, 0    // Limpiamos la salida de puerto A
    clrf TRISA, 0   // Cnfiguramos puerto A como salida
    // LECTURA:
    setf TRISB, 0   //Configuramos el puerto B como entrada
    clrf ANSELB, 0  //Configuramos el puerto B como entrada digita
congig:
    MOVLW   0b00000111
    MOVWF   SUMADOR, 0
    MOVLW   0b00000000
    MOVWF   LED_status, 0
    
configdelay:
    movf   SUMADOR
    MOVwf   T0CON, 0   // Se carga el valor prescalador, stop, 16 bits
    
    MOVLW   0b00101110
    MOVWF   TMR0L, 0
    MOVLW   0b11111100
    MOVWF   TMR0H, 0
    NOP 
    NOP
    BSF	    T0CON, 7, 0	    //ENABLE
    
Looper:
    btfss   PORTB, 0,0	//boton 1?
    goto    SUMAR	//subrutina 250ms
    btfss   PORTB, 2,0	//boton 0?
    clrf    LED_status, 0	//limpiar estatus
    btfss   PORTB, 1,0	//boton 3?
    call    pause_i	//subrutina 1000ms
    
    BTFSS   INTCON, 2,0 //Revisar si desbordó
    goto    Looper
    incf    LED_status,1, 0 
    
    MOVFF   LED_status, LATA //toggle led
    BCF	    INTCON, 2,0		
    goto    configdelay
       
SUMAR:
    call  delay_20ms 
    btfss PORTB, 0,0	
    goto  SUMAR	//antirebote
    decf  SUMADOR, 1, 0
    movlw 2
    subwf SUMADOR, 0, 0
    btfsc STATUS, 2, 0
    call  restart_sumador
    GOTO  configdelay        //Se va a imprimir

pause_i: //subrutia antirebote para ir a la subrutina de pausa
    call delay_20ms	//Antirebote
    btfss PORTB, 1, 0	//Antirebote
    goto pause_i	//Antirebote
pause: // ciclo infinito hasta que se detecte el puert 6 otra vez.
    btfss PORTB, 1,0
    goto pause_return
    goto pause		//ITera pausa
pause_return: //subrutia antirebote para salir de la subrutina pausa. Como se uso call
    // en vez de goto, se tuvo que hacer este segmento.
    call delay_20ms	//Antirebote
    btfss PORTB, 1, 0	//antirebote
    goto pause_return	//antirebote
    return    
    
restart_sumador:
    movlw 0b00000111
    movwf SUMADOR,0
    return
    
delay_20ms:
    movlw 15
    movwf vara, 0
    movwf varb, 0
loop:
    decfsz varb,1,0
    goto loop
    decfsz vara,1,0
    goto loop
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