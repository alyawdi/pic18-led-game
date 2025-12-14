; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

#include "p18f4550.inc"

 ; CONFIG1L
   config CPUDIV = OSC1_PLL2  
 ; CONFIG1H
   config FOSC = HS     ; Oscillator Selection bits->HS oscillator
   config FCMEN = OFF     ; Fail-Safe Clock Monitor Enable bit->Fail-Safe Clock Monitor disabled
   config IESO = OFF     ; Internal/External Oscillator Switchover bit->Oscillator Switchover mode disabled

 ; CONFIG2L
   config PWRT = OFF     ; Power-up Timer Enable bit->PWRT disabled
   config BOR = OFF     ; Brown-out Reset Enable bits->Brown-out Reset enabled in hardware only (SBOREN is disabled)
   config BORV = 2     ; Brown Out Reset Voltage bits->VBOR set to 1.8 V nominal

 ; CONFIG2H
   config WDT = OFF     ; Watchdog Timer Enable bit->WDT is controlled by SWDTEN bit of the WDTCON register
   config WDTPS = 2048     ; Watchdog Timer Postscale Select bits->1:2048

 ; CONFIG3H
   config PBADEN = ON     ; PORTB A/D Enable bit->PORTB<4:0> pins are configured as analog input channels on Reset
   config LPT1OSC = OFF     ; Low-Power Timer1 Oscillator Enable bit->Timer1 configured for higher power operation
   config MCLRE = ON     ; MCLR Pin Enable bit->MCLR pin enabled; RE3 input pin disabled

 ; CONFIG4L
   config STVREN = ON     ; Stack Full/Underflow Reset Enable bit->Stack full/underflow will cause Reset
   config LVP = OFF     ; Single-Supply ICSP Enable bit->Single-Supply ICSP disabled
   config XINST = OFF     ; Extended Instruction Set Enable bit->Instruction set extension and Indexed Addressing mode disabled (Legacy mode)
   config DEBUG = OFF     ; Background Debugger Enable bit->Background debugger disabled, RB6 and RB7 configured as general purpose I/O pins

 ; CONFIG5L
   config CP0 = OFF     ; Code Protection Block 0->Block 0 (000200-000FFFh) not code-protected
   config CP1 = OFF     ; Code Protection Block 1->Block 1 (001000-001FFFh) not code-protected

 ; CONFIG5H
   config CPB = OFF     ; Boot Block Code Protection bit->Boot block (000000-0001FFh) not code-protected
   config CPD = OFF     ; Data EEPROM Code Protection bit->Data EEPROM not code-protected

 ; CONFIG6L
   config WRT0 = OFF     ; Write Protection Block 0->Block 0 (000200-000FFFh) not write-protected
   config WRT1 = OFF     ; Write Protection Block 1->Block 1 (001000-001FFFh) not write-protected

 ; CONFIG6H
   config WRTC = OFF     ; Configuration Register Write Protection bit->Configuration registers (300000-3000FFh) not write-protected
   config WRTB = OFF     ; Boot Block Write Protection bit->Boot Block (000000-0001FFh) not write-protected
   config WRTD = OFF     ; Data EEPROM Write Protection bit->Data EEPROM not write-protected

 ; CONFIG7L
   config EBTR0 = OFF     ; Table Read Protection Block 0->Block 0 (000200-000FFFh) not protected from table reads executed in other blocks
   config EBTR1 = OFF     ; Table Read Protection Block 1->Block 1 (001000-001FFFh) not protected from table reads executed in other blocks

 ; CONFIG7H
    config EBTRB = OFF     ; Boot Block Table Read Protection bit->Boot Block (000000-0001FFh) not protected from table reads executed in other blocks

    ;DELAY VARIABLES 
    
    MAIN_DELAY_VARIABLE EQU d'18'
    MAIN_DELAY EQU 0X12
    VAR1 EQU 0X15
    COUNTER EQU 0X16
 MAIN_DELAY2 EQU 0X54
 
    SOUL_COUNTER EQU 0X20
    org 0x0000
    ;make the leds ouput
    BANKSEL TRISB
    MOVLW 0x00
    MOVWF TRISB
    MOVLW 0x00
    MOVWF TRISD
    
 
    

    ;MAIN CODE
	MOVLW B'00000001'
	MOVWF VAR1
	MOVLW D'4'
	MOVWF SOUL_COUNTER
	MOVLW 0Fh ; Configure A/D
	MOVWF ADCON1 ; for digital inputs
	MOVLW MAIN_DELAY_VARIABLE;the number placed here is the time of delation at default (1) it is 100ms 
        MOVWF MAIN_DELAY
	
		
MAIN_LOOP	CALL COUNTER_RESET
LOOP1		CALL SHIFTING_LEFT 
		BNZ LOOP1
		CALL COUNTER_RESET
LOOP2		CALL SHIFTING_RIGHT
		BNZ LOOP2
;		CALL SOULS
		BZ MAIN_LOOP
		
	SOULS 
	DCFSNZ SOUL_COUNTER,F
	GOTO GAMEOVER
	RETURN
	
	GAMEOVER  ;
	MOVLW 0XAA
	MOVWF VAR1 
MISLOOP COMF VAR1,F
	CALL DISPLAY;
	CALL DELAY2;
	GOTO MISLOOP
		
		

    COUNTER_RESET
    MOVLW D'7'
    MOVWF COUNTER
    RETURN
		
    SHIFTING_LEFT
    CALL DELAY2
    CALL DISPLAY
    CALL TEST
    RLNCF VAR1,F
    DECF COUNTER,F

    RETURN
    
    
    SHIFTING_RIGHT 
    CALL DELAY2
    CALL DISPLAY
    CALL TEST
    RRNCF VAR1,F
    DECF COUNTER,F
    RETURN
    
    
	DELAY2;DELAY WHEN PRESSING
	MOVFF MAIN_DELAY,MAIN_DELAY2
LOOP	CALL DELAY
	DECF MAIN_DELAY2,F
	BNZ LOOP
	RETURN
   
    DELAY;DELAY FOR 10ms
	MOVLW D'20'
	MOVWF 0X11
AGAIN2	MOVLW D'100'
	MOVWF 0x10
AGAIN	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	DECF 0x10, F
	BNZ AGAIN
	DECF 0X11,F
	BNZ AGAIN2
	RETURN

	

DISPLAY
 ;This Block of data display value of Var1 on the Leds    
	MOVFF VAR1,LATD	
	SWAPF VAR1,w 
	MOVWF LATB
	
  RETURN 
  
  TEST;FENA N2ELO CHECK L0=1 BUT RA5 ISNT EQUAL TO 1 CALL SOULS
  BTFSC PORTD,0
  CALL TEST2
  CALL TEST3
  RE	RETURN
  
  TEST3;IF PORTD IS 0 DPES PORT A PRESSED Y3NE CLEAR
  BTFSS PORTA,5
  CALL SOULS
  GOTO RE
  
  TEST2;IF PORT D IS 1 
  BTFSC PORTA,5;
  CALL SOULS
  CALL DELAYSWITCH
  BTFSS PORTA,5
  CALL WINNER
  RETURN
  

  
  WINNER
 DECF MAIN_DELAY,F
 
 GOTO MAIN_LOOP
  
  DELAYSWITCH 	
	MOVLW D'15';the number placed here is the time of delation at default (1) it is 100ms 
	MOVWF 0X50
LOOP9	CALL DELAY

	DECF 0X50,F
	BNZ LOOP9
	RETURN
  
  
  
  
  
  
  
  
    END
    
      ;THE SUBROTINE FOR UR 3 SOULS 
  
;   INCVAR ;IF THE SWITCH IS PRESSED IT WILL COME TO HERE
;   INCF COUNTERVAR
;   MOVFF COUNTERVAR,DISPL
;   CALL DISPLAY
;   MOVLW D'3'
;   MOVWF VAR1_LOC
;   CALL DELAY
; 
;   
  
  ;    
;		BTFSC LATB,0; TEST IF THE BIT OF PORT B IS 0 THEN SKIP AND IF SET THAT MEANS IT IS L0
;SHIFITNG_LOOP	CALL SHIFTING_LEFT
;		BTFSS LATD,6;IF THE TEST IS SET IT WILL BE ON L7 SO IT SHOULD START GOING BACKWARD
;		BRA SHIFITNG_LOOP
;SHIFT_LOOP CALL SHIFTING_RIGHT;
;		BTFSS LATD,0; TEST IF THE BIT OF PORT B IS 0 THEN SKIP AND IF SET THAT MEANS IT IS L0
;	        BRA SHIFT_LOOP
;		BRA SHIFTING_LEFT
		
;TELL NOW THIS SHOULD BE AN INFINITE LOOP WHERE WE ARE 
;TESTING IF L0 IS CLEAR THEN TEST IF L7 IS 1 IF NOT WE SHIFT LEFT 
;AND WE COMPLETE TESING UNTIL THE L7 IS EQUAL TO 1 WE CALL SHIFT RIGHT 
;IF L0 IS 1 THEN WE CALL AGAIN SHIFT LEFFT IF NOT IT COMPLETE SHIFTING LEFT 
;
      