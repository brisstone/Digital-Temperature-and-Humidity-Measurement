// LCD module connections
 sbit LCD_RS at RD2_bit;
 sbit LCD_EN at RD3_bit;
 sbit LCD_D4 at RD4_bit;
 sbit LCD_D5 at RD5_bit;
 sbit LCD_D6 at RD6_bit;
 sbit LCD_D7 at RD7_bit;
 sbit LCD_RS_Direction at TRISD2_bit;
 sbit LCD_EN_Direction at TRISD3_bit;
 sbit LCD_D4_Direction at TRISD4_bit;
 sbit LCD_D5_Direction at TRISD5_bit;
 sbit LCD_D6_Direction at TRISD6_bit;
 sbit LCD_D7_Direction at TRISD7_bit;
 // End LCD module connections
 unsigned char Check, T_byte1, T_byte2,
 RH_byte1, RH_byte2, Ch ;
 unsigned Temp, RH, Sum ;
void StartSignal(){
 TRISD.B0 = 0; //Configure RD0 as output
 PORTD.B0 = 0; //RD0 sends 0 to the sensor
 delay_ms(18);
 PORTD.B0 = 1; //RD0 sends 1 to the sensor
 delay_us(30);
 TRISD.B0 = 1; //Configure RD0 as input
 }
 //////////////////////////////
 void CheckResponse(){
 Check = 0;
 delay_us(40);
 if (PORTD.B0 == 0){
 delay_us(80);
 if (PORTD.B0 == 1) Check = 1; delay_us(40);}
 }
 //////////////////////////////
 char ReadData(){
 char i, j;
 for(j = 0; j < 8; j++){
 while(!PORTD.B0); //Wait until PORTD.F0 goes HIGH
 delay_us(30);
 if(PORTD.B0 == 0)
 i&= ~(1<<(7 - j)); //Clear bit (7-b)
 else {i|= (1 << (7 - j)); //Set bit (7-b)
 while(PORTD.B0);} //Wait until PORTD.F0 goes LOW
 }
 return i;
 }
 //////////////////////////////
void main() {
 TRISD.F1 = 0;
 Lcd_Init();
 Lcd_Cmd(_LCD_CURSOR_OFF); // cursor off
 Lcd_Cmd(_LCD_CLEAR); // clear LCD
 while(1){
 StartSignal();
 CheckResponse();
 if(Check == 1){
 RH_byte1 = ReadData();
 RH_byte2 = ReadData();
 T_byte1 = ReadData();
 T_byte2 = ReadData();
 Sum = ReadData();
 if(Sum == ((RH_byte1+RH_byte2+T_byte1+T_byte2) & 0XFF)){
 Temp = T_byte1;
 RH = RH_byte1;
  Lcd_Cmd(_LCD_CLEAR); // clear LCD
 Lcd_Out(1, 6, "Temp: ");
 Lcd_Out(1, 15, "C");
 Lcd_Out(2, 2, "Humidity: ");
Lcd_Out(2, 14, "%");
 LCD_Chr(1, 12, 48 + ((Temp / 10) % 10));
 LCD_Chr(1, 13, 48 + (Temp % 10));
 LCD_Chr(2, 12, 48 + ((RH / 10) % 10));
 LCD_Chr(2, 13, 48 + (RH % 10));
 delay_ms(80);

 }
 else{
 Lcd_Cmd(_LCD_CURSOR_OFF); // cursor off
 Lcd_Cmd(_LCD_CLEAR); // clear LCD
 Lcd_Out(1, 1, "Check sum error");}
 }
 else {
 Lcd_Out(1, 3, "No response");
 Lcd_Out(2, 1, "from the sensor");
 }
 delay_ms(1000);
 }
}