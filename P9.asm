 /// P9.asm
 // Demostración #9 - Ejercicio 1
 // Luis Kevin Cepeda Zapata A00824840
 // Rodrigo Hugues Gudiño    A01620071
    RADIX DEC	
    PROCESSOR 18F45K50
    #include "pic18f45k50.inc"
    #define Led_status 0x01 //Este registro guarda la ultima ubicación del LED
    #define side 0x02, 0 //Este registro guarda el sentido de movimiento
    #define pulsecont 0x03 //Este registro guarda el numero de pulsos
    #define B_INT0 INTCON, 1
    #define B_TMR0 INTCON, 2

// Memory Allocation
    PSECT resetVec, class=CODE, reloc=2, abs
    ORG 0	    //indica que es el inicio del codigo 
    
    ORG 8 
    btfsc B_INT0,0 //Revisar si la bandera de interrupción se activó 
    goto interrupcion1  //Si se activó, ir a la subrutina de interrupcion1
// Reset Vector
resetVec:
    ORG 32	    //La instrucción Start se guarda en 32
    goto Main	    // Ir a etiqueta Start
Main:
    MOVLB 15	    //Carga el valor 15 al registro BSR
    // LEDS
    clrf LATA, 0    // Limpiamos la salida de puerto A
    clrf TRISA, 0   // Cnfiguramos puerto A como salida
    // LECTURA: Solo se usa el bit 0 como lectura del boton.
    setf TRISB, 0   //Configuramos el puerto B como entrada
    clrf ANSELB, 0  //Configuramos el puerto B como entrada digital
    clrf pulsecont
//ConfigInterrupciones
    bcf side
    bcf B_INT0
    bsf INTCON, 7, 0
    bcf INTCON, 1, 0
    bsf INTCON, 4, 0//Enable INT0
    bcf INTCON2, 6, 0 //INterrupción extern
    movlw 1
    movwf Led_status
    movff Led_status, LATA // mueve el valor del registro led status a LATA
   
config1s:
    // Se configura el Timer 0 como 16 bits  con preescalador de 1:4
    BCF B_TMR0
    // Se configura el Timer 0 como 16 bits  con preescalador de 1:4
    MOVLW   0b00000100
    MOVWF   T0CON, 0
    //Se quiere que el timer haga 62500 cuentas es decir se precarga con el
    // valor 3036 = 0b 0000 1011 1101 1100
    MOVLW   0b10000000
    MOVWF   TMR0L, 0
    MOVLW   0b11100001
    MOVWF   TMR0H,0
    // Se inicializa el Timer 0
    BSF	T0CON, 7, 0 
    //Se revisa si se ha activado la bandera de desbordamiento del Timer 0
    // es decir si ya paso un segundo.
Delay1s: BTFSS B_TMR0, 0 // se revisa si ya ha pasado un segundo y se activo la 
    // bandera de desbordamiento del Timer 0
    goto Delay1s // en caso de no haberse desbordado continua en el ciclo
    goto rot // si ya se desbordó entonces proicede a hacer la rotación del led
rot:BTFSS side, 0   // revisa en que sentido esta haciendo la rotación
    goto rotrl //si side es 0 entonces lo hace de derecha a izquierda
    goto rotlr //si side es 1 entonces lo hace de izquierda a derecha
rotlr:
    RRNCF Led_status, 1, 0 //Rota el registro led status a la derecha
    movff Led_status, LATA // mueve el valor del registro led status a LATA
    goto config1s // una vez terminada la rotación reinicia el timer 
rotrl:
    RLNCF Led_status, 1, 0 //Rota el registro led status a la derecha
    movff Led_status, LATA // mueve el valor del registro led status a LATA
    goto config1s// una vez terminada la rotación reinicia el timer 

//delay 
delay20ms:		    //Rutina para el delay de 20 ms
    bcf B_TMR0, 0	    //Limpiamos bandera de desbordamiento
    MOVLW   0b10011100
    MOVWF   TMR0L, 0
    MOVLW   0b11111111 
    MOVWF   TMR0H,0
loop20ms: BTfSS B_TMR0, 0   //Si se activo bandera de desbordamiento de 20ms 
    goto loop20ms	    //Iterar hasta cunplir los 20ms
    bcf B_TMR0		    //limpia la bandera de desbordamiento
    return	    // regresa
    
interrupcion1:
    call delay20ms	    //subrutina antirebote
releaseboton:
    btfss PORTB, 0,0	    // revisa si se ha dejado de presionar el boton
    goto releaseboton	    // itera si no 
    incf pulsecont, 1, 0    //	Si ya se ha dejado de presionar entonces aumenta
    // en uno el valor de cuenta de pulsos
    movlw 3		    // Se pone un 3 en WREG
    subwf pulsecont, 0 ,0   //Se restael valor de pulsecont de WREG
    btfsc STATUS, 4, 0  //revisamos si al restar 3 de la cuenta de boton queda 
    // un valor negativo
    goto continue // de haber oprimido el valor menos de 3 veces continuar
    goto chgside // de haber oprimido el boton 3 veces, entonces cambia sentido
continue:
    bcf B_INT0	//SE limpian todas las banderas 
    BCF B_TMR0
    goto set1s
chgside:
    btg side, 0	//cambia el bit del sentido
    clrf pulsecont  //limpia el registro de los pulsos para contar desde cero
    bcf B_INT0
    BCF B_TMR0
    goto set1s	
set1s:	// esta subrutina reconfigura el timer para hacer retrasos de 1 s
    MOVLW   0b10000000
    MOVWF   TMR0L, 0
    MOVLW   0b11100001
    MOVWF   TMR0H,0								
    retfie
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


