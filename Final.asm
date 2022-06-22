 // Final.asm
 // Demostración #10 - Comunicacion EUSART
 // Luis Kevin Cepeda Zapata A00824840
 // Rodrigo Hugues Gudiño    A01620071
    RADIX DEC	
    PROCESSOR 18F45K50
    #include "pic18f45k50.inc"
    #define RXread 0x01

// Memory Allocation
    PSECT resetVec, class=CODE, reloc=2, abs
    ORG 0	    //indica que es el inicio del codigo 

    ORG 8 
resetVec:
    ORG 32	    //La instrucción Start se guarda en 32
    goto setup
setup:
//puertos
    MOVLB 15	    

    CLRF LATD, 0    // Limpiamos la salida de puerto A
    clrf TRISD, 0   // Cnfiguramos puerto A como salida 
   
;//Timer
;    MOVLW   0b00000100
;    MOVWF   T0CON, 0
;    //Se quiere que el timer haga 62500 cuentas es decir se precarga con el
;    // valor 3036 = 0b 0000 1011 1101 1100
;    MOVLW   0b10000000
;    MOVWF   TMR0L, 0
;    MOVLW   0b11100001
;    MOVWF   TMR0H,0
;    // Se inicializa el Timer 0
//RX    
    bsf TRISC, 6 //Configuramos puerto C como entrada RX 
    bsf TRISC, 7 //Configuramos TX como salida
    bcf ANSELC, 7  //Configuramos el puerto B como entrada digital	   (2)**
    bcf ANSELC, 6  //Configuramos el puerto B como entrada digital	   (2)**

//Configuración BAUD RATE
    // ABDOVF: AUTO detect baud rate (1)
    // RCIDL: Receive flag is idle (1)
    // RXDTP: Data/Receive Polarity Select bit (active-low) (1)		   (6)**
    // TXCKP: Clock/Transmit Polarity Select bit
    // BRG16: 16-bit Baud Rate Generator bit (1) 8 bit (0)		   (1)**
    // NULL
    // WUE: Wake-up Enable bit
    // ABDEN: Auto-Baud Detect Enable bit (1) finished (0)
    //NOS interesa 0X1X 0XX0
    movlw 0b11000000
BAUDCON_SET:
    bsf BAUDCON1, 6
    bcf BAUDCON1, 3
;    movwf BAUDCON1 // 8 bit baud rate generator
    //FOSC = 1MHz ; BD = 9600 ; SPBRG = ((1 MHz)/(64 × 110))-1 = 12}
SPBRG1_BAUDRATE_SET:

    movlw 25	//Carga el valor 12 al registro high y low de SPBRG	   (1)**
    movwf SPBRG1    
    //clrf SPBRGH1    
    

    clrf RCREG1 //Limpiamos el registro de lectura RX
    //CONFIGURACIÓN modo RX
	//**SPEN: enable serial port (1)				   (3)**
	//**RX9 : 9-bit reception (1)
	//SREN: Single receibe enable bit (1) Para comunicación asincronica no importa
	//**CREN: Recepción contiuna  (1)				   (7)**
	//ADDEN: address detect enable bit (1) Para comunicacion asincrona de 8-bit no importa
	//FERR: Framing error bit (1) no (0)
	//OERR: Overrun Error bit (1) no (0)
	//RX9D: bit 9 ( no importa)
	// La configuración que nos interesa es  10X1 XEEX
    movlw 0b10010000
    movwf RCSTA1
    //CONFIGURACION TX
	//CSRC: Clock source ; Para asincronico no importa
	//**TX9: Transmision de 9 bits (1)
	//**TXEN: Transmit enable bit (1)
	//**SYNC: EUSART Mode select bit (1 sincronico) 
	//SENDB: Send Sync Break on next transmision (1)
	//**BRGH: HIgh speed  Baud rate selection (1 High) (0 Low)	   (1)**
	//TRMT (Transmit Shift register Stats bit (TSR empty 1) (TSR FULL 0)
	//TX9D: ninth bit
	//La configuracion que nos interesa es X000 ?0?X
    clrf TXSTA1
    
    
    //movlw 0b00010000
    //movwf PIE1
    //OSCCON 
	// IDLEN:
	// **IRCF : 011 1Mhz
	// OSTC: : Oscillator Start-up FOSC (1) HFINTOSC (0) 
	// **HFIOFS: Stale (1) unstable (0) frequcney
	// **SCS: System Clock Select bit (10) internal
	//La configuracion que nos interesa es X011 0110
    MOVLW   0x72//0b00110010
    MOVWF   OSCCON
    
    //Interrupciones globales y T0CON
    BSF	    INTCON, 7	    
    //BSF	    INTCON, 5
    //BCF	    INTCON, 2
    
    //BSF	T0CON, 7, 0 
WAITSERIAL: 
    BTFSS PIR1, 5; /RCIF: EUSART Receibe interrupt Flag bit (full 1)	   (8)**
    goto WAITSERIAL
    movf RCREG1, 1				 //(9)**
LED:
    movwf Rread
    movf RXread //Pasamos la lectura a WREG
    sublw '0' 
    btfsc STATUS, 2, A	//Si la resta del valor de la lectura 
    goto CERO
    
    movf RXread
    sublw '1'
    btfsc STATUS, 2, A
    goto UNO
    
    movf RXread
    sublw '2'
    btfsc STATUS, 2, A
    goto DOS

    movf RXread
    sublw '3'
    btfsc STATUS, 2, A
    goto TRES
    
    movf RXread
    sublw '4'
    btfsc STATUS, 2, A
    goto CUATRO
    
    movf RXread
    sublw '5'
    btfsc STATUS, 2, A
    goto CINCO
    goto NIUNO

CERO: 
    movlw 0b00000001
    movwf LATD
    goto WAITSERIAL
UNO:
    movlw 0b00000010
    movwf LATD
    goto WAITSERIAL
DOS:
    movlw 0b00000100
    movwf LATD
    goto WAITSERIAL
TRES:
    movlw 0b00001000
    movwf LATD
    goto WAITSERIAL
CUATRO:
    movlw 0b00010000
    movwf LATD
    goto WAITSERIAL
CINCO: 
    movlw 0b00100000
    movwf LATD
    goto WAITSERIAL
NIUNO:
    movlw 0b00000011
    movwf LATD
    goto WAITSERIAL    
    
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



    