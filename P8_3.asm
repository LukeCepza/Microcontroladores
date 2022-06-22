/// P8_3.asm
// Demostraci�n #8 - Ejercicio 3
// Luis Kevin Cepeda Zapata A00824840
// Rodrigo Hugues Gudi�o    A01620071
    RADIX DEC	
    PROCESSOR 18F45K50
    #include "pic18f45k50.inc"
    #define cont 0x01 // se utiliza para realizar la cuenta de pulso y calcular
    //la frecuencia.

    // Memory Allocation
    PSECT resetVec, class=CODE, reloc=2, abs
    ORG 0		//indica que es el inicio del codigo 
// Reset Vector

resetVec:
    ORG 32	    //La instrucci�n Start se guarda en 32
    
Main:
	MOVLB 15	    //Carga el valor 15 al registro BSR
	// LEDS
	clrf LATA, 0    // Limpiamos la salida de puerto A
	clrf TRISA, 0   // Cnfiguramos puerto A como salida
	// DEBUG para ver si es 1s
	clrf LATE, 0    // Limpiamos la salida de puerto A
	clrf TRISE, 0   // Cnfiguramos puerto A como salida
	// LECTURA: Solo se usa el bit 0 como lectura de frecuencia.
	setf TRISB, 0   //Configuramos el puerto B como entrada
	clrf ANSELB, 0  //Configuramos el puerto B como entrada digital
  
config1s:
	// Se configura el Timer 0 como 16 bits  con preescalador de 1:4
	MOVLW   0b00000001
	MOVWF   T0CON, 0
	//Se quiere que el timer haga 62500 cuentas es decir se precarga con el
	// valor 3036 = 0b 0000 1011 1101 1100
	MOVLW   0b11011100
	MOVWF   TMR0L, 0
	MOVLW   0b00001011
	MOVWF   TMR0H,0
	// Se inicializa el Timer 0
	BSF	T0CON, 7, 0 
	//Se revisa si se ha activado la bandera de desbordamiento del Timer 0
	// es decir si ya paso un segundo.

Delay1s:BTFSS INTCON, 2, 0
	//De NO haber pasado el tiempo, procede a esperar una lectura
	goto  ReadB
	//DE haber pasado el segundo se despliega el valor contado de pulsos
	goto  DispLED
	
	//Verifica si hay lectura en el puerto B bit 0 
ReadB:	BTFSS PORTB , 0, 0
	// En caso de NO haber lectura vuelve a regresa a revisar si ya paso 1s
	goto  Delay1s

	// En caso de SI tener lectura, procede a contarlo
pulso:	BTFSC PORTB, 0 ,0 //revisa si el pulso cambio de estado
	goto  pulso //Si el pulso no ha cambiado de estado se deja en ciclo
	// Si ya se acabao el pulso lo cuenta en el registro cont
	incf  cont, 1,0
	//Regresa a la subrutina Delay1s para ver si ya paso 1s.
	goto  Delay1s
	
	//De haber terminado el segundo, procede a mover el valor de cont a los
	//LEDS
DispLED:movff cont ,LATA
	//Esto se uso para debugear, para ver si la cuenta de 1s es 1s
	btg LATE, 0
	//Se limpia el registro cont para volver a empezar la cuenta de pulsos
	// desde cero
	CLRF  cont ,0
	//Se precarga el valor 3036 para hacer un retraso de 1s.
	MOVLW   0b11011100
	MOVWF   TMR0L, 0
	MOVLW   0b00001011
	MOVWF   TMR0H,0
	//SE baja la bandera de desbordamiento del Timer0
	bcf INTCON, 2, 0
	//Vuelve a ejecutar la rutina indefinidamente.
	goto  Delay1s
    
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