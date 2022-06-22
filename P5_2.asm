/// P5_2.asm
 // Programa para familiarizarse con MPLAB
 // Luis Kevin Cepeda Zapata A00824840
 // Rodrigo Hugues Gudiño    A01620071
    RADIX DEC	
    PROCESSOR 18F45K50
    #include "pic18f45k50.inc"
    #define count 0x01	//este registro guarda la ultima ubicación del LED
    #define step 0x02	//Si el bit 0 esta activo, la suma se hace dos veces
			// solo se usa en rutina B y C
			//Si el bit 1 esta activo, se mueve al primer impar 
			// solo se usa en rutina B
			//este registro se utiliza para saber en que sentido va 
    #define vara 0x10 //timer
    #define varb 0x11 //timer
// Memory Allocation  
    PSECT resetVec, class=CODE, reloc=2, abs
    ORG 0 //indica que es el inicio del codigo 
// Reset Vector
resetVec:
    ORG 32  //La instrucción Start se guarda en 32
    GOTO Start // Ir a etiqueta Start
    
// Start: 
Start:
    MOVLB 15	    //Carga el valor 15 al registro BSR
    clrf LATB, 0    // Limpiamos la salida de puerto B
    clrf TRISB, 0   // Cnfiguramos puerto B como salida
    clrf LATC, 0    // Escritura puerto C todo apagado
    setf TRISC, 0   // 
    clrf ANSELC, 0  //Configuramos el puerto c como salida digital
    bcf ANSELC,2    //Configuramos el puerto c como salida digital
    bcf ANSELC,6    //Configuramos el puerto c como salida digital
    bcf ANSELC,7    //Nos aseguramos que el puerto C este bien configurado
    clrf count
    
main_once:// SUBRUTINA MAIN_ONCE, itera infinitamente hasta que entra a una 
    //subrutina contadora. Esperar a que el usuario presione un boton
    btfss PORTC, 0,0 //boton 0?
    goto cont_a_i	//subrutina Grey
    btfss PORTC, 1,0//boton 1?
    goto cont_b_i	//subrutina Impares
    btfss PORTC, 2,0//boton 2?
    goto cont_c_i	//Subrutina pares
    goto main_once	//Iterar
    D
cont_a_i: //INICIO SUBRUTINA A GREY
    call delay_20ms	// Antirebote
    btfss PORTC, 0, 0	// Antirebote
    goto cont_a_i	// Antirebote
    clrf count		// Antirebote
    // Limpiamos el registro step pues solo nos interesa que sume o reste
    // de uno en uno.
    clrf step
    
cont_a:
    //Revisar si se quiere cambiar de subrutina
    btfss PORTC, 1,0//boton 1?
    call cont_b_i	//Cambiar a impares
    btfss PORTC, 2,0//boton 2?	
    call cont_c_i	//Cambiar a pares
    call in_67		//Revisar si se quiere sumar o restar un valor
//Esta parte es interesante...
//Habia un error que era generado porque cuando count tenia el bit 0 
// encendido, este rotaba hasta el bit 7 por lo que este bit parpadeaba. 
// para resolverlo, se crearon dos subrutinas R1 y R2. Basicamente revisamos
// si el registro count tiene el primer bit encendido y de ser asi, entonces 
// procedemos a R1, donde apagamos este bit para la rotacion a la derecha
// y lo volvemos a encender para hacer la operacion XOR. 
// EN el caso de R2, entonces no afecta pues el bit 0 esta apagado y al rotar
// se mantiene apagado.
// R1 y R2 realizan la siguiente operacion (COUNT) XOR (COUNT >> 1). 
    btfsc count,0,0 
    goto R1 
    goto R2
    
R1: //si el bit cero de count esta encendido, lo apagamos antes del rotate
    //para que no aparezca al final de WREG. 
    bcf count, 0,0
    RRNCF count,0,0	// WREG = (count >> 1)
    bsf count, 0,0
    xorwf count,0,0	//convertir count a grey y ponerlo en WREG
    movwf LATB, 0	//escribir en LATB WREG
    goto cont_a	    //Iterar
R2: //Si el bit cero de count esta apagado procede como siempre.
    RRNCF count,0,0	// WREG = (count >> 1)
    xorwf count,0,0	//convertir count a grey y ponerlo en WREG
    movwf LATB, 0	//escribir en LATB WREG
    goto cont_a	    //Iterar
    
cont_b_i: // INICIO SUBRUTINA B IMPARES
    call delay_20ms	// Antirebote
    btfss PORTC, 1, 0	// Antirebote
    goto cont_b_i	// Antirebote impares
    clrf count		// Limpia el registro contador
    // El bit 0 de step sirve para que al hacer suma, se haga dos veces
    bsf step, 0, 0	
    // EN este caso, como es la rutina B, se quiere que al presionar una vez el 
    // boton de suma o resta, pase al primero numero impar (1) o si se presiona 
    // resta pasa al ultimo numero impar (255)
    bsf step, 1, 0
    
cont_b:	//  SUBRUTINA B IMPARES
    //Revisar si se quiere cambiar de subrutina
    btfss PORTC, 0,0//boton 0?
    call cont_a_i	//Cambiar a Grey
    btfss PORTC, 2,0//boton 2?
    call cont_c_i	//Cambiar a pares
    call in_67		//Revisar si se quiere sumar o restar un valor
    movf count, 0,0	//mover el valor de count a WREG
    movwf LATB, 0	//escribir en LATB WREG
    goto cont_b	    //Iterar
    
cont_c_i: //INICIO SUBRUTINA C PARES
    call delay_20ms	// Antirebote
    btfss PORTC, 2, 0	// Antirebote
    goto cont_c_i	// Antirebote
    clrf count		// Antirebote
    // El bit 0 de step sirve para que al hacer suma o resta se haga dos veces
    bsf step, 0, 0
    // En este caso no nos interesa que comience en (1) o (255).
    bcf step, 1, 0

cont_c:	//SUBRUTINA C PARES
    //Revisar si se quiere cambiar de subrutina
    btfss PORTC, 0,0//boton 0?
    call cont_a_i	//Cambiar a Grey
    btfss PORTC, 1,0//boton 1?	
    call cont_b_i	//Cambiar a IMPARES
    call in_67		//Revisar si se quiere sumar o restar un valor
    movf count, 0,0	//mover el valor de count a WREG
    movwf LATB, 0	//escribir en LATB WREG
    goto cont_c	    //Iterar

in_67: //REVISAR ENTRADA PUERTO C pin 6 y 7
    btfss PORTC, 6,0 //boton 3?
    call suma_i		// Ir a subrutina de suma
    btfss PORTC, 7,0 //boton 4?
    call resta_i	// Ir a subrutina de resta
    return        
    
suma_i: //INICIO SUBRUTINA SUMA
    call delay_20ms	//Antirebote
    btfss PORTC, 6, 0	//Antirebote
    goto suma_i		//Antirebote
suma:	//SUBRUTINA SUMA
    btfsc step,1,0  //Paso especial para hacer rutina b, primer click solo suma 
		    //uno
    goto suma_b	    //Ir a subrutina sumar una vez en b
    btfsc step,0,0  //revisar si esta en rutina C y b
    incf count,1,0  //Si esta en rutina C o B, entonces suma dos veces.
    incf count,1,0  //Suma de uno en uno, se usa en todas las rutinas.   
    return
suma_b:	//SUBRUTINA PRIMERA SUMA CONTADOR B
    incf count, 1,0 //suma uno a count
    bcf step, 1, 0  //apaga el bit primer impar
    return
resta_i:
    call delay_20ms	//Antirebote
    btfss PORTC, 7, 0	//Antirebote
    goto resta_i	//Antirebote
resta:
    btfsc step,1,0 //Paso especial para hacer rutina b, primer click solo resta 
		    //uno
    goto resta_b    //Ir a subrutina restar una vez en b
    btfsc step,0,0  //revisar si esta en rutina C y b
    decf count,1,0  //Si esta en rutina C o B, entonces resta dos veces.
    decf count,1,0  //Si esta en rutina A, salta el anterior y solo resta una 
    return
resta_b://SUBRUTINA PRIMERA RESTA CONTADOR B
    decf count, 1,0 //resta uno a count
    bcf step, 1, 0  //apaga el bit primer impar
    return

//RETRASO DE 20ms aprox (Antirebote)
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