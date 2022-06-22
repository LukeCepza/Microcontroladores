/// P7_1.asm
 // Demostración #7 - Ejercicio 1
 // Luis Kevin Cepeda Zapata A00824840
 // Rodrigo Hugues Gudiño    A01620071
    RADIX DEC	
    PROCESSOR 18F45K50
    #include "pic18f45k50.inc"
    
    ; Registro asociado al LCD
    #define RS  LATE, 0, A  //RS 
    #define E   LATE, 2, A  //Estatus 
    #define LRW  LATE, 1, A //Comando E 
    #define dataLCD LATD, A //Puerto del LCD 
    #define Delayconst0 0x10, A; constante delay1m
    #define vara 0x11 //timer
    #define varb 0x12 //timer
 // Memory Allocation
    
    PSECT resetVec, class=CODE, reloc=2, abs
    ORG 0	    //indica que es el inicio del codigo 
// Reset Vector
    
resetVec:
    ORG 32		//La instrucción Start se guarda en 32
    GOTO Start		// Ir a etiqueta Start
Start:
ConfLCD: 
	movlb	15	//Selectlastbank(SFRs)
	clrf ANSELE, 1	//Forces digital I/O
	clrf TRISE, A  
	clrf ANSELD, 1
	clrf TRISD,A
Main:	
	MOVLW 0b00111000 // escritura en dos líneas: DL = 8bit; N = 2 lines; F= 5x7
	call SetProps
	MOVLW 0b00001100 // Encender Display, sin cursor activo: D = 1; C = 0;B =0
	call SetProps
	MOVLW 0b00000110 // Configurar desplazamiento incremental: I/D = 1
	call SetProps
	MOVLW 0b00000001 // Clearing display
	call SetProps
	call delay_800ms
	
Write: 
	movlw 0b10000010	 // Posicion DDRAM primer renglon inicia en 3 fila
	call SetProps 
	// EN la pantalla se debe de escribir !--Saludos para--!
	//                                    !----la banda----!
	movlw 'S'
	call WriteLCD 
	movlw 'a'
	call WriteLCD 
	movlw 'l'
	call WriteLCD 
	movlw 'u'
	call WriteLCD 
	movlw 'd'
	call WriteLCD 
	movlw 'o'
	call WriteLCD 
	movlw 's'
	call WriteLCD 
	movlw ' '
	call WriteLCD 
	movlw 'p'
	call WriteLCD 
	movlw 'a'
	call WriteLCD 
	movlw 'r'
	call WriteLCD 
	movlw 'a'
	call WriteLCD 

	movlw 0b11000100  ;Posicion DDRAM segundo renglon inicia en 0x44h
	call SetProps 

	movlw 'l'
	call WriteLCD 
	movlw 'a'
	call WriteLCD 
	movlw ' '
	call WriteLCD 
	movlw 'b'
	call WriteLCD 
	movlw 'a'
	call WriteLCD 
	movlw 'n'
	call WriteLCD 
	movlw 'd'
	call WriteLCD 
	movlw 'a'
	call WriteLCD 
	call Delay1m  ;para darle visibilidad al mensaje antes de borrar 
	call delay_800ms //Llama un retraso para que se pueda visualizar el mensaje 
	//la pantalla
	goto Start // Renicia el programa

///////////////////////Instruccion y dato////////////////////////
SetProps: // S usa para configurar propiedades
	bcf RS ;RS=0
	bcf RW ;RW=0
	goto Enable
WriteLCD:   //SE usa para escribir en el LCD
	bsf RS ;RS=1
	bcf RW ;RW=0
Enable:	bsf E // Activa el Enable para que la LCD ejecute la instruccion
	MOVWF dataLCD 
	nop	//Delay 
	bcf E // Termina de recibir información
	call Delay1m //Otro delay
	return

	
delay_800ms:
    movlw 250
    movwf vara, 0
    movwf varb, 0
loop:
    decfsz varb,1,0
    goto loop
    decfsz vara,1,0
    goto loop
    return
    
Delay1m: 
    movlw 250 ;Tiempo de 1ms para permitir carga
    movwf Delayconst0
ciclo:
    nop        ;1 ciclo*C 
    decfsz Delayconst0,1  ;1 ciclo*(C-1)+2
    goto ciclo    ;2 ciclos*(C-1)  
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