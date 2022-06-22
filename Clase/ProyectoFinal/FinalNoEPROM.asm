#include "p18f45k50.inc"
	processor 18f45k50 	; (opcional)
; Registro asociado al LCD
	#define RS  LATE, 0, A ;RS 
	#define E   LATE, 2, A ;Estatus 
	#define RW  LATE, 1, A ;Comando E 
	#define dataLCD LATD, A ;Puerto del LCD 
; Registros asociados al Keyboard
	#define KeySTATUS 0x03, A
	;Teclas arriba
	#define Ariizq 0x03, 0 , A
	#define Aricen 0x03, 1 , A
	#define Arider 0x03, 2 , A
	;Teclas medias
	#define Cenizq 0x03, 3 , A
	#define Centro 0x03, 4 , A  
	#define Cender 0x03, 5 , A
	;Teclas Bajas
	#define Abaizq 0x03, 6 , A
	#define Abacen 0x03, 7 , A
	#define Abader 0x04, 0 , A ; Es una excepción
	#define WKbP 0x04, 1, A ; Was Keyboard Pressed
	;Teclas con multifuncion
	#define Enter 0x04,      0 , A ; Es una excepción
	#define Terminate_game 0x04, 0 , A ; Es una excepción
; Registro asociado al Menu principal
	#define MainMenu 0x07, A
	#define RW_MM 0x07, 0, A;Are we in Main Menu
	#define RW_HS 0x07, 1, A ;Are we in HighScore
	#define RW_PLYN 0x07,2, A ;Are we Plain'
	#define RW_LOSIN 0x07,3,A ; if PLYN did we lose?
	#define PLYN_SETUP 0x07, 4, A; Is the game setuped?
;Asociados a BLink_MM
	#define blink_wastoggled 0x06,4,A
	#define Blink_HS 0x06, 5, A; Is the blink in High Score
	#define Blink_START 0x06, 6 , A; Is the blink in Start
	#define BlinkState 0x06, 7 , A ; Esta el blink ON o OFF
; Registro asociado al RNGsus
	#define RNGsus 0x08, A
	#define FACTOR 0x15, A
CONTAR	EQU 0X17
SEQTEMP EQU 0X18
; Registros para orden Sequence
	#define Seq1 0x09, A
	#define Seq2 0x0A, A
	#define Seq3 0x0B, A
	#define Seq4 0x0C, A
	#define Seq5 0x0D, A
	#define Seq6 0x0E, A
	#define Seq7 0x0F, A
	#define Seq8 0x10, A
	#define Seq9 0x11, A
	#define Seq10 0x12, A
; Registro asociado al nivel en el que va el jugador
	#define nvl1 0x13, A
	#define d1 0x13, 0, A
	#define d2 0x13, 1, A
	#define d3 0x13, 2, A
	#define d4 0x13, 3, A
	#define d5 0x13, 4, A
	#define d6 0x13, 5, A
	#define d7 0x13, 6, A
	#define d8 0x13, 7, A
	#define nvl2 0x14, A
	#define d9 0x14, 0, A
	#define d10 0x14, 1, A
	#define d11 0x14, 2, A
	#define d12 0x14, 3, A
	#define d13 0x14, 4, A
	#define d14 0x14, 5, A
	#define d15 0x14, 6, A
	#define d16 0x14, 7, A
; Registros asociados al Keypad
	#define PBRow_Izq PORTB, 3
	#define PBRow_Centro PORTB, 4
	#define PBRow_Der PORTB, 5
	org 0x00
	
Setup	org 0x20 	
	call SetupAll
	call StartMainMenu ; cuando se llama StartMainMEnu se activa la bandera de blink en Start y la bandera de esrtamos en Main Menu
Update
	call MasterController ;Blink Main Menu 
	goto Update

MC:
MasterController
	call keypad_in
MM	btfsc RW_MM ; Estamos en el Main Menu
	call DispMM ; Si estamos ene l Menu principal, parpadea en la opcion que estamos tocando
HS	btfsc RW_HS ; Estamos en el menu de High Score
	call DispHS ; Ir a blink
PLYN	btfsc RW_PLYN ; Estamos en el menu de High Score
	goto LETSGAME ; Ir a blink
LOSIN	btfsc RW_LOSIN
	goto GAMEOVER
	return
RSTRTMR1:
rstTMR1	bcf PIR1, 0 ,A
	clrf TMR1L, A
	clrf TMR1H, A
	MOVLW b'10001111' ; setcursor
	call SetProps	
	return
CHECKWAI:
checkWAI_MM
	btfss Blink_START
	return
	btfss Abacen
	return
	call toggleblink
	return
checkWAI_HS
	btfss Blink_HS
	return
	btfss Aricen
	return
	call toggleblink
	return
toggleblink
	btg Blink_HS
	btg Blink_START
	bsf blink_wastoggled
	return

DispHS
	nop 
	nop
	return
;############################# BLINKERS #######################################
DispMM: 
	call checkWAI_MM
	call checkWAI_HS ; EStas dos lineas revisan si se presiono la tecla de abajo o arriba dependiendo de cual opcion esta blink y desplazan el blink
	btfss Blink_START ; Esta el blink en Start?
	goto HS_blink ; Ir a BlinkHighScore
	goto Start_blink ;Ir a BlinkStart
;#############################UPDATE BLINK START
UPDATEBLINKSTART:
Start_blink
	btfsc Enter ; Si fue presionado enter, ir a START
	call flagPLYN ;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& CHANGE TO MASTERCONTROLLER
	btfsc blink_wastoggled
	call StartFirstBlink
	btfsc PIR1, 0, A ; espera 524288 CI + 2CI del bcf PIR1 y 2 de return si ya estuvo blink encendido mas de 500ms
	call Start_Update_blink
	return
Start_Update_blink
	call OffBlink
	btfss BlinkState
	goto StartblinkON
	goto StartblinkOFF
StartblinkON
	bsf BlinkState
	MOVLW b'10000000' ; setcursor
	call SetProps	
	MOVLW '>' ; Write
	call WriteLCD
	MOVLW b'10000110' ; setcursor
	call SetProps	
	MOVLW '<' ; Write
	call WriteLCD
	call rstTMR1
	return
StartblinkOFF
	bcf BlinkState
	MOVLW b'10000000' ; setcursor
	call SetProps	
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW b'10000110' ; setcursor
	call SetProps	
	MOVLW ' ' ; Write
	call WriteLCD
	call rstTMR1
	return
;#############################UPDATE BLINK HS
UPDATEHSBLINK:
HS_blink
	btfsc Enter ; Si fue presionado enter, ir a START
	call flagHS
	btfsc blink_wastoggled
	call HSFirstBlink
	btfsc PIR1, 0, A ; espera 524288 CI + 2CI del bcf PIR1 y 2 de return si ya estuvo blink encendido mas de 500ms
	call HS_Update_blink
	return
HS_Update_blink
	call OffBlink
	btfss BlinkState
	goto HSblinkON
	goto HSblinkOFF
HSblinkON
	bsf BlinkState
	MOVLW b'11000000' ; setcursor
	call SetProps	
	MOVLW '>' ; Write
	call WriteLCD
	MOVLW b'11001100' ; setcursor
	call SetProps	
	MOVLW '<' ; Write
	call WriteLCD
	call rstTMR1
	return
HSblinkOFF
	bcf BlinkState
	MOVLW b'11000000' ; setcursor
	call SetProps	
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW b'11001100' ; setcursor
	call SetProps	
	MOVLW ' ' ; Write
	call WriteLCD
	call rstTMR1
	return
;#############################FIRST BLINKERS BOTH START AND HS
FIRSTBLINKERS:
StartFirstBlink
	call OffBlink
	bsf BlinkState
	call rstTMR1
	MOVLW b'10000000' ; setcursor
	call SetProps	
	MOVLW '>' ; Write
	call WriteLCD
	MOVLW b'10000110' ; setcursor
	call SetProps	
	MOVLW '<' ; Write
	call WriteLCD
	bcf blink_wastoggled
	return
HSFirstBlink
	call OffBlink
	bsf BlinkState
	call rstTMR1
	MOVLW b'11000000' ; setcursor
	call SetProps	
	MOVLW '>' ; Write
	call WriteLCD
	MOVLW b'11001100' ; setcursor
	call SetProps	
	MOVLW '<' ; Write
	call WriteLCD
	bcf blink_wastoggled
	return
OffBlink
	MOVLW b'10000000' ; setcursor
	call SetProps	
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW b'10000110' ; setcursor
	call SetProps	
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW b'11000000' ; setcursor
	call SetProps	
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW b'11001100' ; setcursor
	call SetProps	
	MOVLW ' ' ; Write
	call WriteLCD
	return
	
;############################# Switch FLAGS ###################################
RW_FLAGS_SWITCHER:
flagPLYN
	call Off_RW_Flags
	bsf RW_PLYN
	return
flagHS
	call Off_RW_Flags
	bsf RW_HS
	bcf PLYN_SETUP
	return
flagLosin
	call Off_RW_Flags
	bsf RW_LOSIN
	bcf PLYN_SETUP
	return
flagMM
	call Off_RW_Flags
	bsf RW_MM
	bcf PLYN_SETUP
	return
Off_RW_Flags
	bcf RW_PLYN
	bcf RW_HS
	bcf RW_MM
	bcf RW_LOSIN
	return
;##############################################################################
	
;############################# LETS_GAME ######################################
LETSGAME:
	call flagPLYN
	btfss PLYN_SETUP
	call SETUPGAME
	goto MAINGAME
SETUPGAME:
	;THEN GENERATE SEQUENCE
SEQGENESIS
	MOVLW .1
	MOVWF CONTAR
LOOP
	CALL SECUENCIA 
	CALL GUARDAR
	INCF CONTAR,F,A
	MOVF CONTAR,W,A
	SUBLW 10
	BTFSS STATUS, 2
	    goto LOOP
		    ;TERMINAN LAS 10 SECUENCIAS

	;DISP PLAYING
	MOVLW b'00000001' ; Clearing display
	call SetProps
	MOVLW b'10000001' ; setcursor
	call SetProps	
	MOVLW 'P' ; Write
	call WriteLCD
	MOVLW 'L' ; Write
	call WriteLCD
	MOVLW 'A' ; Write
	call WriteLCD
	MOVLW 'Y' ; Write
	call WriteLCD
	MOVLW 'I' ; Write
	call WriteLCD
	MOVLW 'N' ; Write
	call WriteLCD
	MOVLW 'G' ; Write
	call WriteLCD
	bsf PLYN_SETUP
	return
	    
GUARDAR 
EV3  BTFSS CONTAR, 3
	GOTO REVISAR2
EV1	BTFSS CONTAR, 1
	GOTO REVISAR0
	GOTO SET10
	
REVISAR0
	    BTFSS CONTAR,0
	    GOTO SET8
	    GOTO SET9
REVISAR2
	    BTFSS CONTAR,2
	    GOTO SUBREV1
		BTFSS CONTAR,1
		GOTO SUBREV0
		    BTFSS CONTAR, 0
		    GOTO SET6
		    GOTO SET7
SUBREV0
	BTFSS CONTAR,0
	    GOTO SET4
	    GOTO SET5
SUBREV1
	BTFSS CONTAR,1
	    GOTO SET1
	    BTFSS CONTAR, 0 
	    GOTO SET2
	    GOTO SET3
SET1
    MOVF SEQTEMP
    MOVWF Seq1
    RETURN
SET2
    MOVF SEQTEMP
    MOVWF Seq2
    RETURN
SET3
    MOVF SEQTEMP
    MOVWF Seq3
    RETURN
SET4
    MOVF SEQTEMP
    MOVWF Seq4
    RETURN
SET5
    MOVF SEQTEMP
    MOVWF Seq5
    RETURN
SET6
    MOVF SEQTEMP
    MOVWF Seq6
    RETURN
SET7
    MOVF SEQTEMP
    MOVWF Seq7
    RETURN
SET8
    MOVF SEQTEMP
    MOVWF Seq8
    RETURN
SET9
    MOVF SEQTEMP
    MOVWF Seq9
    RETURN
SET10
    MOVF SEQTEMP
    MOVWF Seq10
    RETURN 
    
SECUENCIA 
    MOVLW TMR1L
    SUBWF TMR1H,W, A
    MOVWF RNGsus
    MOVLW .4
    MOVWF FACTOR
    MOVF RNGsus
    MULWF FACTOR
    MOVF PRODL,W,A
    SUBLW .256
    
EVALUAR
    BTFSS STATUS, 2     ;REVISA SI LA RESTA ES CERO
	 GOTO EV_RANGO  ;EVALÚA EN QUÉ RANGO ESTÁ EL NÚMERO       
	CALL RANGO9	;PRENDER LED9 

EV_RANGO
EV7  BTFSS WREG, 7
	GOTO REVISAR6
EV6	BTFSS WREG, 6
	GOTO REVISAR5
EV5 BTFSS WREG,5
	    GOTO RANGO2
	    GOTO RANGO1
REVISAR5
	    BTFSS WREG,5
	    GOTO RANGO4
	    GOTO RANGO3
REVISAR6
	    BTFSS WREG,6
	    GOTO SUBREV5
		BTFSS WREG,5
		GOTO RANGO6
		GOTO RANGO5

SUBREV5
	BTFSS WREG,5
	    GOTO RANGO8
	    GOTO RANGO7	

RANGO1
    MOVLW b'00000001'
    MOVWF SEQTEMP, A
    ;MOVWF LATA, A 
    ;MOVFF LATA, SEQTEMP
    RETURN
RANGO2
    MOVLW b'00000010'
    MOVWF SEQTEMP, A
    ;MOVWF LATA, A 
    ;MOVFF LATA, SEQTEMP
    RETURN
RANGO3
    MOVLW b'00000100'
    MOVWF SEQTEMP, A

;    MOVWF LATA, A 
;    MOVFF LATA, SEQTEMP
    RETURN
RANGO4
    MOVLW b'00001000'
    MOVWF SEQTEMP, A

;    MOVWF LATA, A 
;    MOVFF LATA, SEQTEMP
    RETURN
RANGO5
    MOVLW b'00010000'
    MOVWF SEQTEMP, A
;    MOVWF LATA, A 
;    MOVFF LATA, SEQTEMP
    RETURN
RANGO6
    MOVLW b'00100000'
    MOVWF SEQTEMP, A
;    MOVWF LATA, A 
;    MOVFF LATA, SEQTEMP
    RETURN
RANGO7
    MOVLW b'01000000'
    MOVWF SEQTEMP, A
;    MOVWF LATA, A 
;    MOVFF LATA, SEQTEMP
    RETURN
RANGO8
    MOVLW b'10000000'
    MOVWF SEQTEMP, A
;    MOVWF LATA, A 
;    MOVFF LATA, SEQTEMP
    RETURN
RANGO9
    MOVLW b'00000100'
    MOVWF SEQTEMP, A
;    MOVWF LATA, A 
;    MOVFF LATA, SEQTEMP
    RETURN

; #### Sequencia prueba
	;Nivel 1: lvl = '0000 0001'
MAINGAME:
MainGame
	call espera500ms
	call ShowSeqs	
	call InputSeqs
	goto LVL1
INPUTSEQ:
LVL1
	movf Seq1, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call OnGreen
	call espera500ms
	call OffGR
	btfss d2 
	goto lvlup
	call InputSeqs
LVL2
	movf Seq2, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call OnGreen
	call espera500ms
	call OffGR
	btfss d3
	goto lvlup
	call InputSeqs
LVL3	
	movf Seq3, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call OnGreen
	call espera500ms
	call OffGR
	btfss d4
	goto lvlup
	call InputSeqs
LVL4
	movf Seq4, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call OnGreen
	call espera500ms
	call OffGR
	btfss d5 
	goto lvlup
	call InputSeqs
LVL5	
	movf Seq5, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call OnGreen
	call espera500ms
	call OffGR
	btfss d6
	goto lvlup
	call InputSeqs
LVL6
	movf Seq6, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call OnGreen
	call espera500ms
	call OffGR
	btfss d7
	goto lvlup
	call InputSeqs
LVL7
	movf Seq7
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call OnGreen
	call espera500ms
	call OffGR
	btfss d8
	goto lvlup
	call InputSeqs
LVL8	
	movf Seq8
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call OnGreen
	call espera500ms
	call OffGR
	btfss d9
	goto lvlup
	call InputSeqs
LVL9	
	movf Seq9
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call OnGreen
	call espera500ms
	call OffGR
	btfss d10
	goto lvlup
	call InputSeqs
LVL10	
	movf Seq10
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call OnGreen
	call espera500ms
	call OffGR
	btfss d11
	goto lvlup
	call InputSeqs
	
InputSeqs call keypad_in
	  btfss WKbP ; Was Keyboard pressed
	  goto InputSeqs
	  return
	
lvlup
	btfss d1
	goto lvld1
	btfss d2
	goto lvld2
	btfss d3
	goto lvld3
	btfss d4
	goto lvld4
	btfss d5
	goto lvld5
	btfss d6
	goto lvld6
	btfss d3
	goto lvld7
	btfss d4
	goto lvld8
	btfss d5
	goto lvld9
	btfss d6
	goto lvld10
	btfss d10
	goto GGMan
	
lvld10
	bsf d10
lvld9
	bsf d9
lvld8
	bsf d8
lvld7
	bsf d7
lvld6
	bsf d6
lvld5
	bsf d5
lvld4
	bsf d4
lvld3
	bsf d3
lvld2
	bsf d2
lvld1
	bsf d1
	goto MainGame
	
ShowSeqs
Disp_seq1
	movf Seq1, W
	call TurnLED
	call espera1s
	call OffAll
	btfss d2
	return
Disp_seq2
	movf Seq2, W
	call TurnLED
	call espera1s
	call OffAll
	btfss d3
	return
Disp_seq3
	movf Seq3, W
	call TurnLED
	call espera1s
	call OffAll
	btfss d4
	return
Disp_seq4
	movf Seq4, W
	call TurnLED
	call espera1s
	call OffAll
	btfss d5
	return
Disp_seq5
	movf Seq5, W
	call TurnLED
	call espera1s
	call OffAll
	btfss d6
	return
Disp_seq6
	movf Seq6, W
	call TurnLED
	call espera1s
	call OffAll
	btfss d7
	return
Disp_seq7
	movf Seq7, W
	call TurnLED
	call espera1s
	call OffAll
	btfss d8
	return
Disp_seq8
	movf Seq8, W
	call TurnLED
	call espera1s
	call OffAll
	btfss d9
	return
Disp_seq9
	movf Seq9, W
	call TurnLED
	call espera1s
	call OffAll
	btfss d10
	return
Disp_seq10
	movf Seq10,W
	call TurnLED
	call espera1s
	call OffAll
	btfss d11
	return
	
TurnLED	btfsc WREG, 0, A
	goto On1
	btfsc WREG, 1, A
	goto On2
	btfsc WREG, 2, A
	goto On3
	btfsc WREG, 3, A
	goto On4
	btfsc WREG, 4, A
	goto On5
	btfsc WREG, 5, A
	goto On6
	btfsc WREG, 6, A
	goto On7
	btfsc WREG, 7, A
	goto On8
	btfsc WREG, 7, A
	goto On9
	return
	
;############################# Resolutions #######################################	
GAMEOVER:
	call flagLosin
	call OffGR
	call OnRed
	call espera1s
	call OffGR
	
	MOVLW b'00000001' ; Clearing display
	call SetProps
	MOVLW b'11000001' ; setcursor
	call SetProps	
	MOVLW 'G' ; Write
	call WriteLCD
	MOVLW 'A' ; Write
	call WriteLCD
	MOVLW 'M' ; Write
	call WriteLCD
	MOVLW 'E' ; Write
	call WriteLCD
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW 'O' ; Write
	call WriteLCD
	MOVLW 'V' ; Write
	call WriteLCD
	MOVLW 'E' ; Write
	call WriteLCD
	MOVLW 'R' ; Write
	call WriteLCD	
	call DispTriste
	
	btfsc Enter
	call StartMainMenu
	goto Update
	
GGMan
	MOVLW b'00000001' ; Clearing display
	call SetProps
	MOVLW b'11000001' ; setcursor
	call SetProps	
	MOVLW 'W' ; Write
	call WriteLCD
	MOVLW 'I' ; Write
	call WriteLCD
	MOVLW 'N' ; Write
	call WriteLCD
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW 'W' ; Write
	call WriteLCD
	MOVLW 'I' ; Write
	call WriteLCD
	MOVLW 'N' ; Write
	call WriteLCD
	MOVLW '!' ; Write
	call WriteLCD
	MOVLW '!' ; Write
	call DispFeliz
	goto Update
;############################# MAIN_MENU #######################################	

StartMainMenu
	call flagMM
;	bsf RW_MM
	bsf Blink_START
	bsf BlinkState
Pstart	MOVLW b'10000000' ; setcursor
	call SetProps
	MOVLW '>' ; Write
	call WriteLCD
	MOVLW 'S' ; Write
	call WriteLCD
	MOVLW 'T' ; Write
	call WriteLCD
	MOVLW 'A' ; Write
	call WriteLCD
	MOVLW 'R' ; Write
	call WriteLCD
	MOVLW 'T' ; Write
	call WriteLCD
	MOVLW '<' ; Write
	call WriteLCD
	call rstTMR1

	
PHS	MOVLW b'11000001' ; setcursor
	call SetProps
	MOVLW 'H' ; Write
	call WriteLCD
	MOVLW 'I' ; Write
	call WriteLCD
	MOVLW 'G' ; Write
	call WriteLCD
	MOVLW 'H' ; Write
	call WriteLCD
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW 'S' ; Write
	call WriteLCD
	MOVLW 'C' ; Write
	call WriteLCD
	MOVLW 'O' ; Write
	call WriteLCD
	MOVLW 'R' ; Write
	call WriteLCD
	MOVLW 'E' ; Write
	call WriteLCD
	MOVLW 'S' ; Write
	call WriteLCD
    return
	
SetProps
	bcf RS ;RS=0
	bcf RW ;RW=0
	goto Enable
WriteLCD
	bsf RS ;RS=1
	bcf RW ;RW=0
Enable	bsf E ;Enabled = 1
	MOVWF dataLCD 
	nop
	bcf E ;Enabled = 0
	call Delay1m
	return

Delay1m 
	movlw .1
	movwf 0x32, A
intDel	incf 0x32,F,A
	btfss STATUS,2,A
	goto intDel
	return	
;############################# Setup_All #######################################	

SetupAll
ConfLCD 
	movlb	d'15' ;Selectlastbank(SFRs)
	clrf	ANSELE, BANKED ;Forces digital I/O
	clrf	TRISE, A  
	clrf	ANSELD, BANKED
	clrf	TRISD,A
ConfButton
	CLRF    ANSELB,BANKED
	MOVLW   B'00111000'  ;A0-A2 Output; A3-A6 Input
	MOVWF   TRISB ;A0-A2 Output; A3-A6 Input
	BCF	INTCON2,7
	MOVWF   WPUB  ; Activar pull-up resistor
ConfLED_Mat_GR
	movlb   .15 ;configuración revisar botones
	CLRF    ANSELA,BANKED
	CLRF   TRISA, A ;A0-A7 Output
	Call OffAll
	CLRF ANSELC, BANKED
	CLRF TRISC, A
Conf_LCDproperties 
	call WriteCGRAM
	MOVLW b'00111000' ; escritura en dos líneas: DL = 8bit; N = 2 lines; F= 5x7
	call SetProps
	MOVLW b'00001100' ; Encender Display, sin cursor activo: D = 1; C = 0;B =0
	call SetProps
	MOVLW b'00000110' ; Configurar desplazamiento incremental: I/D = 1
	call SetProps
	MOVLW b'00000001' ; Clearing display
	call SetProps
Conf_TMR1
	movlw b'00110010'
	movwf T1CON, A
	clrf TMR1L, A
	clrf TMR1H, A
	bcf T1GCON,7,A;
	bsf T1CON, 0, A;
	return
;######################### LEDS
OnRed	bcf LATC, 1, A
	bsf LATC, 0, A
	return
OnGreen bsf LATC, 1, A
	bcf LATC, 0, A
	return 
OffGR   bcf LATC, 1, A
	bcf LATC, 0, A
	return
	return 
On1	movlw b'00001110'
	movwf LATA, A
	return
On2	movlw b'00010110'
	movwf LATA, A
	return	
On3	movlw b'00100110'
	movwf LATA, A
	return
On4	movlw b'00001101'
	movwf LATA, A 
	return
On5	movlw b'00010101'
	movwf LATA, A
	return
On6	movlw b'00100101'
	movwf LATA, A
	return
On7	movlw b'00001011'
	movwf LATA, A
	return
On8	movlw b'00010011'
	movwf LATA, A
	return
On9     movlw b'00100011'
	movwf LATA, A
	return
OffAll
	Movlw b'00000111' ; A543 , A210
	movwf LATA, A
	return
OnAll
	movlw b'00111000'
	movwf LATA, A
	return
;######################### KEYPAD #####################################
keypad_in
	bcf WKbP
Rol1	MOVLW   b'11111110' ;RA0 COLUMNA RB3,RB4,RB5 Valores 0,1,2,3,4
	MOVWF   LATB
	BTFSS   PBRow_Izq
	GOTO    D7
	BTFSS   PBRow_Centro
	GOTO    D8
	BTFSS   PBRow_Der
	GOTO    D9

Rol2	MOVLW   b'11111101' ;RA1 COLUMNA RB3,RB4,RB5 Valores 0,1,2,3,4
	MOVWF   LATB
	BTFSS   PBRow_Izq
	GOTO    D4
	BTFSS   PBRow_Centro
	GOTO    D5
	BTFSS   PBRow_Der
	GOTO    D6

Rol3	MOVLW   b'11111011' ;RA2 COLUMNA RB3,RB4,RB5 Valores 0,1,2,3,4
	MOVWF   LATB
	BTFSS   PBRow_Izq
	GOTO    D1
	BTFSS   PBRow_Centro
	GOTO    D2
	BTFSS   PBRow_Der
	GOTO    D3
	return
	
D1	BTFSC PBRow_Izq
	goto D1
	call espera500ms
	bsf WKbP
    	clrf KeySTATUS
	bcf Enter
	bsf Ariizq
    return
D4	BTFSC PBRow_Izq
    	goto D4
	call espera500ms
	call OffGR
	bsf WKbP
    	clrf KeySTATUS
	bcf  Enter
	bsf Cenizq
    return
D7	BTFSC PBRow_Izq
	goto D7
	call espera500ms
	call OffGR
	bsf WKbP
	clrf KeySTATUS
	bcf Enter
	bsf Abaizq
    return
D2	BTFSC PBRow_Centro
	goto D2
	call espera500ms
	call OffGR
	bsf WKbP
	clrf KeySTATUS
	bcf Enter
	bsf Aricen
    return
D5	BTFSC PBRow_Centro
   	goto D5
	call espera500ms
	call OffGR
	bsf WKbP
   	clrf KeySTATUS
	bcf Enter
        bsf Centro
    return
D8	BTFSC PBRow_Centro
	goto D8
	call espera500ms
	call OffGR
	bsf WKbP
    	clrf KeySTATUS
	bcf Enter
	bsf Abacen
    return
D3	BTFSC PBRow_Der
   	goto D3	
	call espera500ms
	call OffGR
	bsf WKbP
    	clrf KeySTATUS
	bcf Enter
	bsf Arider
    return
D6	BTFSC PBRow_Der
    	goto D6
	call espera500ms
	call OffGR
	bsf WKbP
	clrf KeySTATUS
	bcf Enter
	bsf Cender
    return
D9	BTFSS PBRow_Der
    	goto D9
	call espera500ms
	call OffGR
	bsf WKbP
	clrf KeySTATUS
	bcf Enter
	bsf Enter
    return

espera500ms
	clrf TMR1L, A
	clrf TMR1H, A
	bcf PIR1, 0 ,A
	call espera
	return
espera1s
	clrf TMR1L, A
	clrf TMR1H, A
	bcf PIR1, 0 ,A
	call espera
	call espera
	return
espera btfss PIR1, 0, A ; espera 524288 CI + 2CI del bcf PIR1 y 2 de return
	goto espera
	bcf PIR1, 0 ,A
	return
	
WriteCGRAM
smile1
	MOVLW b'01000000' ; go to CGRAM
	call SetProps
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD	
	MOVLW b'10001010' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10001110' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	
smile2
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD	
	MOVLW b'10001010' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10011111' ; CArita feliz
	call WriteLCD
	MOVLW b'10001110' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	
smile3
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD	
	MOVLW b'10001010' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10010001' ; CArita feliz
	call WriteLCD
	MOVLW b'10010001' ; CArita feliz
	call WriteLCD
	MOVLW b'10001110' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD

smile4
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD	
	MOVLW b'10001010' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10011111' ; CArita feliz
	call WriteLCD
	MOVLW b'10010001' ; CArita feliz
	call WriteLCD
	MOVLW b'10001110' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	
smile5
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD	
	MOVLW b'10001010' ; CArita feliz
	call WriteLCD
	MOVLW b'10001010' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
	MOVLW b'10011111' ; CArita feliz
	call WriteLCD
	MOVLW b'10010001' ; CArita feliz
	call WriteLCD
	MOVLW b'10001110' ; CArita feliz
	call WriteLCD
	MOVLW b'10000000' ; CArita feliz
	call WriteLCD
sad1
	MOVLW b'10000000' ; Carita triste
	call WriteLCD	
	MOVLW b'10001010' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	MOVLW b'10001110' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	
sad2
	MOVLW b'10000000' ; Carita triste
	call WriteLCD	
	MOVLW b'10001010' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	MOVLW b'10001110' ; Carita triste
	call WriteLCD
	MOVLW b'10010001' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	
sad3
	MOVLW b'10000000' ; Carita triste
	call WriteLCD	
	MOVLW b'10001010' ; Carita triste
	call WriteLCD
	MOVLW b'10001010' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	MOVLW b'10001110' ; Carita triste
	call WriteLCD
	MOVLW b'10010001' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	
sad4
	MOVLW b'10000000' ; Carita triste
	call WriteLCD	
	MOVLW b'10001010' ; Carita triste
	call WriteLCD
	MOVLW b'10001010' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	MOVLW b'10001110' ; Carita triste
	call WriteLCD
	MOVLW b'10010001' ; Carita triste
	call WriteLCD
	MOVLW b'10010001' ; Carita triste
	call WriteLCD
	MOVLW b'10000000' ; Carita triste
	call WriteLCD
	    
    return
	
DispFeliz
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'0' 
	call WriteLCD
	call espera1s
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'1' 
	call WriteLCD
	call espera1s
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'2' 
	call WriteLCD
	call espera1s
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'3' 
	call WriteLCD
	call espera1s
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'4' 
	call WriteLCD
	call espera1s
    return	

DispTriste
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'5' 
	call WriteLCD
	call espera1s
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'6' 
	call WriteLCD
	call espera1s
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'7' 
	call WriteLCD
	call espera1s
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'8' 
	call WriteLCD
	call espera1s

ending
	end