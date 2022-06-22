/// P7_2.asm
// Demostración #7 - Ejercicio 2
// Luis Kevin Cepeda Zapata A00824840
// Rodrigo Hugues Gudiño    A01620071
//NOTA: Por su similitud con la entrega anterior, todo el codigo nuevo esta
//marcado con un **
    RADIX DEC	
    PROCESSOR 18F45K50
    #include "pic18f45k50.inc"
    
// Memory Allocation
    PSECT resetVec, class=CODE, reloc=2, abs
    ORG 0		//indica que es el inicio del codigo 
    #define vara 0x11	//timer
    #define varb 0x12	//timer
    #define num1 0x01	//Este valor guarda el primer número y el resultado
    #define num2 0x02	//Este valor guarda el segúndo número
    #define Delayconst0 0x06
    #define operator 0x07   //define el valor de operador		      **
    #define CN	 0x03	    //Este valor guarda la constante negativa
    #define DV   0x04	    //Este valor permite guardar el número ántes de div
    #define SK 0x05	    //ESte valor garda una constante para convertir de
    #define RS  LATE, 0, A  //RS					     {**
    #define E   LATE, 2, A  //Estatus					    
    #define LRW  LATE, 1, A //Comando E 
    #define dataLCD LATD, A //Puerto del LCD				     }** 
    CLRF    CN
// Reset Vector
resetVec:
    ORG 32	    //La instrucción Start se guarda en 32
    

    
    //Configuración TEclado Matricial
BCF  INTCON2, 7, A	    // activar pull ups
    MOVLW 0b00001111	    //15, para dejar 4 bits apagados y cuetro prendidos
    MOVWF TRISB, A          // Activa el puerto RB0-RB3 como entrada 
    MOVWF WPUB, A           // Activa pull up
    CLRF ANSELB, A          // Digital
    CLRF PORTB		    
    MOVLW 0b00000001	    //
    MOVWF num1, 0	    //Precargar un valor a Num1 para evitar errores
    MOVWF num2, 0	    //Precargar un valor a Num2 para evitar errores
    MOVLW 48
    movwf SK, 0
ConfLCD:		    //						   //{**
    movlb	15	//Selectlastbank(SFRs)
    clrf ANSELE, 1	//Forces digital I/O
    clrf TRISE, A  
    clrf ANSELD, 1
    clrf TRISD,A
    MOVLW 0b00111000	// escritura en dos líneas: DL = 8bit; N = 2 lines;  
    call SetProps
    MOVLW 0b00001100	// Encender Display, sin cursor activo: D = 1; C = 0;
    call SetProps
    MOVLW 0b00000110	// Configurar desplazamiento incremental: I/D = 1
    call SetProps
    MOVLW 0b00000001	// Clearing display
    call SetProps
    call delay_800ms							   //}**
TECLADO:  
    MOVLW   0
    MOVWF   CN, 0
    MOVLW 0b01111111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO UNO
    BTFSS PORTB, 2,0	// Comparación
    GOTO DOS
    BTFSS PORTB, 1,0	// Comparación
    GOTO TRES
    BTFSS PORTB, 0,0	// Comparación
    GOTO LA
    MOVLW 0b10111111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO CUATRO
    BTFSS PORTB, 2,0	// Comparación
    GOTO CINCO
    BTFSS PORTB, 1,0	// Comparación
    GOTO SEIS
    BTFSS PORTB, 0,0	// Comparación
    GOTO LB
    MOVLW 0b11011111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO SIETE
    BTFSS PORTB, 2,0	// Comparación
    GOTO OCHO
    BTFSS PORTB, 1,0	// Comparación
    GOTO NUEVE
    BTFSS PORTB, 0,0	// Comparación
    GOTO LC
    MOVLW 0b11101111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO AST
    BTFSS PORTB, 2,0	// Comparación
    GOTO CERO
    BTFSS PORTB, 1,0	// Comparación
    GOTO GATO
    BTFSS PORTB, 0,0	// Comparación
    GOTO LD
    GOTO TECLADO	// Regresar a teclado
    
UNO:			
    call delay_20ms	// Antirebote
    MOVLW 1		
    MOVWF num1, 0	// Guarda 1 en el num1 	
    MOVF num1, 0, 0 
    call WriteLCD_1 // En vez de escribir el valor como numero binario, se    **
    // a una subfuncion que la escribe en la posición 1 del LCD
    btfss PORTB, 3, 0   
    goto UNO
    goto TECLADO
			   
DOS:			// Funciona igual a la funcion en linea 110
    call delay_20ms	// Antirebote
    MOVLW 2
    MOVWF num1, 0	// Guarda 2 en el num1
    MOVF num1, 0, 0
    call WriteLCD_1	// Igual a Linea 115				      **
    btfss PORTB, 2, 0	// Revisa si se dejo de presionar el boton
    goto DOS
    goto TECLADO 
    
TRES:			// Funciona igual a la funcion en linea 110
    call delay_20ms	//Antirebote
    MOVLW 3
    MOVWF num1, 0	// Guarda 3 en el num1
    MOVF num1, 0, 0
    call WriteLCD_1	// Igual a Linea 115				      **
    btfss PORTB, 1, 0  
    goto TRES
    goto TECLADO     
    
    //SE mueve el valor 43 al registro operator que es equivalente a "+" en ASCI
LA: 
    call delay_20ms	//Antirebote
    movlw 43								    //**
    movwf operator,0							    //**
    call WriteLCD_2							    //**
    btfss PORTB, 0, 0  
    goto LA
    goto TECLADOSUMA     
    
CUATRO:			// Funciona igual a la funcion en linea 110
    call delay_20ms	//Antirebote
    MOVLW 4
    MOVWF num1, 0	// Guarda 4 en el num1
    MOVF num1, 0, 0
    call WriteLCD_1	// Igual a Linea 115				      **
    btfss PORTB, 3, 0	
    goto CUATRO
    goto TECLADO
    
CINCO:			// Funciona igual a la funcion en linea 110
    call delay_20ms //Antirebote
    MOVLW 5
    MOVWF num1, 0	// Guarda 5 en el num1
    MOVF num1, 0, 0
    call WriteLCD_1	// Igual a Linea 115				      **
    btfss PORTB, 2, 0   //boton 1?
    goto CINCO
    goto TECLADO 
    
SEIS: // Funciona igual a la funcion en linea 110
    call delay_20ms //Antirebote
    MOVLW 6
    MOVWF num1, 0	// Guarda 6 en el num1
    MOVF num1, 0, 0
    call WriteLCD_1	// Igual a Linea 115				      **
    btfss PORTB, 1, 0   //boton 1?
    goto SEIS
    goto TECLADO	 
    
    //SE mueve el valor 43 al registro operator que es equivalente a "-" en ASCI 
LB:
    call delay_20ms	//Antirebote
    movlw 45								    //**
    movwf operator,0							    //**
    call WriteLCD_1	// Igual a Linea 115				      **
    btfss PORTB, 0, 0   //boton 1?
    goto LB
    goto TECLADORESTA    
    
SIETE:			// Funciona igual a la funcion en linea 110
    call delay_20ms	//Antirebote
    MOVLW 7
    MOVWF num1, 0	// Guarda 7 en el num1
    MOVF num1, 0, 0
    call WriteLCD_1	// Igual a Linea 115				      **
    btfss PORTB, 3, 0	//boton 1?
    goto SIETE
    goto TECLADO

OCHO:			// Funciona igual a la funcion en linea 110
    call delay_20ms	//Antirebote
    MOVLW 8
    MOVWF num1, 0	// Guarda 8 en el num1
    MOVF num1, 0, 0	//Apuntar
    call WriteLCD_1	// Igual a Linea 115				      **
    btfss PORTB, 2, 0	//boton 1?
    goto OCHO
    goto TECLADO 
    
NUEVE:			// Funciona igual a la funcion en linea 110
    call delay_20ms	//Antirebote
    MOVLW 9
    MOVWF num1, 0	// Guarda 9 en el num1
    MOVF num1, 0, 0
    call WriteLCD_1	// Igual a Linea 115				      **
    btfss PORTB, 1, 0	//boton 1?
    goto NUEVE
    goto TECLADO     

    //SE mueve el valor 43 al registro operator que es equivalente a "*" en ASCI 
LC:
    call delay_20ms	//Antirebote
    movlw 42								    //**
    movwf operator,0
    call WriteLCD_2
    btfss PORTB, 0, 0	//boton 1?
    goto LC
    goto TECLADOMULTI
    
AST:	//EN este caso no hace nada la operación
    call delay_20ms	//Antirebote
    btfss PORTB, 3, 0	//boton 1?
    goto AST
    goto TECLADO   

CERO:			// Funciona igual a la funcion en linea 110
    call delay_20ms	//Antirebote
    MOVLW 0
    MOVWF num1, 0	// Guarda 0 en el num1
    MOVF num1, 0, 0
    call WriteLCD_1	// Igual a Linea 115				      **
    btfss PORTB, 2, 0   //Para soltar 
    goto CERO
    goto TECLADO 
    
GATO:
    call delay_20ms	//Antirebote
    MOVLW 0b00000001	//Clearing display
    call SetProps
    btfss PORTB, 1, 0	//Para soltar
    goto GATO
    goto TECLADO     
    
    //SE mueve el valor 43 al registro operator que es equivalente a "/" en ASCI 
LD:
    call delay_20ms	//Antirebote
    movlw 47								    //**
    movwf operator,0							    //**
    call WriteLCD_2							    //**	    
    btfss PORTB, 0, 0  //Para soltar
    goto LD
    goto TECLADODIV
    
//Es una copia exacta de la subfuncion de teclado pero se usa cuando ya se 
    //selecciono el signo de suma
TECLADOSUMA:   
    MOVLW 0b01111111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO UNOSUMA
    BTFSS PORTB, 2,0	// Comparación
    GOTO DOSSUMA
    BTFSS PORTB, 1,0	// Comparación
    GOTO TRESSUMA
    BTFSS PORTB, 0,0	// Comparación
    GOTO LASUMA
    
    MOVLW 0b10111111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO CUATROSUMA
    BTFSS PORTB, 2,0	// Comparación
    GOTO CINCOSUMA
    BTFSS PORTB, 1,0	// Comparación
    GOTO SEISSUMA
    BTFSS PORTB, 0,0	// Comparación
    GOTO LBSUMA
    
    MOVLW 0b11011111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO SIETESUMA
    BTFSS PORTB, 2,0	// Comparación
    GOTO OCHOSUMA
    BTFSS PORTB, 1,0	// Comparación
    GOTO NUEVESUMA
    BTFSS PORTB, 0,0	// Comparación
    GOTO LCSUMA
    
    MOVLW 0b11101111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO ASTSUMA
    BTFSS PORTB, 2,0	// Comparación
    GOTO CEROSUMA
    BTFSS PORTB, 1,0	// Comparación
    GOTO GATOSUMA
    BTFSS PORTB, 0,0	// Comparación
    GOTO LDSUMA
    
    GOTO TECLADOSUMA	// Regresar a teclado
    
UNOSUMA:
    call delay_20ms	//Antirebote
    MOVLW 1
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Valor 1
    call WriteLCD_3
    btfss PORTB, 3, 0  //boton 1?
    goto UNOSUMA
    goto TECLADOSUMA
    
DOSSUMA:
    call delay_20ms //Antirebote
    MOVLW 2
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Valor 2
    call WriteLCD_3
    btfss PORTB, 2, 0  //boton 1?
    goto DOSSUMA
    goto TECLADOSUMA
    
TRESSUMA:
    call delay_20ms //Antirebote
    MOVLW 3
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Valor 3
    call WriteLCD_3
    btfss PORTB, 1, 0  //boton 1?
    goto TRESSUMA
    goto TECLADOSUMA    
    
LASUMA:
    call delay_20ms	//Antirebote
    movlw 43
    movwf operator,0
    call WriteLCD_2
    btfss PORTB, 0, 0  //boton 1?
    goto LASUMA
    goto TECLADOSUMA   
    
CUATROSUMA:
    call delay_20ms //Antirebote
    MOVLW 4
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Apuntar 4
    call WriteLCD_3
    btfss PORTB, 3, 0  //boton 1?
    goto CUATROSUMA
    goto TECLADOSUMA
    
CINCOSUMA:
    call delay_20ms //Antirebote
    MOVLW 5
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Apuntar 5
    call WriteLCD_3
    btfss PORTB, 2, 0  //boton 1?
    goto CINCOSUMA
    goto TECLADOSUMA
    
SEISSUMA:
    call delay_20ms //Antirebote
    MOVLW 6
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss PORTB, 1, 0  //boton 1?
    goto SEISSUMA
    goto TECLADOSUMA 
    
LBSUMA:
    call delay_20ms //Antirebote
    movlw 45
    movwf operator,0
    call WriteLCD_2
    btfss PORTB, 0, 0  //boton 1?
    goto LBSUMA
    goto TECLADORESTA
    
SIETESUMA:
    call delay_20ms //Antirebote
    MOVLW 7
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss PORTB, 3, 0  //boton 1?
    goto SIETESUMA
    goto TECLADOSUMA

OCHOSUMA:
    call delay_20ms //Antirebote
    MOVLW 8
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss PORTB, 2, 0  //boton 1?
    goto OCHOSUMA
    goto TECLADOSUMA
    
NUEVESUMA:
    call delay_20ms //Antirebote
    MOVLW 9
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0
    call WriteLCD_3
    btfss PORTB, 1, 0  //boton 1?
    goto NUEVESUMA
    goto TECLADOSUMA    
    
LCSUMA:
    call delay_20ms //Antirebote
    movlw 42
    movwf operator,0
    call WriteLCD_2
    btfss PORTB, 0, 0  //boton 1?
    goto LCSUMA
    goto TECLADOMULTI
    
ASTSUMA:
    call delay_20ms //Antirebote
    btfss PORTB, 3, 0  //boton 1?
    goto ASTSUMA
    goto RESULTSUMA
    
CEROSUMA:
    call delay_20ms //Antirebote
    MOVLW 0
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0
    call WriteLCD_3
    btfss PORTB, 2, 0  //Para soltar 
    goto CEROSUMA
    goto TECLADOSUMA 
    
GATOSUMA:
    call delay_20ms //Antirebote
    MOVLW 0b00000001 ; Clearing display
    call SetProps
    btfss PORTB, 1, 0  //Para soltar
    goto GATOSUMA
    goto TECLADO     
    
LDSUMA:
    call delay_20ms //Antirebote
    movlw 47
    movwf operator,0
    call WriteLCD_2
    btfss PORTB, 0, 0  //Para soltar
    goto LDSUMA
    goto TECLADODIV

//Es una copia exacta de la subfuncion de teclado pero se usa cuando ya se 
    //selecciono el signo de resta
TECLADORESTA:   
    MOVLW 0b01111111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO UNORESTA
    BTFSS PORTB, 2,0	// Comparación
    GOTO DOSRESTA
    BTFSS PORTB, 1,0	// Comparación
    GOTO TRESRESTA
    BTFSS PORTB, 0,0	// Comparación
    GOTO LARESTA
    
    MOVLW 0b10111111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO CUATRORESTA
    BTFSS PORTB, 2,0	// Comparación
    GOTO CINCORESTA
    BTFSS PORTB, 1,0	// Comparación
    GOTO SEISRESTA
    BTFSS PORTB, 0,0	// Comparación
    GOTO LBRESTA
    
    MOVLW 0b11011111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO SIETERESTA
    BTFSS PORTB, 2,0	// Comparación
    GOTO OCHORESTA
    BTFSS PORTB, 1,0	// Comparación
    GOTO NUEVERESTA
    BTFSS PORTB, 0,0	// Comparación
    GOTO LCRESTA
    
    MOVLW 0b11101111    //cargar valor al work
    MOVWF LATB, A       //cargar y dejar en acceso
    BTFSS PORTB, 3,0	// Comparación
    GOTO ASTRESTA
    BTFSS PORTB, 2,0	// Comparación
    GOTO CERORESTA
    BTFSS PORTB, 1,0	// Comparación
    GOTO GATORESTA
    BTFSS PORTB, 0,0	// Comparación
    GOTO LDRESTA
    
    GOTO TECLADORESTA	// Regresar a teclado
    

UNORESTA:
    call delay_20ms //Antirebote
    MOVLW 1
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Valor 1
    call WriteLCD_3
    btfss PORTB, 3, 0  //boton 1?
    goto UNORESTA
    goto TECLADORESTA
    

DOSRESTA:
    call delay_20ms //Antirebote
    MOVLW 2
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Valor 2
    call WriteLCD_3
    btfss PORTB, 2, 0  //boton 1?
    goto DOSRESTA
    goto TECLADORESTA
    
TRESRESTA:
    call delay_20ms //Antirebote
    MOVLW 3
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Valor 3
    call WriteLCD_3
    btfss PORTB, 1, 0  //boton 1?
    goto TRESRESTA
    goto TECLADORESTA    
    
LARESTA:
    call delay_20ms	//Antirebote
    movlw 43
    movwf operator,0
    call WriteLCD_2
    btfss PORTB, 0, 0  //boton 1?
    goto LARESTA
    goto TECLADOSUMA   
    
CUATRORESTA:
    call delay_20ms //Antirebote
    MOVLW 4
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Apuntar 4
    call WriteLCD_3
    btfss PORTB, 3, 0  //boton 1?
    goto CUATRORESTA
    goto TECLADORESTA
    

CINCORESTA:
    call delay_20ms //Antirebote
    MOVLW 5
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Apuntar 5
    call WriteLCD_3
    btfss PORTB, 2, 0  //boton 1?
    goto CINCORESTA
    goto TECLADORESTA
    
SEISRESTA:
    call delay_20ms //Antirebote
    MOVLW 6
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss PORTB, 1, 0  //boton 1?
    goto SEISRESTA
    goto TECLADORESTA 
    
LBRESTA:
    call delay_20ms //Antirebote
    movlw 45
    movwf operator,0
    call WriteLCD_2
    btfss PORTB, 0, 0  //boton 1?
    goto LBRESTA
    goto TECLADORESTA
    
SIETERESTA:
    call delay_20ms //Antirebote
    MOVLW 7
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss PORTB, 3, 0  //boton 1?
    goto SIETERESTA
    goto TECLADORESTA
    
OCHORESTA:
    call delay_20ms //Antirebote
    MOVLW 8
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss PORTB, 2, 0  //boton 1?
    goto OCHORESTA
    goto TECLADORESTA
    
NUEVERESTA:
    call delay_20ms //Antirebote
    MOVLW 9
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0
    call WriteLCD_3
    btfss PORTB, 1, 0  //boton 1?
    goto NUEVERESTA
    goto TECLADORESTA    
    
LCRESTA:
    call delay_20ms //Antirebote
    movlw 42
    movwf operator,0
    call WriteLCD_2
    btfss PORTB, 0, 0  //boton 1?
    goto LCRESTA
    goto TECLADOMULTI
    
ASTRESTA:
    call delay_20ms //Antirebote
    btfss PORTB, 3, 0  //boton 1?
    goto ASTRESTA
    goto RESULTRESTA
    

CERORESTA:
    call delay_20ms //Antirebote
    MOVLW 0
    MOVWF num2, 0	    //Valor 3
    MOVF num2, 0, 0
    call WriteLCD_3
    btfss PORTB, 2, 0  //Para soltar 
    goto CERORESTA
    goto TECLADORESTA 
    
GATORESTA:
    call    delay_20ms //Antirebote
    MOVLW 0b00000001 ; Clearing display
    call SetProps
    btfss   PORTB, 1, 0  //Para soltar
    goto    GATORESTA
    goto    TECLADO    
    
LDRESTA:
    call    delay_20ms //Antirebote
    movlw 47
    movwf operator,0
    call WriteLCD_2
    btfss   PORTB, 0, 0  //Para soltar
    goto    LDRESTA
    goto    TECLADODIV    
    
    
    
    
//Es una copia exacta de la subfuncion de teclado pero se usa cuando ya se 
    //selecciono el signo de multiplicación
TECLADOMULTI:   
    MOVLW   0b01111111    //cargar valor al work
    MOVWF   LATB, A       //cargar y dejar en acceso
    BTFSS   PORTB, 3,0	// Comparación
    GOTO    UNOMULTI
    BTFSS   PORTB, 2,0	// Comparación
    GOTO    DOSMULTI
    BTFSS   PORTB, 1,0	// Comparación
    GOTO    TRESMULTI
    BTFSS   PORTB, 0,0	// Comparación
    GOTO    LAMULTI
    
    MOVLW   0b10111111    //cargar valor al work
    MOVWF   LATB, A       //cargar y dejar en acceso
    BTFSS   PORTB, 3,0	// Comparación
    GOTO    CUATROMULTI
    BTFSS   PORTB, 2,0	// Comparación
    GOTO    CINCOMULTI
    BTFSS   PORTB, 1,0	// Comparación
    GOTO    SEISMULTI
    BTFSS   PORTB, 0,0	// Comparación
    GOTO    LBMULTI
    
    MOVLW   0b11011111    //cargar valor al work
    MOVWF   LATB, A       //cargar y dejar en acceso
    BTFSS   PORTB, 3,0	// Comparación
    GOTO    SIETEMULTI
    BTFSS   PORTB, 2,0	// Comparación
    GOTO    OCHOMULTI
    BTFSS   PORTB, 1,0	// Comparación
    GOTO    NUEVEMULTI
    BTFSS   PORTB, 0,0	// Comparación
    GOTO    LCMULTI
    
    MOVLW   0b11101111    //cargar valor al work
    MOVWF   LATB, A       //cargar y dejar en acceso
    BTFSS   PORTB, 3,0	// Comparación
    GOTO    ASTMULTI
    BTFSS   PORTB, 2,0	// Comparación
    GOTO    CEROMULTI
    BTFSS   PORTB, 1,0	// Comparación
    GOTO    GATOMULTI
    BTFSS   PORTB, 0,0	// Comparación
    GOTO    LDMULTI
    
    GOTO    TECLADOMULTI	// Regresar a teclado
    

UNOMULTI:
    call    delay_20ms //Antirebote
    MOVLW   1
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Valor 1
    call WriteLCD_3
    btfss   PORTB, 3, 0  //boton 1?
    goto    UNOMULTI
    goto    TECLADOMULTI
    

DOSMULTI:
    call    delay_20ms //Antirebote
    MOVLW   2
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Valor 2
    call WriteLCD_3
    btfss   PORTB, 2, 0  //boton 1?
    goto    DOSMULTI
    goto    TECLADOMULTI
    
TRESMULTI:
    call    delay_20ms //Antirebote
    MOVLW   3
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0    //Valor 3
    call WriteLCD_3
    btfss   PORTB, 1, 0  //boton 1?
    goto    TRESMULTI
    goto    TECLADOMULTI    
    
LAMULTI:
    call    delay_20ms	//Antirebote
    movlw 43
    movwf operator,0
    call WriteLCD_2
    btfss   PORTB, 0, 0  //boton 1?
    goto    LAMULTI
    goto    TECLADOSUMA   
    
CUATROMULTI:
    call    delay_20ms //Antirebote
    MOVLW   4
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Apuntar 4
    call WriteLCD_3
    btfss   PORTB, 3, 0  //boton 1?
    goto    CUATROMULTI
    goto    TECLADOMULTI
    

CINCOMULTI:
    call    delay_20ms //Antirebote
    MOVLW   5
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Apuntar 5
    call WriteLCD_3
    btfss   PORTB, 2, 0  //boton 1?
    goto    CINCOMULTI
    goto    TECLADOMULTI
    
SEISMULTI:
    call    delay_20ms //Antirebote
    MOVLW   6
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss   PORTB, 1, 0  //boton 1?
    goto    SEISMULTI
    goto    TECLADOMULTI 
    
LBMULTI:
    call    delay_20ms //Antirebote
    movlw 45
    movwf operator,0
    call WriteLCD_2
    btfss   PORTB, 0, 0  //boton 1?
    goto    LBMULTI
    goto    TECLADORESTA
    
SIETEMULTI:
    call    delay_20ms //Antirebote
    MOVLW   7
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss   PORTB, 3, 0  //boton 1?
    goto    SIETEMULTI
    goto    TECLADOMULTI
    

OCHOMULTI:
    call    delay_20ms //Antirebote
    MOVLW   8
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss   PORTB, 2, 0  //boton 1?
    goto    OCHOMULTI
    goto    TECLADOMULTI
    
NUEVEMULTI:
    call    delay_20ms //Antirebote
    MOVLW   9
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0
    call WriteLCD_3
    btfss   PORTB, 1, 0  //boton 1?
    goto    NUEVEMULTI
    goto    TECLADOMULTI    
    
LCMULTI:
    call    delay_20ms //Antirebote
    movlw 42
    movwf operator,0
    call WriteLCD_2
    btfss   PORTB, 0, 0  //boton 1?
    goto    LCMULTI
    goto    TECLADOMULTI
    
ASTMULTI:
    call    delay_20ms //Antirebote
    btfss   PORTB, 3, 0  //boton 1?
    goto    ASTMULTI
    goto    RESULTMULTI
    

CEROMULTI:
    call    delay_20ms //Antirebote
    MOVLW   0
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0
    call WriteLCD_3
    btfss   PORTB, 2, 0  //Para soltar 
    goto    CEROMULTI
    goto    TECLADOMULTI 
    
GATOMULTI:
    call    delay_20ms //Antirebote
    MOVLW 0b00000001 ; Clearing display
    call SetProps
    btfss   PORTB, 1, 0  //Para soltar
    goto    GATOMULTI
    goto    TECLADO    
    
LDMULTI:
    call    delay_20ms //Antirebote
    movlw 47
    movwf operator,0
    call WriteLCD_2
    btfss   PORTB, 0, 0  //Para soltar
    goto    LDMULTI
    goto    TECLADODIV
    
//Es una copia exacta de la subfuncion de teclado pero se usa cuando ya se 
    //selecciono el signo de división
TECLADODIV: 
    MOVLW   0b01111111    //cargar valor al work
    MOVWF   LATB, A       //cargar y dejar en acceso
    BTFSS   PORTB, 3,0	// Comparación
    GOTO    UNODIV
    BTFSS   PORTB, 2,0	// Comparación
    GOTO    DOSDIV
    BTFSS   PORTB, 1,0	// Comparación
    GOTO    TRESDIV
    BTFSS   PORTB, 0,0	// Comparación
    GOTO    LADIV
    
    MOVLW   0b10111111    //cargar valor al work
    MOVWF   LATB, A       //cargar y dejar en acceso
    BTFSS   PORTB, 3,0	// Comparación
    GOTO    CUATRODIV
    BTFSS   PORTB, 2,0	// Comparación
    GOTO    CINCODIV
    BTFSS   PORTB, 1,0	// Comparación
    GOTO    SEISDIV
    BTFSS   PORTB, 0,0	// Comparación
    GOTO    LBDIV
    
    MOVLW   0b11011111    //cargar valor al work
    MOVWF   LATB, A       //cargar y dejar en acceso
    BTFSS   PORTB, 3,0	// Comparación
    GOTO    SIETEDIV
    BTFSS   PORTB, 2,0	// Comparación
    GOTO    OCHODIV
    BTFSS   PORTB, 1,0	// Comparación
    GOTO    NUEVEDIV
    BTFSS   PORTB, 0,0	// Comparación
    GOTO    LCDIV
    
    MOVLW   0b11101111    //cargar valor al work
    MOVWF   LATB, A       //cargar y dejar en acceso
    BTFSS   PORTB, 3,0	// Comparación
    GOTO    ASTDIV
    BTFSS   PORTB, 2,0	// Comparación
    GOTO    CERODIV
    BTFSS   PORTB, 1,0	// Comparación
    GOTO    GATODIV
    BTFSS   PORTB, 0,0	// Comparación
    GOTO    LDDIV
    
    GOTO    TECLADODIV	// Regresar a teclado
    

UNODIV:
    call    delay_20ms	    //Antirebote
    MOVLW   1
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Valor 1
    call WriteLCD_3
    btfss   PORTB, 3, 0	    //boton 1?
    goto    UNODIV
    goto    TECLADODIV
    

DOSDIV:
    call    delay_20ms //Antirebote
    MOVLW   2
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Valor 2
    call WriteLCD_3
    btfss   PORTB, 2, 0  //boton 1?
    goto    DOSDIV
    goto    TECLADODIV
    
TRESDIV:
    call    delay_20ms //Antirebote
    MOVLW   3
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Valor 3
    call WriteLCD_3
    btfss   PORTB, 1, 0  //boton 1?
    goto    TRESDIV
    goto    TECLADODIV    
    
LADIV:
    call    delay_20ms	//Antirebote
    movlw 43
    movwf operator,0
    call WriteLCD_2
    btfss   PORTB, 0, 0  //boton 1?
    goto    LADIV
    goto    TECLADOSUMA   
    
CUATRODIV:
    call    delay_20ms //Antirebote
    MOVLW   4
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Apuntar 4
    call WriteLCD_3
    btfss   PORTB, 3, 0  //boton 1?
    goto    CUATRODIV
    goto    TECLADODIV
    

CINCODIV:
    call    delay_20ms //Antirebote
    MOVLW   5
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Apuntar 5
    call WriteLCD_3
    MOVWF   num2, 0
    btfss   PORTB, 2, 0  //boton 1?
    goto    CINCODIV
    goto    TECLADODIV
    
SEISDIV:
    call    delay_20ms //Antirebote
    MOVLW   6
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss   PORTB, 1, 0  //boton 1?
    goto    SEISDIV
    goto    TECLADODIV 
    
LBDIV:
    call    delay_20ms //Antirebote
    btfss   PORTB, 0, 0  //boton 1?
    goto    LBDIV
    goto    TECLADORESTA
    
SIETEDIV:
    call    delay_20ms //Antirebote
    MOVLW   7
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss   PORTB, 3, 0  //boton 1?
    goto    SIETEDIV
    goto    TECLADODIV
    

OCHODIV:
    call    delay_20ms //Antirebote
    MOVLW   8
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0	    //Apuntar
    call WriteLCD_3
    btfss   PORTB, 2, 0  //boton 1?
    goto    OCHODIV
    goto    TECLADODIV
    
NUEVEDIV:
    call    delay_20ms //Antirebote
    MOVLW   9
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0
    call WriteLCD_3
    btfss   PORTB, 1, 0  //boton 1?
    goto    NUEVEDIV
    goto    TECLADODIV    
    
LCDIV:
    call    delay_20ms //Antirebote
    movlw 42
    movwf operator,0
    call WriteLCD_2
    btfss   PORTB, 0, 0  //boton 1?
    goto    LCDIV
    goto    TECLADOMULTI
    
ASTDIV:
    call    delay_20ms //Antirebote
    btfss   PORTB, 3, 0  //boton 1?
    goto    ASTDIV
    goto    RESULTDIV
    

CERODIV:
    call    delay_20ms //Antirebote
    MOVLW   0
    MOVWF   num2, 0	    //Valor 3
    MOVF    num2, 0, 0
    call WriteLCD_3

    btfss   PORTB, 2, 0  //Para soltar 
    goto    CERODIV
    goto    TECLADODIV 
    
GATODIV:
    call    delay_20ms //Antirebote
    MOVLW 0b00000001 ; Clearing display
    call SetProps
    btfss   PORTB, 1, 0  //Para soltar
    goto    GATODIV
    goto    TECLADODIV     
    
LDDIV:
    call    delay_20ms //Antirebote
    movlw 47
    movwf operator,0
    call WriteLCD_2
    btfss   PORTB, 0, 0  //Para soltar
    goto    LDDIV
    goto    TECLADODIV      

    //Realiza la operación de suma y la la envia a funcion de IMPRIMIR
RESULTSUMA:
    MOVF    num2, 0, 0
    ADDWF   num1, 1, 0
    MOVFF   num1, DV
    GOTO    IMPRIMIR
    GOTO    TECLADO

RESULTMULTI:
    MOVF    num2, 0, 0
    MULWF   num1, 0
    MOVF    PRODL, 0
    MOVWF   num1
    MOVFF   num1, DV
    GOTO    IMPRIMIR
    GOTO    TECLADO
    
RESULTDIV:
    MOVFF   num2, DV
    MOVLW   1
    SUBWF   DV, 0, 0
    BTFSS   STATUS, C, 0 
    GOTO    REPETIR
    MOVFF   num1, DV
    CLRF    num1
    GOTO    RESULTDIVNOCERO
    GOTO    TECLADO
    
RESULTDIVNOCERO:
    MOVF    num2, 0, 0
    SUBWF   DV
    BTFSS   STATUS, C, 0
    GOTO    IMPRIMIR_T
    INCF    num1
    GOTO    RESULTDIVNOCERO
    GOTO    TECLADO
IMPRIMIR_T:
    MOVFF   num1, DV
    GOTO    IMPRIMIR
    
    
    //En caso de DIVIDIR ENTRE CERO, envia el texto "MATH ERROR"	   //{**
REPETIR:
    movlw 0b11000010  ;Posicion DDRAM primer renglon inicia en 0x2h
    call SetProps   
    movlw 'M'
    call WriteLCD
    movlw 'A'
    call WriteLCD
    movlw 'T'
    call WriteLCD
    movlw 'H'
    call WriteLCD
    movlw ' '
    call WriteLCD
    movlw 'E'
    call WriteLCD
    movlw 'R'
    call WriteLCD
    movlw 'R'
    call WriteLCD
    movlw 'O'
    call WriteLCD
    movlw 'R'
    call WriteLCD
    GOTO    TECLADODIV							   //}**

    
    //ESta función convierte el valor resultante en dos valores:
    //CN son DECENAS mientras que num2 son unidades.
IMPRIMIR:
    movlw   0
    movwf   CN, 0
IMPRIMIR_1:
    MOVLW   0b00001010
    MOVFF   DV, num2
    SUBWF   DV, 1, 0
    BTFSS   STATUS, C, 0
    GOTO    PASARLCD							    //**
    INCF    CN
    GOTO    IMPRIMIR_1
    GOTO    TECLADO
        
PASARLCD:								   //{**
    //!###------------!
    //!--=##----------!
    movlw 0b11000010  ;Posicion DDRAM primer renglon inicia en 0x2h
    call SetProps	//Despliega el signo de igual
    movlw '='
    call WriteLCD	
    //Mueve el valor de CN son las decenas y se despliegan 
    //despues del signo de "="
    movf CN, 0		
    ADDLW 48		//Consatnte para convertir decimal a ANSI
    call WriteLCD
    //Mueve el valor de num2 son las UNIDADES y se despliegan 
    //despues del signo del numero de DECENAS
    movf num2, 0
    ADDLW 48		//Consatnte para convertir decimal a ANSI
    call WriteLCD
    GOTO TECLADO
    
    //Realiza la operación de RESTA y la la envia a funcion de IMPRIMIR
    //	tambien revisa si es NEGATIVA la operación y de ser asi lo envia 
    //	a una funcion llamada NEGATIVO
RESULTRESTA:
    MOVF    num2, 0, 0
    SUBWF   num1, 1, 0
    BTFSS   STATUS, C, 0    // Negativo C=0, positivo C=1
    GOTO    NEGATIVO
    MOVFF   num1, DV
    GOTO    IMPRIMIR      
    GOTO    TECLADO
    
NEGATIVO:
    COMF    num1    // Obtiene el complemento del valor y le suma 1
    MOVLW   0b00000001	
    ADDWF   num1, 1, 0
    MOVFF   num1, DV
    
    GOTO    IMPRIMIR_NEG
    GOTO    TECLADO
 //SE creo esta subfuncipon igual a IMPRIMIR pero ignora el valor decimal y lo
 //Substituye por un "-"
IMPRIMIR_NEG:
    movlw   0
    movwf   CN, 0
IMPRIMIR_1_NEG:
    MOVLW   0b00001010
    MOVFF   DV, num2
    SUBWF   DV, 1, 0
    BTFSS   STATUS, C, 0
    GOTO    PASARALED_NEG
    INCF    CN
    GOTO    IMPRIMIR_1_NEG

PASARALED_NEG:
    //!#-#------------!
    //!--=-#----------!
    movlw 0b11000010	
    call SetProps   
    movlw '='
    call WriteLCD
    movlw '-'		 //Substituye por un "-"
    call WriteLCD
    movf num2, 0
    ADDLW 48
    call WriteLCD
    GOTO TECLADO
    							   
WriteLCD_1:
    //!#---------------!
    //!----------------!
    movlw 0b10000000  ;Posicion DDRAM primer renglon columna 0
    call SetProps   
    movf num1, 0
    addlw 48	//Como el numero esta en decimal, se le debe sumar una constante
		//para que sea el mismo numero pero en ANSII
    
    call WriteLCD   //Limpian las siguientes dos posiciones (operador y num2)
    movlw 32
    call WriteLCD
    movlw 32
    call WriteLCD
		    //Posiciona el puntero a partir de donde esta el simbolo "="
		    //y limpia cualquier valor que esta en la segunda fila
    movlw 0b11000010 
    call SetProps   
    call clearLCD
    
    return
    
WriteLCD_2:
    //!n#--------------!
    //!----------------!
    movlw 0b10000001  ;Posicion DDRAM primer renglon columna 1
    call SetProps   
    movf operator, 0  //Mueve el valor del operador (ASCII) al LCD
    call WriteLCD
    		    //Posiciona el puntero a partir de donde esta el simbolo "="
		    //y limpia cualquier valor que esta en la segunda fila
    movlw 0b11000010 
    call SetProps   
    call clearLCD
    return
    
WriteLCD_3:
    //!nn#------------!
    //!----------------!
    movlw 0b10000010  ;Posicion DDRAM primer renglon columna 2
    call SetProps   
    movf num2, 0
    addlw 48	    //Como el numero esta en decimal, se le debe sumar una const
		    //para que sea el mismo numero pero en ANSII
    call WriteLCD
    		    //Posiciona el puntero a partir de donde esta el simbolo "="
		    //y limpia cualquier valor que esta en la segunda fila
		        //!nnn------------!
			//!--DDDDDDDDDDDD-!
    movlw 0b11000010  
    call SetProps   
    call clearLCD
    return
    
clearLCD:  // Limpia cualquier valor que esta en la segunda fila
    movlw 32
    call WriteLCD
    movlw 32
    call WriteLCD
    movlw 32
    call WriteLCD
    movlw 32
    call WriteLCD
    movlw 32
    call WriteLCD
    movlw 32
    call WriteLCD
    movlw 32
    call WriteLCD
    movlw 32
    call WriteLCD
    movlw 32
    call WriteLCD
    movlw 32
    call WriteLCD
    return
    
SetProps: // Se usa para configurar propiedades
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
									   //}**
						
//delay 
delay_800ms:
    movlw   50
    movwf   vara, 0
    movwf   varb, 0
loop:
    decfsz  varb,1,0
    goto    loop
    decfsz  vara,1,0
    goto    loop
    return

delay_20ms:
    movlw   20
    movwf   vara, 0
    movwf   varb, 0
loop2:
    decfsz  varb,1,0
    goto    loop
    decfsz  vara,1,0
    goto    loop2
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
 

