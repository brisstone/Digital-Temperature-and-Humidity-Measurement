
_StartSignal:

;dht11.c,18 :: 		void StartSignal(){
;dht11.c,19 :: 		TRISD.B0 = 0; //Configure RD0 as output
	BCF        TRISD+0, 0
;dht11.c,20 :: 		PORTD.B0 = 0; //RD0 sends 0 to the sensor
	BCF        PORTD+0, 0
;dht11.c,21 :: 		delay_ms(18);
	MOVLW      47
	MOVWF      R12+0
	MOVLW      191
	MOVWF      R13+0
L_StartSignal0:
	DECFSZ     R13+0, 1
	GOTO       L_StartSignal0
	DECFSZ     R12+0, 1
	GOTO       L_StartSignal0
	NOP
	NOP
;dht11.c,22 :: 		PORTD.B0 = 1; //RD0 sends 1 to the sensor
	BSF        PORTD+0, 0
;dht11.c,23 :: 		delay_us(30);
	MOVLW      19
	MOVWF      R13+0
L_StartSignal1:
	DECFSZ     R13+0, 1
	GOTO       L_StartSignal1
	NOP
	NOP
;dht11.c,24 :: 		TRISD.B0 = 1; //Configure RD0 as input
	BSF        TRISD+0, 0
;dht11.c,25 :: 		}
L_end_StartSignal:
	RETURN
; end of _StartSignal

_CheckResponse:

;dht11.c,27 :: 		void CheckResponse(){
;dht11.c,28 :: 		Check = 0;
	CLRF       _Check+0
;dht11.c,29 :: 		delay_us(40);
	MOVLW      26
	MOVWF      R13+0
L_CheckResponse2:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse2
	NOP
;dht11.c,30 :: 		if (PORTD.B0 == 0){
	BTFSC      PORTD+0, 0
	GOTO       L_CheckResponse3
;dht11.c,31 :: 		delay_us(80);
	MOVLW      53
	MOVWF      R13+0
L_CheckResponse4:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse4
;dht11.c,32 :: 		if (PORTD.B0 == 1) Check = 1; delay_us(40);}
	BTFSS      PORTD+0, 0
	GOTO       L_CheckResponse5
	MOVLW      1
	MOVWF      _Check+0
L_CheckResponse5:
	MOVLW      26
	MOVWF      R13+0
L_CheckResponse6:
	DECFSZ     R13+0, 1
	GOTO       L_CheckResponse6
	NOP
L_CheckResponse3:
;dht11.c,33 :: 		}
L_end_CheckResponse:
	RETURN
; end of _CheckResponse

_ReadData:

;dht11.c,35 :: 		char ReadData(){
;dht11.c,37 :: 		for(j = 0; j < 8; j++){
	CLRF       R3+0
L_ReadData7:
	MOVLW      8
	SUBWF      R3+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_ReadData8
;dht11.c,38 :: 		while(!PORTD.B0); //Wait until PORTD.F0 goes HIGH
L_ReadData10:
	BTFSC      PORTD+0, 0
	GOTO       L_ReadData11
	GOTO       L_ReadData10
L_ReadData11:
;dht11.c,39 :: 		delay_us(30);
	MOVLW      19
	MOVWF      R13+0
L_ReadData12:
	DECFSZ     R13+0, 1
	GOTO       L_ReadData12
	NOP
	NOP
;dht11.c,40 :: 		if(PORTD.B0 == 0)
	BTFSC      PORTD+0, 0
	GOTO       L_ReadData13
;dht11.c,41 :: 		i&= ~(1<<(7 - j)); //Clear bit (7-b)
	MOVF       R3+0, 0
	SUBLW      7
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      R1+0
	MOVLW      1
	MOVWF      R0+0
	MOVF       R1+0, 0
L__ReadData28:
	BTFSC      STATUS+0, 2
	GOTO       L__ReadData29
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__ReadData28
L__ReadData29:
	COMF       R0+0, 1
	MOVF       R0+0, 0
	ANDWF      R2+0, 1
	GOTO       L_ReadData14
L_ReadData13:
;dht11.c,42 :: 		else {i|= (1 << (7 - j)); //Set bit (7-b)
	MOVF       R3+0, 0
	SUBLW      7
	MOVWF      R0+0
	MOVF       R0+0, 0
	MOVWF      R1+0
	MOVLW      1
	MOVWF      R0+0
	MOVF       R1+0, 0
L__ReadData30:
	BTFSC      STATUS+0, 2
	GOTO       L__ReadData31
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__ReadData30
L__ReadData31:
	MOVF       R0+0, 0
	IORWF      R2+0, 1
;dht11.c,43 :: 		while(PORTD.B0);} //Wait until PORTD.F0 goes LOW
L_ReadData15:
	BTFSS      PORTD+0, 0
	GOTO       L_ReadData16
	GOTO       L_ReadData15
L_ReadData16:
L_ReadData14:
;dht11.c,37 :: 		for(j = 0; j < 8; j++){
	INCF       R3+0, 1
;dht11.c,44 :: 		}
	GOTO       L_ReadData7
L_ReadData8:
;dht11.c,45 :: 		return i;
	MOVF       R2+0, 0
	MOVWF      R0+0
;dht11.c,46 :: 		}
L_end_ReadData:
	RETURN
; end of _ReadData

_main:

;dht11.c,48 :: 		void main() {
;dht11.c,49 :: 		TRISD.F1 = 0;
	BCF        TRISD+0, 1
;dht11.c,50 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;dht11.c,51 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;dht11.c,52 :: 		Lcd_Cmd(_LCD_CLEAR); // clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;dht11.c,53 :: 		while(1){
L_main17:
;dht11.c,54 :: 		StartSignal();
	CALL       _StartSignal+0
;dht11.c,55 :: 		CheckResponse();
	CALL       _CheckResponse+0
;dht11.c,56 :: 		if(Check == 1){
	MOVF       _Check+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main19
;dht11.c,57 :: 		RH_byte1 = ReadData();
	CALL       _ReadData+0
	MOVF       R0+0, 0
	MOVWF      _RH_byte1+0
;dht11.c,58 :: 		RH_byte2 = ReadData();
	CALL       _ReadData+0
	MOVF       R0+0, 0
	MOVWF      _RH_byte2+0
;dht11.c,59 :: 		T_byte1 = ReadData();
	CALL       _ReadData+0
	MOVF       R0+0, 0
	MOVWF      _T_byte1+0
;dht11.c,60 :: 		T_byte2 = ReadData();
	CALL       _ReadData+0
	MOVF       R0+0, 0
	MOVWF      _T_byte2+0
;dht11.c,61 :: 		Sum = ReadData();
	CALL       _ReadData+0
	MOVF       R0+0, 0
	MOVWF      _Sum+0
	CLRF       _Sum+1
;dht11.c,62 :: 		if(Sum == ((RH_byte1+RH_byte2+T_byte1+T_byte2) & 0XFF)){
	MOVF       _RH_byte2+0, 0
	ADDWF      _RH_byte1+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       _T_byte1+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVF       _T_byte2+0, 0
	ADDWF      R0+0, 1
	BTFSC      STATUS+0, 0
	INCF       R0+1, 1
	MOVLW      255
	ANDWF      R0+0, 0
	MOVWF      R2+0
	MOVF       R0+1, 0
	MOVWF      R2+1
	MOVLW      0
	ANDWF      R2+1, 1
	MOVF       _Sum+1, 0
	XORWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main33
	MOVF       R2+0, 0
	XORWF      _Sum+0, 0
L__main33:
	BTFSS      STATUS+0, 2
	GOTO       L_main20
;dht11.c,63 :: 		Temp = T_byte1;
	MOVF       _T_byte1+0, 0
	MOVWF      _Temp+0
	CLRF       _Temp+1
;dht11.c,64 :: 		RH = RH_byte1;
	MOVF       _RH_byte1+0, 0
	MOVWF      _RH+0
	CLRF       _RH+1
;dht11.c,65 :: 		Lcd_Cmd(_LCD_CLEAR); // clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;dht11.c,66 :: 		Lcd_Out(1, 6, "Temp: ");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      6
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_dht11+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;dht11.c,67 :: 		Lcd_Out(1, 15, "C");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      15
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr2_dht11+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;dht11.c,68 :: 		Lcd_Out(2, 2, "Humidity: ");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_dht11+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;dht11.c,69 :: 		Lcd_Out(2, 14, "%");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      14
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_dht11+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;dht11.c,70 :: 		LCD_Chr(1, 12, 48 + ((Temp / 10) % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _Temp+0, 0
	MOVWF      R0+0
	MOVF       _Temp+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;dht11.c,71 :: 		LCD_Chr(1, 13, 48 + (Temp % 10));
	MOVLW      1
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _Temp+0, 0
	MOVWF      R0+0
	MOVF       _Temp+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;dht11.c,72 :: 		LCD_Chr(2, 12, 48 + ((RH / 10) % 10));
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      12
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _RH+0, 0
	MOVWF      R0+0
	MOVF       _RH+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;dht11.c,73 :: 		LCD_Chr(2, 13, 48 + (RH % 10));
	MOVLW      2
	MOVWF      FARG_Lcd_Chr_row+0
	MOVLW      13
	MOVWF      FARG_Lcd_Chr_column+0
	MOVLW      10
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVF       _RH+0, 0
	MOVWF      R0+0
	MOVF       _RH+1, 0
	MOVWF      R0+1
	CALL       _Div_16X16_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_out_char+0
	CALL       _Lcd_Chr+0
;dht11.c,74 :: 		delay_ms(80);
	MOVLW      208
	MOVWF      R12+0
	MOVLW      201
	MOVWF      R13+0
L_main21:
	DECFSZ     R13+0, 1
	GOTO       L_main21
	DECFSZ     R12+0, 1
	GOTO       L_main21
	NOP
	NOP
;dht11.c,76 :: 		}
	GOTO       L_main22
L_main20:
;dht11.c,78 :: 		Lcd_Cmd(_LCD_CURSOR_OFF); // cursor off
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;dht11.c,79 :: 		Lcd_Cmd(_LCD_CLEAR); // clear LCD
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;dht11.c,80 :: 		Lcd_Out(1, 1, "Check sum error");}
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_dht11+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
L_main22:
;dht11.c,81 :: 		}
	GOTO       L_main23
L_main19:
;dht11.c,83 :: 		Lcd_Out(1, 3, "No response");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      3
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr6_dht11+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;dht11.c,84 :: 		Lcd_Out(2, 1, "from the sensor");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr7_dht11+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;dht11.c,85 :: 		}
L_main23:
;dht11.c,86 :: 		delay_ms(1000);
	MOVLW      11
	MOVWF      R11+0
	MOVLW      38
	MOVWF      R12+0
	MOVLW      93
	MOVWF      R13+0
L_main24:
	DECFSZ     R13+0, 1
	GOTO       L_main24
	DECFSZ     R12+0, 1
	GOTO       L_main24
	DECFSZ     R11+0, 1
	GOTO       L_main24
	NOP
	NOP
;dht11.c,87 :: 		}
	GOTO       L_main17
;dht11.c,88 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
