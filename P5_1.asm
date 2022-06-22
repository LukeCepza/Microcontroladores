/// P5_1.asm
 // Demostración #5 - Ejercicio 1
 // Luis Kevin Cepeda Zapata A00824840
 // Rodrigo Hugues Gudiño    A01620071
    RADIX DEC	
    PROCESSOR 18F45K50
    #include "pic18f45k50.inc"
    #define Led_status 0x01 //este registro guarda la ultima ubicación del LED
    #define bf 0x02 //este registro se utiliza para saber en que sentido va 
		    //cuando se usa la rutina c. BF_0 estamos en subrutina 3, 
		    //adelante atras, BF_1
		    // estamos haciendo izquierda a derecha.
    #define vara 0x10 //timer
    #define varb 0x11 //timer
// Memory Allocation
    
    PSECT resetVec, class=CODE, reloc=2, abs
    ORG 0	    //indica que es el inicio del codigo 
// Reset Vector
resetVec:
    ORG 32	    //La instrucción Start se guarda en 32
    GOTO Start	    // Ir a etiqueta Start

// Start: 
Start:
    MOVLB 15	    //Carga el valor 15 al registro BSR
    clrf LATB, 0    // Limpiamos la salida de puerto B
    clrf TRISB, 0   // Cnfiguramos puerto B como salida
    clrf LATC, 0    // Escritura puerto C todo apagado
    setf TRISC, 0   // 
    clrf ANSELC, 0  //Configuramos el puerto c como entrada digital
    bcf ANSELC,2    //Configuramos el puerto c como entrada digital
    bcf ANSELC,6    //Configuramos el puerto c como entrada digital
    bcf ANSELC,7    //Nos aseguramos que el puerto C este bien configurado
    movlw 1	    //Iniciamos el LED en la posición 1.
    movwf Led_status, 0 //Precarga el valor cero en el registro Led Status
    goto blink	    //Salta a la rutina de parpadeo

blink_i:// INICIO SUBRUTINA PARPADEO
    //Si al final termina con _i significa que es la rutina inicial
    // que incluye el anti rebote.
    // En este caso, se podria decir que es el menu principal pues todas
    // las rutinas regresan a esta parte.
    clrf bf	    //se limpia el registro bf (sub-rutina C) 
 
    call delay_20ms //Secuencia anti rebote para regresar al blink
    // incluye un BTFSS PORTC para´revisar si la tecla ya se debjo de presionar.
    
    //Todo esto es antirebote cuando sales de alguna de las 3 subrutinas o pausa
    btfss PORTC, 0,0 //boton 0?
    goto blink_i 
    btfss PORTC, 1,0 //boton 1?
    goto blink_i    
    btfss PORTC, 2,0 //boton 2?
    goto blink_i
    btfss PORTC, 6,0 //boton 3?
    goto blink_i
    // Cuando se deje de presionar la tecla, termina la subrutina blink_i y 
    // continua a la rutina blink.
blink: //SUBRUTINA DE PARPADEO
    movf Led_status, 0, 0 //movemos la ultima posición del LED a WREG
    movwf LATB, 0   //Movemos WREG a el puerto B como escritura (LATB) 
    // basicamente encender blink
    call delay_800ms//delay
    btfss PORTC, 6,0//revisamos si se presiono la pausa
    call pause_i    //Si se presiono ir a pausa
    clrf LATB, 0    //apagamos el blink
    call delay_800ms//delay
		    //Checar si se presionon algun boton
    
		    // EStas lineas revisan si se presiono alguna tecla de 
		    //puerto C y de ser asi, se va a la subrutina especificada
    btfss PORTC, 0,0// revisa si el boton 0 esta presionado	
    goto rot_lr_i   // ir a la subrutina iquerda a derecha
    btfss PORTC, 1,0// revisa si el boton 1 esta presionado
    goto rot_rl_i   // ir a subrutina derecha a izquierda
    btfss PORTC, 2,0// revisa si el boton 2 esta presionado
    goto rot_bf_i   // ir a la subrutina adelante atas (girar sin dar vuelta)
    btfss PORTC, 6,0// revisa si el boton 3 esta presionado
    call pause_i    // ir a la subrutina de pausa
    goto blink	    // si no se presiono ningun boton, repetir el blink
    
//SUBRUTINA A 
rot_lr_i:	    // Todos las subrutinas comienzan con un ###_i que significa 
		    // inciador y es donde
		    // esta iplementada la rutina antirebote. En estee caso es 
		    // para la subrutina de izquierda
		    // a derecha.
    call delay_20ms //Antirebote
    btfss PORTC, 0, 0	//Antirebote
    goto rot_lr_i   //Antirebote
    // Si se deja de presionar el boton 0, entonces continua a la parte principal
rot_lr: //Subrutina A principal, se cicla aqui
    btfss PORTC, 6,0//Revisa si se presiona el boton 3 para ir a la subrutina de
		    // pausa
    call pause_i    // ir a subrutina de pausa
    RRNCF Led_status, 1, 0 //Rota el registro led status a la derecha
    movf Led_status,0,0 // mueve el valor del registro led status a WREG
    clrf LATB, 0    //limpia el puerto B
    movwf LATB, 0   // enciende el puerto B de acuerdo a el registro led status
    call delay_800ms
    
    //Si estamos en subrutina C. 
    btfsc bf, 0,0   
    goto rot_bf
    
    btfss PORTC, 0, 0 //boton 0?
    goto blink_i    //parpadeo
    goto rot_lr	    //intera movimiento
//SUBRUTINA B
rot_rl_i: //subrutia antirebote para ir a la subrutina de derecha a izquierda
    call delay_20ms	//Antirebote
    btfss PORTC, 1, 0	//Antirebote
    goto rot_rl_i	//Antirebote
    
rot_rl:
    btfss PORTC, 6,0 //boton3? 
    call pause_i    //Ir a pausa
    RLNCF Led_status, 1, 0  //Rotas a la derecha el led status y guardarlo 
    movf Led_status,0,0	// mover el led status a WREG
    clrf LATB, 0
    movwf LATB, 0   //mover WREG (LED_status) a LATB
    call delay_800ms	
    
    //Si esta en subrutina cregresa a subrutina C.
    btfsc bf, 0,0
    goto rot_bf
    
    
    btfss PORTC, 1, 0 //boton 1?
    goto blink_i    //Ir a parpadeo
    goto rot_rl	    //Iterar movimiento
//SUBRUTINA C
rot_bf_i: //subrutia antirebote para ir a la subrutina C
    call delay_20ms
    btfss PORTC, 2, 0 //Si se deja de presonar el boton 2, entonces continua
    goto rot_bf_i
    
    movlw 1 //Primer bit significa que estamos en subrutina C
    // reutilizamos codigo de las subrutinas A y B y tuvimos que agreagr este
    // bit para diferenciar entre la subrutina A o B y la subrutina C.
    movwf bf, 0
    
rot_bf: //Subrutina C principal
    btfss PORTC, 2, 0	//Revisa bit 2 puerto C, si se presiona regresa a blink
    goto blink_i	//Regresa a blink
    btfsc Led_status, 7, 0 //Revisa si el Led esta encendido en ultima posición
	call chg_bf_lr	    //llama a subrutina que cambia el sentido de derecha
			    // izquieda a izquierda derecha
    btfsc Led_status, 0, 0//Revisa si el Led esta encendido en primera posicion
	call chg_bf	    //Llama a subrutina que cambia el sentido de izquieda
			    // derecha a derecha izquierda
    btfsc bf, 1, 0	    //Si el bit bf esta encendido entonces el movimiento 
			    // del led es de derecha a izquieda
	goto rot_rl	    //va a subrutina A 
    btfss bf, 1, 0	    //Si el bit bf esta apagado entonces el movimiento 
			    // del led es de iqzuieda a derecha
	goto rot_lr	    //va a subrutina B

    goto rot_bf		    //En teoria el codigo no llega aqui nunca pero por
			    //si acaso regresa a la subrutina C principal.
    
chg_bf_lr:		    //ACtiba el valor de bf para que se haga movimento 
    // Izquierda a derecha
    bsf bf, 1		     
chg_bf:			    //desactiva el valor de bf para que se haga movmiento
    // de derecha a izquierda
    btg bf, 1	//es equivalente a bcf porque antes siempre se le aplica un bsf
    return
    
pause_i: //subrutia antirebote para ir a la subrutina de pausa
    call delay_20ms	//Antirebote
    btfss PORTC, 6, 0	//Antirebote
    goto pause_i	//Antirebote
pause: // ciclo infinito hasta que se detecte el puert 6 otra vez.
    btfss PORTC, 6,0
    goto pause_return
    goto pause		//ITera pausa
pause_return: //subrutia antirebote para salir de la subrutina pausa. Como se uso call
    // en vez de goto, se tuvo que hacer este segmento.
    call delay_20ms	//Antirebote
    btfss PORTC, 6, 0	//antirebote
    goto pause_return	//antirebote
    return
    
//delay 
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
    movlw 20
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