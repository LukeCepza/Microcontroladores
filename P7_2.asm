 RADIX DEC  //Seleccionar decimal como base numerica
 PROCESSOR 18F45K50 //Seleccional procesador a utilizar 
 #include "pic18f45k50.inc"  //Incluir librerias del PIC18F45K50
// Memory Allocation 
    PSECT resetVec, class=CODE, RELOC=2, abs ;
    ORG	0  
/////////////////// Establecer variables//////////////////////
VARA equ 0x4
VARB equ 0x5
Num1 equ 0x6
Num2 equ 0x7
Resultado equ 0x8
aux  equ 0x1
aux2 equ 0x2
CA2 equ 0x3
C0 equ 0x11
C1 equ 0x12
C2 equ 0x13
Decc equ 0x9
Uni equ 0x10
help equ 0x20
help2 equ 0x21
//////////////////////////////////////////////////////////////
resetVec: 
    ORG 32 // Guarar programa desde el espacio de memoria 0020
 
    GOTO start  //Saltar  seccion de start 
start:

///////////////////Config. para teclado//////////////////////
    	movlb 15
        clrf ANSELB,1   ;digital
	bcf INTCON2,7,0   ;PORTB pull-ups habilitados     
        movlw 0b00001111
	movwf TRISB,A ;entradas-Renglones. Salidas-columnas
	movwf WPUB,A ;pull-ups en inputs  
	setf LATB,A  ;orden logico
	
//////////////////Config. para LEDs////////////////////////
	clrf TRISD,1  ;Establecemos salida LED
        clrf ANSELD,1 ;digital
        clrf LATD,1   ;apagamos puerto d para evitar ruido
	
////////////////////////Teclado//////////////////////////////
Teclado:
	movlw 0b11101111 ;checando renglones de columna 1 
	movwf LATB,0
	btfss PORTB,0,0    ;checa si se pulso 1
	goto uno 
	btfss PORTB,1,0     ;checa si se pulso 4 
	goto cuatro 
	btfss PORTB,2,0     ;checa si se pulso 7
	goto siete
        ;columna 2	
        movlw 0b11011111 
	movwf LATB,0
	btfss PORTB,0,0    ;checa si se pulso 2
	goto dos 
	btfss PORTB,1,0     ;checa si se pulso 5
	goto cinco 
	btfss PORTB,2,0     ;checa si se pulso 6
	goto ocho
	btfss PORTB,3,0     ;checa si se pulso 0
	goto cero
	;columna 3 
	movlw 0b10111111 
	movwf LATB,0
	btfss PORTB,0,0    ;checa si se pulso 3
	goto tres 
	btfss PORTB,1,0     ;checa si se pulso 6
	goto seis 
	btfss PORTB,2,0     ;checa si se pulso 9
	goto nueve
	goto Teclado

Operandos: 
        movlw 0b01111111  
	movwf LATB,0
	btfss PORTB,0,0
	goto suma 
	btfss PORTB,1,0
	goto resta 
	btfss PORTB,2,0
	goto multiplicacion 
	btfss PORTB,3,0
	goto division
	goto Operandos
Listo:
	bz aux2       ;Checa si ya se seleccionó operación
	return
	goto Operandos
	
Resultadoo:
        movlw 0b11101111
	movwf LATB,0 
	btfss PORTB,3,0  ;Se checa si se pulso igual 
	return
	goto Resultadoo

Borradofinal: 
       movlw 0b10111111  
       movwf LATB,0 
       btfss PORTB,3,0 ;Se checha si se pulso borrado
       goto Delete2 
       goto Borradofinal
///////////////////////Numeros////////////////////////
uno:
    call Delay      ;sistema anti rebotes
    btfss PORTB,0,0
    goto uno 
    
    btfss aux,0,0   ;checamos si es para Num2 
    goto Next1
    clrf WREG
    addlw 1
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 1 
    movff LATD,Num2  ;Guardamos segundo valor 
    goto Operacion   ;subutina para calculo
    
Next1:
    clrf WREG
    addlw 1
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 1 
    
    movff LATD,Num1  ;guardamos primer valor 
    call Operandos
    clrf WREG
    addlw 1
    movwf aux,0 ;Activamos registro para salto a Num2
   
    goto Teclado
	  
    
cuatro:
    call Delay      ;sistema anti rebotes
    btfss PORTB,1,0
    goto cuatro 
    
    btfss aux,0,0   ;checamos si es para Num2 
    goto Next4
    clrf WREG
    addlw 4
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 4 
    movff LATD,Num2  ;Guardamos segundo valor 
    
    goto Operacion   ;subutina para calculo
    
Next4:
    clrf WREG
    addlw 4
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 4 
    
    movff LATD,Num1  ;guardamos primer valor 
    call Operandos 
    clrf WREG
    addlw 1
    movwf aux,0 ;Activamos registro para salto a Num2
    
    goto Teclado
    
siete:
    call Delay      ;sistema anti rebotes
    btfss PORTB,2,0
    goto siete 
    
    btfss aux,0,0   ;checamos si es para Num2 
    goto Next7
    clrf WREG
    addlw 7
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 1 
    movff LATD,Num2  ;Guardamos segundo valor 
    
    goto Operacion   ;subutina para calculo
    
Next7:
    clrf WREG
    addlw 7
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 1 
    
    movff LATD,Num1  ;guardamos primer valor 
    call Operandos 
    clrf WREG
    addlw 1
    movwf aux,0 ;Activamos registro para salto a Num2
    
    goto Teclado
    
dos:
    call Delay      ;sistema anti rebotes
    btfss PORTB,0,0
    goto dos 
    
    btfss aux,0,0   ;checamos si es para Num2 
    goto Next2
    clrf WREG
    addlw 2
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 2 
    movff LATD,Num2  ;Guardamos segundo valor 
    goto Operacion   ;subutina para calculo
    
Next2:
    clrf WREG
    addlw 2
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 1 
    
    movff LATD,Num1  ;guardamos primer valor 
    call Operandos 
    clrf WREG
    addlw 1
    movwf aux,0 ;Activamos registro para salto a Num2
    goto Teclado

cinco:
    call Delay      ;sistema anti rebotes
    btfss PORTB,1,0
    goto cinco
    
    btfss aux,0,0   ;checamos si es para Num2 
    goto Next5
    clrf WREG
    addlw 5
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 5
    movff LATD,Num2  ;Guardamos segundo valor 
    
    goto Operacion   ;subutina para calculo
    
Next5:
    clrf WREG
    addlw 5
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 1 
    
    movff LATD,Num1  ;guardamos primer valor 
    call Operandos 
    clrf WREG
    addlw 1
    movwf aux,0 ;Activamos registro para salto a Num2
    
    goto Teclado
    
ocho:
    call Delay      ;sistema anti rebotes
    btfss PORTB,2,0
    goto ocho 
    
    btfss aux,0,0   ;checamos si es para Num2 
    goto Next8
    clrf WREG
    addlw 8
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 8
    movff LATD,Num2  ;Guardamos segundo valor 
    
    goto Operacion   ;subutina para calculo
    
Next8:
    clrf WREG
    addlw 8
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 8 
    
    movff LATD,Num1  ;guardamos primer valor 
    call Operandos
    clrf WREG
    addlw 1
    movwf aux,0 ;Activamos registro para salto a Num2
    
    goto Teclado
    
    
cero:
    call Delay      ;sistema anti rebotes
    btfss PORTB,3,0
    goto cero
    
    btfss aux,0,0   ;checamos si es para Num2 
    goto Next0
    CLRF WREG
    addlw 0
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 0 
    movff LATD,Num2  ;Guardamos segundo valor 
    
    goto Operacion   ;subutina para calculo
    
Next0:
    clrf WREG
    addlw 0
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 1 
    
    movff LATD,Num1  ;guardamos primer valor 
    call Operandos 
    clrf WREG
    addlw 1
    movwf aux,0 ;Activamos registro para salto a Num2
    
    goto Teclado
    
    
tres:
    call Delay      ;sistema anti rebotes
    btfss PORTB,0,0
    goto tres
    
    btfss aux,0,0   ;checamos si es para Num2 
    goto Next3
    clrf WREG
    addlw 3
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 3 
    movff LATD,Num2  ;Guardamos segundo valor 
    
    goto Operacion   ;subutina para calculo
    
Next3:
    clrf WREG
    addlw 3
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 3 
    
    movff LATD,Num1  ;guardamos primer valor 
    call Operandos 
    clrf WREG
    addlw 1
    movwf aux,0  ;Activamos registro para salto a Num2
    
    goto Teclado
    
seis:
    call Delay      ;sistema anti rebotes
    btfss PORTB,1,0
    goto seis 
    
    btfss aux,0,0   ;checamos si es para Num2 
    goto Next6
    clrf WREG
    addlw 6
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 6
    movff LATD,Num2  ;Guardamos segundo valor 
    
    goto Operacion   ;subutina para calculo
    
Next6:
    clrf WREG
    addlw 6
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 6
    
    movff LATD,Num1  ;guardamos primer valor 
    call Operandos 
    clrf WREG
    addlw 1
    movwf aux,0 ;Activamos registro para salto a Num2
    
    goto Teclado
    

nueve:
    call Delay      ;sistema anti rebotes
    btfss PORTB,2,0
    goto nueve 
    
    btfss aux,0,0   ;checamos si es para Num2 
    goto Next9
    clrf WREG
    addlw 9
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 9
    movff LATD,Num2  ;Guardamos segundo valor 

    goto Operacion   ;subutina para calculo
    
Next9:
    clrf WREG
    addlw 9
    movwf LATD,0     ;Se demuestra en LEDs que se pulso 1 
    
    movff LATD,Num1  ;guardamos primer valor 
    call Operandos 
    clrf WREG
    addlw 1
    movwf aux,0  ;Activamos registro para salto a Num2
    
    goto Teclado
////////////////////Operandos////////////////////////
suma:
    call Delay      ;sistema anti rebotes
    btfss PORTB,0,0
    goto suma
    
    clrf WREG
    addlw 1
    movwf aux2    ;marcamos bit 0 prendido para suma 
    goto Listo      
    
resta:
    call Delay      ;sistema anti rebotes
    btfss PORTB,1,0
    goto resta 
    
    clrf WREG
    addlw 2
    movwf aux2,0    ;marcamos bit 1 prendido para resta
    goto Listo  
    
multiplicacion:
    call Delay      ;sistema anti rebotes
    btfss PORTB,2,0
    goto multiplicacion
    
    clrf WREG
    addlw 4
    movwf aux2,0    ;marcamos bit 2 prendido para multiplicacion 
    goto Listo
    
division: 
    call Delay      ;sistema anti rebotes
    btfss PORTB,3,0
    goto division
    
    clrf WREG
    addlw 8
    movwf aux2,0    ;marcamos bit 3 prendido para resta
    goto Listo
    
/////////////////////Operacion///////////////////////
Operacion:           ;En esta sección se determina que operando se seleccionó
    btfss aux2,0,0
    goto otro
    goto sumatoria 
otro:
    btfss aux2,1,0
    goto otro2
    goto substraccion 
otro2:
    btfss aux2,2,0
    goto otro3
    goto multipli 
otro3:
    btfss aux2,3,0
    goto Operacion 
    goto divisiones 
    
/////////////////////Operacion pt2///////////////////
sumatoria:
    clrf WREG
    movf Num1,0,0    ;movimiento a WREG para poder sumar 
    addwf Num2,0,0    ;suma y se guarda en WREG
    movwf Resultado,0 ;Se guarda resultado
    
    call Resultadoo ;se espera que pulse igual
Respuesta:
    call Delay
    btfss PORTB,3,0
    goto Respuesta
    
    movff Resultado,help ;para utilizarse en unidades
Decenas:
    clrf WREG
    movlw 10 
    subwf Resultado,1 ;Resta de Resultado-10. guardado en f 
    btfss STATUS,0,0  ;Se checa si hay mas decenas
    goto Unidades     ;Ya no hay mas decenas
    incf Decc,1        ;registro que gaura decenas 
    movff Resultado,help ;Se utilizara para sacar unidades
    goto Decenas      ;loop 
    
Unidades:
    incf Uni,1  ;incremento de registro que lleva unidades
    dcfsnz help,1
    goto finalDecUni
    goto Unidades
    
finalDecUni:
    clrf WREG
    rrncf Decc,1  ;Para posicionarlo en los 4 bits mas significativos
    rrncf Decc,1
    rrncf Decc,1
    rrncf Decc,1
    movf Decc,0
    addwf Uni,1 ;resultado final guarado en uni
    movff Uni,LATD ;se muestra resultado en LEDs 
fiin:
    goto Borradofinal ;esperamos a que pulse "delete" para sacar nueva operacion
///////////////////////////////    
substraccion: 
    clrf WREG
    movf Num2,0,0       ;Pasar valor a WREG para facilitar operacion
    subwf Num1,0,0       ;Num1-Num2
    movwf Resultado,0   ;Se guarda resultado 
    btfss STATUS,0,0    ;Checa resultado negativo 
    goto Neg            ;Resultado negativo
    goto subs           ;resultado positivo
    
Neg:
    call Resultadoo ;se espera que pulse igual
R1:
    call Delay
    btfss PORTB,3,0
    goto R1
    ;COMPLEMENTO A2
    movwf CA2 
    btg Resultado,0
    btg Resultado,1
    btg Resultado,2
    btg Resultado,3
    btg Resultado,4
    btg Resultado,5
    btg Resultado,6
    clrf WREG 
    addlw 1
    addwf Resultado,0 ;resultado gaurdado en WREG 
    movf CA2,0
    subwf Resultado,1 ;resultado guardado en f
    
    movff Resultado,help ;para utilizarse en unidades
DecenasR:
    clrf WREG
    movlw 10 
    subwf Resultado,1 ;Resta de Resultado-10. guardado en f 
    btfss STATUS,0,0  ;Se checa si hay mas decenas
    goto UnidadesR     ;Ya no hay mas decenas
    incf Decc,1        ;registro que gaura decenas 
    movff Resultado,help ;Se utilizara para sacar unidades
    goto DecenasR      ;loop 
    
UnidadesR:
    incf Uni,1  ;incremento de registro que lleva unidades
    dcfsnz help,1
    goto finalDecUniR
    goto UnidadesR
    
finalDecUniR:
    clrf WREG
    rrncf Decc,1  ;Para posicionarlo en los 4 bits mas significativos
    rrncf Decc,1
    rrncf Decc,1
    rrncf Decc,1
    movf Decc,0
    addwf Uni,1 ;resultado final guarado en uni
    movff Uni,LATD ;se muestra resultado en LEDs 
    
    bsf LATD,7,0        ;indicador de que fue resultado negativo 
    goto fiin2
    
subs:
    call Resultadoo ;se espera que pulse igual
R2:
    call Delay
    btfss PORTB,3,0
    goto R2
   
    movff Resultado,help ;para utilizarse en unidades
DecenasR2:
    clrf WREG
    movlw 10 
    subwf Resultado,1 ;Resta de Resultado-10. guardado en f 
    btfss STATUS,0,0  ;Se checa si hay mas decenas
    goto UnidadesR2     ;Ya no hay mas decenas
    incf Decc,1        ;registro que gaura decenas 
    movff Resultado,help ;Se utilizara para sacar unidades
    goto DecenasR2      ;loop 
    
UnidadesR2:
    incf Uni,1  ;incremento de registro que lleva unidades
    dcfsnz help,1
    goto finalDecUniR2
    goto UnidadesR2
    
finalDecUniR2:
    clrf WREG
    rrncf Decc,1  ;Para posicionarlo en los 4 bits mas significativos
    rrncf Decc,1
    rrncf Decc,1
    rrncf Decc,1
    movf Decc,0
    addwf Uni,1 ;resultado final guarado en uni
    movff Uni,LATD ;se muestra resultado en LEDs 
fiin2:  
    goto Borradofinal 
    goto fiin2
////////////////////////////////   
multipli: 
    clrf WREG
    movf Num1,0,0 ;guardamos el valor de uno a WREG 
    mulwf Num2,0 ;mutiplicacion, se guarda en WREG Num1xNum2
    
    call Resultadoo ;se espera que pulse igual
R3:
    call Delay
    btfss PORTB,3,0
    goto R3
    
    movff PRODL,help ;para utilizarse en unidades
DecenasM:
    clrf WREG
    movlw 10 
    subwf PRODL,1 ;Resta de Resultado-10. guardado en f 
    btfss STATUS,0,0  ;Se checa si hay mas decenas
    goto UnidadesM     ;Ya no hay mas decenas
    incf Decc,1        ;registro que gaura decenas 
    movff PRODL,help ;Se utilizara para sacar unidades
    goto DecenasM      ;loop 
    
UnidadesM:
    incf Uni,1  ;incremento de registro que lleva unidades
    dcfsnz help,1
    goto finalDecUniM
    goto UnidadesM
    
finalDecUniM:
    clrf WREG
    rrncf Decc,1  ;Para posicionarlo en los 4 bits mas significativos
    rrncf Decc,1
    rrncf Decc,1
    rrncf Decc,1
    movf Decc,0  ;Lo usamos para facilitar suma
    addwf Uni,1 ;resultado final guardo en uni
    movff Uni,LATD ;se muestra resultado en LEDs 
fiin3:
    call Borradofinal   ;se espera que borre 
    goto fiin3
///////////////////////////////    
divisiones: 
    tstfsz Num2,0  ;evitamos divisiones entre 0
    goto Normal 
    goto NOPE
Normal: 
    clrf WREG
    movf Num2,0,0  ;guardamos valor en WREG para operacion 
    subwf Num1,0,0 ;realizamos suma  Num1-Num2. Se guardo en WREG
    btfsc STATUS,0,0  ;Checa si ya no cabe mas veces 
    goto normal2
    goto fiin4
normal2:
    movwf Num1,0   ;pasamos para posible loop
    incf Resultado,1,0
    goto divisiones 
   
fiin4: 
    call Resultadoo
R42:
    call Delay
    btfss PORTB,3,0
    goto R42
    
    movff Resultado,help ;para utilizarse en unidades
DecenasD:
    clrf WREG
    movlw 10 
    subwf Resultado,1 ;Resta de Resultado-10. guardado en f 
    btfss STATUS,0,0  ;Se checa si hay mas decenas
    goto UnidadesD     ;Ya no hay mas decenas
    incf Decc,1        ;registro que gaura decenas 
    movff Resultado,help ;Se utilizara para sacar unidades
    goto DecenasD      ;loop 
    
UnidadesD:
    incf Uni,1  ;incremento de registro que lleva unidades
    dcfsnz help,1
    goto finalDecUniD
    goto UnidadesD
    
finalDecUniD:
    clrf WREG
    rrncf Decc,1  ;Para posicionarlo en los 4 bits mas significativos
    rrncf Decc,1
    rrncf Decc,1
    rrncf Decc,1
    movf Decc,0
    addwf Uni,1 ;resultado final guarado en uni
    movff Uni,LATD ;se muestra resultado en LEDs 
    
    goto Borradofinal
    
NOPE:                    ;Rutina que señala division entre 0 
    call Resultadoo
R43:
    call Delay
    btfss PORTB,3,0
    goto R43
    ;Señal de que es error 
    movlw 0b00001111
    movwf LATD,0
    call DElay 
    movlw 0b11110000
    movwf LATD,0
    goto Borradofinal ;se espera que pulse delete 
/////////////////////Limpieza////////////////////////
Delete:             ;Aqui se borra el contenido de todos los registros
    call Delay
    btfss PORTB,3,0
    goto Delete
    
    bz aux          ;en caso de que solo se borre Num2
    goto prueba2
    clrf Num1,0
    clrf aux,0
    clrf LATD,0
    goto Teclado
    
prueba2:            ;en caso de que solo se borre Num2
    clrf Num2
    clrf aux,0
    clrf LATD,0
    goto Teclado    ;Se regresa a estado inicial en Teclado 
    
Delete2:            ;en caso de que se busque borrarse todo 
    call Delay
    btfss PORTB,3,0
    goto Delete2
    clrf Num1
    clrf Num2
    clrf aux
    clrf aux2
    clrf Resultado
    clrf Uni
    clrf Decc
    clrf help
    clrf help2
    clrf LATD
    clrf WREG
    goto Teclado
/////////////////////Retardo//////////////////////////
Delay: ;retardo de 2ms
    movlw 255
    movwf VARA,0
    movwf VARB,0
    
loop: 
    decfsz VARB,1,0
    goto loop
    decfsz VARA,1,0
    goto loop
    return
    
DElay:
     movlw 50
     movwf C2,0
CC:  movlw 100
     movwf C1,0
CB:  movlw 10
     movwf C0,0
cicloo:  nop        ;1 ciclo*C 
        decfsz C0,1,0  ;1 ciclo*(C-1)+2
	goto cicloo    ;2 ciclos*(C-1)
        decfsz C1,1,0  ;1 ciclo*(C-1)+2
	goto CB
        decfsz C2,1,0  ;1 ciclo*(C-1)+2
	goto CC   
        return   
	
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


