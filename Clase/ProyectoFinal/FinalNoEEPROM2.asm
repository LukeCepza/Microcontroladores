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
	#define Enter 0x04, 0 , A ; Es una excepción
	#define Terminate_game 0x04, 0 , A ; Es una excepción
; Registro asociado al Menu principal
	#define MainMenu 0x07, A
	#define RW_MM 0x07, 0, A;Are we in Main Menu
	#define RW_HS 0x07, 1, A ;Are we in HighScore
	#define RW_PLYN 0x07,2, A ;Are we Plain'
	#define RW_LOSIN 0x07,3,A ; if PLYN did we lose?
	#define RW_WINWIN 0x07, 4, A
	#define PLYN_SETUP 0x07, 5, A; Is the game setuped?
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
; Registros asociados al EEPROM
	;Asociados a 
	#define N1_STATUS 0x15, A
	#define NAME1_HS_1 0x16, A
	#define NAME1_HS_2 0x17, A
	#define NAME1_HS_3 0x18, A
	#define NAME2_HS_1 0x19, A
	#define NAME2_HS_2 0x1A, A
	#define NAME2_HS_3 0x1B, A
	#define NAME3_HS_1 0x1C, A
	#define NAME3_HS_2 0x1D, A
	#define NAME3_HS_3 0x1E, A
	#define SCR1 0x1F, A
	#define SCR2 0x20, A
	#define SCR3 0x21, A
	#define LIMA 0x22, A
 	#define LIMZ 0x23, A
	;Asociados a ultimo puntaje
	#define HIST1 0x22, A
	#define HIST2 0x23, A
	#define HIST3 0X24, A
; Registro asociado al Interrupcion
	#define CD_FLAG INTCON,2, A
	org 0x00
	
Setup	org 0x20 	
	call SetupAll
	call flagMM; cuando se llama StartMainMEnu se activa la bandera de blink en Start y la bandera de esrtamos en Main Menu
Update
	call MasterController ;Blink Main Menu 
	goto Update

MC:
MasterController
	clrf KeySTATUS
	call keypad_in
	call esp250ms
MM	btfsc RW_MM ; Estamos en el Main Menu
	call DispMM ; Si estamos ene l Menu principal, parpadea en la opcion que estamos tocando
PLYN	btfsc RW_PLYN ; Estamos en el menu de High Score
	goto LETSGAME ; Ir a blink
HS	btfsc RW_HS ; Estamos en el menu de High Score
	call DispHS ; Ir a blink
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
	clrf KeySTATUS
	bcf Enter
	call Off_RW_Flags
	bsf RW_MM
	bcf PLYN_SETUP
	call StartMainMenu
	return
flagWINWIN
	call Off_RW_Flags
	bsf RW_WINWIN
	bcf PLYN_SETUP
	return
Off_RW_Flags
	bcf RW_PLYN
	bcf RW_HS
	bcf RW_MM
	bcf RW_LOSIN
	bcf RW_WINWIN
	return
;##############################################################################
;############################# HIGH SCORE MENU ################################
DispHS:
    bsf EECON1, 0, A
    movlw 0x01 
    call MOV_EEADR
    movff EEDATA, NAME1_HS_1
    movlw 0x02 
    call MOV_EEADR
    movff EEDATA, NAME1_HS_2
    movlw 0x03 
    call MOV_EEADR
    movff EEDATA, NAME1_HS_3

    
    
    	MOVLW b'00000001' ; Clearing display
	call SetProps
	MOVLW b'10000000' ; setcursor
	call SetProps	
	MOVLW 'A' ; Write
	call WriteLCD
	MOVLW 'C' ; Write
	call WriteLCD
	MOVLW 'T' ; Write
	call WriteLCD
	MOVLW 'U' ; Write
	call WriteLCD
	MOVLW 'A' ; Write
	call WriteLCD
	MOVLW 'L'; Write
	call WriteLCD
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW 'C' ; Write
	call WriteLCD
	MOVLW 'A' ; Write
	call WriteLCD
	MOVLW 'M' ; Write
	call WriteLCD
	MOVLW 'P' ; Write
	call WriteLCD
	MOVLW 'E' ; Write
	call WriteLCD
	MOVLW 'O' ; Write
	call WriteLCD
	MOVLW 'N'; Write
	call WriteLCD
	MOVLW ':' ; Write
	call WriteLCD
	
	MOVLW b'11000111' ; setcursor
	call SetProps	
	MOVF NAME1_HS_1
	call WriteLCD
	MOVF NAME1_HS_2
	call WriteLCD
	MOVF NAME1_HS_3
	call WriteLCD
	
	call espera1s
	call espera1s 
	call espera1s 
	
	MOVLW b'00000001' ; Clearing display
	call SetProps
	MOVLW b'10000000' ; setcursor
	call SetProps	
	MOVLW 'U' ; Write
	call WriteLCD
	MOVLW 'L' ; Write
	call WriteLCD
	MOVLW 'T' ; Write
	call WriteLCD
	MOVLW 'I' ; Write
	call WriteLCD
	MOVLW 'M' ; Write
	call WriteLCD
	MOVLW 'O'; Write
	call WriteLCD
	MOVLW 'S' ; Write
	call WriteLCD
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW 'P' ; Write
	call WriteLCD
	MOVLW 'U' ; Write
	call WriteLCD
	MOVLW 'N' ; Write
	call WriteLCD
	MOVLW 'T' ; Write
	call WriteLCD
	MOVLW 'A'; Write
	call WriteLCD
	MOVLW 'J' ; Write
	call WriteLCD
	MOVLW 'E'; Write
	call WriteLCD
	MOVLW 'S' ; Write
	call WriteLCD
	
	MOVLW b'11000010' ; setcursor
	call SetProps	
	MOVLW '3' ; Write
	call WriteLCD
	MOVLW ','; Write
	call WriteLCD
	MOVLW '7' ; Write
	call WriteLCD
	MOVLW ','; Write
	call WriteLCD
	MOVLW '2' ; Write
	call WriteLCD
	call espera1s 
	call espera1s
	call espera1s 
	call WriteLCD
	call flagMM
	return
;############################# LETS_GAME ######################################
LETSGAME:
	call flagPLYN
	btfss PLYN_SETUP
	call SETUPGAME
	call MAINGAME
	return
	
SETUPGAME:
	call SeqGenesis
	clrf nvl1
	clrf nvl2
	bsf d1
	
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
	;THEN GENERATE SEQUENCE
genRNGsus 
	movf TMR1L, W,A
	movwf RNGsus
	goto SeqGenesis
	
SeqGenesis:

	movlw .0
	subwf RNGsus
	btfsc STATUS, Z, A 
	goto genRNGsus

	movlw .3
	mulwf 0x08, A
	movf PRODL, W,A
	call EvalRange
	movwf Seq1
	
	movlw .5
	mulwf 0x08, A
	movf PRODL, W,A
	call EvalRange
	movwf Seq2
	
	movlw .7
	mulwf 0x08, A
	movf PRODL, W,A
	call EvalRange
	movwf Seq3
	
	movlw .11
	mulwf 0x08, A
	movf PRODL, W,A
	call EvalRange
	movwf Seq4
	
	movlw .13
	mulwf 0x08, A
	movf PRODL, W,A
	call EvalRange
	movwf Seq5
	
	movlw .17
	mulwf 0x08, A
	movf PRODL, W,A
	call EvalRange
	movwf Seq6
	
	movlw .19
	mulwf 0x08, A
	movf PRODL, W,A
	call EvalRange
	movwf Seq7
	
	movlw .23
	mulwf 0x08, A
	movf PRODL, W,A
	call EvalRange
	movwf Seq8
	
	movlw .29
	mulwf 0x08, A 
	movf PRODL, W,A
	call EvalRange
	movwf Seq9
	
	movlw .31
	mulwf 0x08, A
	movf PRODL, W,A
	call EvalRange
	movwf Seq10
	
EvalRange
	bcf WREG, 7, A
	bcf WREG, 6, A
	bcf WREG, 5, A
	bcf WREG, 4, A
	bcf WREG, 4, A
	DCFSNZ WREG, W, A
	goto RAS1; movwf b'00000001'
	DCFSNZ WREG, W, A
	goto RAS2; movwf b'00000010'
	DCFSNZ WREG, W, A
	goto RAS3; movwf b'00000100'
	DCFSNZ WREG, W, A
	goto RAS4; movwf b'00001000'	
	DCFSNZ WREG, W, A
	goto RAS5; movwf b'00010000'
	DCFSNZ WREG, W, A
	goto RAS6; movwf b'00100000'
	DCFSNZ WREG, W, A
	goto RAS7; movwf b'01000000'
	DCFSNZ WREG, W, A
	goto RAS8; movwf b'10000000'
	goto RAS2
	
RAS1	movlw b'00000001'
	return
RAS2	movlw b'00000010'
	return
RAS3	movlw b'00000100'
	return
RAS4	movlw b'00001000'
	return
RAS5	movlw b'00010000'
	return
RAS6	movlw b'00100000'
	return
RAS7	movlw b'01000000'
	return
RAS8	movlw b'10000000'
	return

; #### Sequecia prueba
	;Nivel 1: lvl = '0000 0001'
InpSeq_T5 call COUNTDOWN  
InputSeqs call ClearKey
          call keypad_in
	  btfsc RW_LOSIN; # $$$$$$$$$$$$ PENDIENTE QUITAR
	  return ;PEEEEEEEENDIENDTE QUITAR ALV
	  btfsc CD_FLAG
	  goto TIME_OUT
	  btfss WKbP ; Was Keyboard pressed
	  goto InputSeqs
	  btfsc Enter
	  goto ABORT
	  return

COUNTDOWN: ;LO pone en tiempo para que dura 5s y activa las banderas y mascaras yeso
    MOVLW b'00000110'
    MOVWF T0CON, A
    MOVLW b'01100111'
    MOVWF TMR0H, A
    MOVLW b'01101010'
    MOVWF TMR0L
    BCF   CD_FLAG
    BSF   T0CON,7 ; Encender timer 0
    RETURN
TURN_OFF_CD:
    BCF CD_FLAG
    return

MAINGAME:
MainGame
	call espera500ms 
	call ShowSeqs
	call InpSeq_T5
	goto LVL1

RIGHTSEQ:
	call TURN_OFF_CD
	call OnGreen
	call espera500ms 
	call OffGR
	return
	
INPUTSEQ: ;
LVL1	movf Seq1, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call RIGHTSEQ
	btfss d2 
	goto lvlup ; TErmina llegando hasta main game
	call InpSeq_T5

LVL2	movf Seq2, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call RIGHTSEQ
	btfss d3
	goto lvlup
	call InpSeq_T5

LVL3	movf Seq3, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call RIGHTSEQ
	btfss d4
	goto lvlup
	call InpSeq_T5
	
LVL4	movf Seq4, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call RIGHTSEQ
	btfss d5 
	goto lvlup
	call InpSeq_T5

LVL5	movf Seq5, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call RIGHTSEQ
	btfss d6
	goto lvlup
	call InpSeq_T5

LVL6	movf Seq6, W
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call RIGHTSEQ
	btfss d7
	goto lvlup
	call InpSeq_T5

LVL7	movf Seq7
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call RIGHTSEQ
	btfss d8
	goto lvlup
	call InpSeq_T5

LVL8	movf Seq8
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call RIGHTSEQ
	btfss d9
	goto lvlup
	call InpSeq_T5

LVL9	movf Seq9
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call RIGHTSEQ
	btfss d10
	goto lvlup
	call InpSeq_T5

LVL10	movf Seq10
	subwf KeySTATUS, W
	btfss STATUS, Z, A
	goto GAMEOVER
	call RIGHTSEQ
	btfss d11
	goto lvlup ; ESte es el ultimo asi que va al final
	
lvlup	call DispFeliz
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
	btfss d7
	goto lvld7
	btfss d8
	goto lvld8
	btfss d9
	goto lvld9
	btfss d10
	goto lvld10
	btfss d11
	goto GGMan
	
lvld10	bsf d10
lvld9	bsf d9
lvld8	bsf d8
lvld7	bsf d7
lvld6	bsf d6
lvld5	bsf d5
lvld4	bsf d4
lvld3	bsf d3
lvld2	bsf d2
lvld1	bsf d1
	goto MainGame
	
ShowSeqs
Disp_seq1
	movf Seq1, W ; Mueve sequencia 1 a WREG
	call TurnLED ; 
	call espera1s
	call OffAll
	btfss d2 ;Checa si esta encendida la bandera del segundo nivel, sino regresa
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
	;SEQ=0010 0000
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
ABORT:
        call OffGR
	call OnRed
	call espera1s
	call OffGR
	MOVLW b'00000001' ; Clearing display
	call SetProps
	MOVLW b'11000001' ; setcursor
	call SetProps	
	MOVLW A'B'
	CALL  WriteLCD
	MOVLW A'Y'
	CALL  WriteLCD
	MOVLW A'E'
	CALL  WriteLCD
	MOVLW A' '
	CALL  WriteLCD
	MOVLW A'B'
	CALL  WriteLCD
	MOVLW A'Y'
	CALL  WriteLCD
	MOVLW A'E'
	CALL  WriteLCD
	call espera1s
	call espera1s
	call espera1s
	call espera1s
	call DGO

TIME_OUT:
    	call OffGR
	call OnRed
	call espera1s
	call OffGR
	MOVLW b'00000001' ; Clearing display
	call SetProps
	MOVLW b'11000001' ; setcursor
	call SetProps	
	MOVLW A'T'
	CALL  WriteLCD
	MOVLW A'I'
	CALL  WriteLCD
	MOVLW A'M'
	CALL  WriteLCD
	MOVLW A'E'
	CALL  WriteLCD
	MOVLW A'-'
	CALL  WriteLCD
	MOVLW A'O'
	CALL  WriteLCD
	MOVLW A'U'
	CALL  WriteLCD
	MOVLW A'T'
	CALL  WriteLCD
	MOVLW A'!'
	CALL  WriteLCD
	call espera1s
	call espera1s
	call espera1s
	call espera1s
	bcf Enter
	call DGO
    
GAMEOVER:
	call OffGR
	call OnRed
	call espera1s
	call OffGR
	
DGO	MOVLW b'00000001' ; Clearing display
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
	call espera1s
	call espera1s
	call flagMM
	return
	   
;############################ WIN WIN########################################
	
GGMan:
	MOVLW b'00000001' ; Clearing display
	call SetProps
	MOVLW b'10000001' ; setcursor
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
	call WriteLCD
	call DispFeliz
	
	call espera1s
	call espera1s
	
	MOVLW b'00000001' ; Clearing display
	call SetProps
	MOVLW b'10000001' ; setcursor
	call SetProps	
	MOVLW 'E' ; Write
	call WriteLCD
	MOVLW 'S' ; Write
	call WriteLCD
	MOVLW 'C' ; Write
	call WriteLCD
	MOVLW 'R' ; Write
	call WriteLCD
	MOVLW 'I' ; Write
	call WriteLCD
	MOVLW 'B' ; Write
	call WriteLCD
	MOVLW 'E' ; Write
	call WriteLCD
	MOVLW ' ' ; Write
	call WriteLCD
	MOVLW 'T' ; Write
	call WriteLCD
	MOVLW 'U' ; Write
	call WriteLCD 
	
	MOVLW b'11000000' ; setcursor
	call SetProps	
	MOVLW 'N' ; Write
	call WriteLCD
	MOVLW 'O' ; Write
	call WriteLCD
	MOVLW 'M' ; Write
	call WriteLCD
	MOVLW 'B' ; Write
	call WriteLCD
	MOVLW 'R' ; Write
	call WriteLCD
	MOVLW 'E' ; Write
	call WriteLCD
	MOVLW ':' ; Write
	call WriteLCD
	MOVLW ' ' ; Write
	call WriteLCD
;	#define N1_1 0x15, 0, A
;	#define N1_2 0x15, 0, A
;	#define N1_3 0x15, 0, A
	movlw 'A'
	movwf LIMA
	movwf NAME1_HS_1
	movwf NAME1_HS_2
	movwf NAME1_HS_3
	movlw 'Z'
	movwf LIMZ
	MOVLW b'00001110' ; setcursor
	call SetProps
	MOVLW b'0000110' ; setcursor
	call SetProps
	call SAVE_NAME_N1

SAVE_NAME_N1:
        MOVLW b'11001000' ; setcursor
	call SetProps
	call esp250ms
	clrf KeySTATUS
	call keypad_in
	btfsc Aricen
	incf 0x16, 1, 0
	btfsc Abacen
	decf 0x16, 1, 0	
	movf NAME1_HS_1
	call WriteLCD
	btfsc Centro
	goto SAVE_NAME_N2
	goto SAVE_NAME_N1
SAVE_NAME_N2:
        MOVLW b'11001001' ; setcursor
	call SetProps	
	call esp250ms
	clrf KeySTATUS
	call keypad_in
	btfsc Aricen
	incf 0x17, 1, 0
	btfsc Abacen
	decf 0x17, 1, 0
	movf NAME1_HS_2
	call WriteLCD
	btfsc Centro
	goto SAVE_NAME_N3
	goto SAVE_NAME_N2
SAVE_NAME_N3:
        MOVLW b'11001010' ; setcursor
	call SetProps	
	call esp250ms
	clrf KeySTATUS
	call keypad_in
	btfsc Aricen
	incf 0x18, 1, 0
	btfsc Abacen
	decf 0x18, 1, 0
	movf NAME1_HS_3
	call WriteLCD
	btfsc Centro
	goto SAVE_NAME
	goto SAVE_NAME_N3
	
SAVE_NAME:
    call flagMM
    goto Update
    
MOV_EEADR ; CALL
    movwf EEADR, A
    return
MOV_EEDATA ;  CALL
    movwf EEDATA, A
    return
WRITE_EEPROM ; CALL
    movlw b'00000100'
    movwf EECON1, A
    movlw 0x55
    movwf EECON2, A
    movlw 0xAA
    movwf EECON2, A
    bsf EECON1, WR, A ; Empieza a escribir
waitwrite
    btfsc EECON1, WR, A
    goto waitwrite
    return
    call flagMM
    goto Update
;############################# MAIN_MENU #######################################	

StartMainMenu:
;	bsf RW_MM
	bsf Blink_START
	bsf BlinkState
	MOVLW b'00000001' ; Clearing display
	call SetProps
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
;DELAY_5ms MOVLW .5 ; Delay of 5 ms
; MOVWF TMR0
; 
;LOOP BTFSS INTCON,2
; GOTO LOOP
; BCF INTCON,2
; RETURN
	
R1 EQU 0x32
R2 EQU 0x33
esp250ms nop
	nop
	nop
	nop
	movlw .8	;  1C
	movwf R1, A	;  1C
		        ; COU2 = .12 ... R1 = 256-7 = 248  
ret	nop		;  1C*R1
	movlw .6	;  1C*R1
	movwf R2, A	;  1C*R1		
		        ;  R2 = .14 ... R2 = 256-6 = 250
	incf R1,F,A	;  1C*R1
	btfsc STATUS,C,A;  2C*(R1-1) + 1C
	return		;  2C
reta	incf R2, F,A	;  1C*R2*R1
	btfss STATUS,C, A; 1C*R2*(R1-1) + 2*R1
	goto reta	;  2C*(R2-1)*R1
	goto ret	;  2C*R1
	
Delay1m 
	movlw .1
	movwf 0x32, A
intDel	incf 0x32,F,A
	btfss STATUS,2,A
	goto intDel
	return	
;############################# Setup_All #######################################	

SetupAll
	call START_T3
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
;Todos estos son para encder LED 1 LED 2 y así
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
	call esp250ms
	bsf WKbP
	call ClearKey
	bsf Ariizq
    return
D4	BTFSC PBRow_Izq
    	goto D4
	call esp250ms
	call OffGR
	bsf WKbP
	call ClearKey
	bsf Cenizq
    return
D7	BTFSC PBRow_Izq
	goto D7
	call esp250ms
	call OffGR
	bsf WKbP
	call ClearKey
	bsf Abaizq
    return
D2	BTFSC PBRow_Centro
	goto D2
	call esp250ms
	call OffGR
	bsf WKbP
	call ClearKey
	bsf Aricen
    return
D5	BTFSC PBRow_Centro
   	goto D5
	call esp250ms
	call OffGR
	bsf WKbP
	call ClearKey
        bsf Centro
    return
D8	BTFSC PBRow_Centro
	goto D8
	call esp250ms
	call OffGR
	bsf WKbP
	call ClearKey
	bsf Abacen
    return
D3	BTFSC PBRow_Der
   	goto D3	
	call esp250ms
	call OffGR
	bsf WKbP
	call ClearKey
	bsf Arider
    return
D6	BTFSC PBRow_Der
    	goto D6
	call esp250ms
	call OffGR
	bsf WKbP
	call ClearKey
	bsf Cender
    return
D9	BTFSS PBRow_Der
    	goto D9
	call esp250ms
	call OffGR
	bsf WKbP
	call ClearKey
	bsf Enter
  	movf TMR3L, W,A
	movwf RNGsus
	return
ClearKey
    clrf KeySTATUS
    bcf Enter
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
;	MOVLW b'11000000' ; setcursor
;	call SetProps
;	MOVLW d'0' 
;	call WriteLCD
;	call espera1s
;	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'1' 
	call WriteLCD
	call espera500ms
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'2' 
	call WriteLCD
	call espera500ms
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'3' 
	call WriteLCD
	call espera500ms
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'4' 
	call WriteLCD
	call espera500ms
    return	

DispTriste
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'5' 
	call WriteLCD
	call espera500ms
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'6' 
	call WriteLCD
	call espera500ms
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'7' 
	call WriteLCD
	call espera500ms
	
	MOVLW b'11000000' ; setcursor
	call SetProps
	MOVLW d'8' 
	call WriteLCD
	call espera500ms

START_T3
	; Retardo espera2 = 65536 CI o ms (4Mhz) con prescalador de 8 = 524288 CI o ms (4Mhz)
	; Queremos que sean 500000 CI es decir quitamos 24288 / 8 CI de TMR3
	; 3036 = b'0000 1011 1101 1100'
	; TMR3H = 0000 1011
	; TMR3L = 1101 1100
	; Con esto repetimos espera2 20 veces y sera suficiente para tener un retardo de 10s
	movlw b'00110010'
	movwf T3CON, A
	bcf T1GCON,7,A;
	movlw b'00001011' ;Si desborda, comenzar desde donde definimos
	movwf TMR3H, A
	movlw b'11011100'
	movwf TMR3L, A
	bcf PIR2,1 ,A    ;Bajar bandera de desboradamiento
	bsf T3CON, 0, A;
	return 
	
;	call espera10s
;	goto ending 
;espera10s movlw .21
;	movwf 0x01, A ; usamos registro 0x01 como contador para hacer 20 veces
;esp2m   movlw b'00001011' ;Si desborda, comenzar desde donde definimos
;	movwf TMR3H, A
;	movlw b'11011100'
;	movwf TMR3L, A
;	bcf PIR2,1 ,A    ;Bajar bandera de desboradamiento
;	bsf T3CON, 0, A;
;	decf 0x01
;	btfss STATUS, Z, A
;	goto esp2
;	return
;esp2	btfss PIR2, 1, A ; espera 500000 CI y 2 de return
;	goto esp2
;	goto esp2m
	
ending
	end
