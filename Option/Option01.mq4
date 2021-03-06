//+------------------------------------------------------------------+
//|                                                     Option01.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "Thanakorn"
#property version   "1.00"
#property strict
//Run TF 5
input string Token="5bVhzA8KSfoiqTJbsY7NuGJcCSrRS3ZUVJLDCpKysvd";
string Massage ="แจ้งเตือน";
double Currentclose = 0;
double Stagecloce = 0;
int TempBuy = 0;
int TempSell = 0;
int TimesBuy = 0;
int TimesSell = 0;
double OrderSell = 0;
double OrderBuy = 0;
int totalorder = 0;
input int lot = 1;
input int MoneyBase = 50;
int money = MoneyBase;

bool CheckSell = false;
bool CheckBuy = false; 

void CheckForSel()
{
   
   if(totalorder == 0 && CheckSell)
     {
      TimesSell = TimeMinute(TimeCurrent());
      int h=TimeHour(TimeCurrent());
      
      Massage = "Order Sell         "+"Time"+h+"."+TimesSell+" End 10 m";
      Line();
      TimesSell = TempSell + 10;
     // int ticket = OrderSend(Symbol(),OP_SELL,0.01,Bid,10,0,0,"My order",0,0,clrRed);
      OrderSell = Close[1];
      totalorder = 1;
     }
}
void  CheckForBuy()
{
    
    if(totalorder == 0 && CheckBuy)
     {
      TimesBuy =TimeMinute(TimeCurrent());
      int h=TimeHour(TimeCurrent());
     
      Massage="Order Buy         "+"Time"+h+"."+TimesBuy+" End 10 m";
      Line();
      TimesBuy =  TempBuy + 10;
     // int ticket = OrderSend(Symbol(),OP_BUY,0.01,Ask,10,0,0,"My order",0,0,clrGreen);
      OrderBuy = Close[1];
      totalorder = 1;
     }
}

void countorder()
{
      int buyorder=-1;
      int sellorder=0;

   for(int i=0;i<=OrdersTotal();i++)
   {
      OrderSelect(i,SELECT_BY_POS,MODE_TRADES);
      if(OrderType()==OP_BUY)
        {
        buyorder++;
        }

      if(OrderType()==OP_SELL)
        {
        sellorder++;
        }
       
   }
    totalorder = sellorder + buyorder;
 }
 
 void Orderclose()
 {
    int m = TimeMinute(TimeCurrent());
      //Closing the order using the correct price depending on the type of order
      if(m == TimesBuy && totalorder == 1){  
         // res=OrderClose(OrderTicket(),OrderLots(),BidPrice,Slippage);
         totalorder = 0;
         TimesBuy = 0;
            if(OrderBuy > Close[1])
            {
             money = money + 0.80*lot;
             totalorder = 0;
            }
          if(OrderBuy < Close[1])
            {
             money = money - lot;
             totalorder = 0;
            }
      }
      if(m == TimesSell && totalorder == 1){
      
       //  res=OrderClose(OrderTicket(),OrderLots(),AskPrice,Slippage);
       
          TimesSell = 0;
            if(OrderSell < Close[1])
            {
             money = money + 0.80*lot;
             totalorder = 0;
            }
          if(OrderSell > Close[1])
            {
             money = money - lot;
             totalorder = 0;
            }
      }
       if(OrderSell > 59 || OrderBuy > 59)
        {
         OrderSell = 0;
         totalorder = 0;
        }
      Comment(money);
 }
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
     CreateButton();
   //Comment(clolse01); //ราคาปิดแท่งปัจจุบัน
   double ma1 = iMA(NULL,0,36,0,MODE_SMA,PRICE_CLOSE,0); //เขียว
   double ma2 = iMA(NULL,0,60,0,MODE_SMA,PRICE_CLOSE,0); // แดง
   double ma3 = iMA(NULL,0,200,0,MODE_SMA,PRICE_CLOSE,0); //น้ำเงิน
   double ma4 = iMA(NULL,0,10,0,MODE_SMA,PRICE_CLOSE,0); //ดำ
   double ma5 = iMA(NULL,0,30,0,MODE_SMA,PRICE_CLOSE,0); //น้ำตาล
   int m =TimeMinute(TimeCurrent());
   bool check = false;
  // countorder();
   Orderclose();

   if(ma4 < ma5-Point*40)//sell
     {
      CheckSell = true;
     }
     else
       {
        CheckSell = false;
       }
   if(ma4 > ma5+Point*40)//Buy
     {
      CheckBuy = true;
     }
     else
       {
        CheckBuy = false;
       }
     
   if(ma3 > ma2 && ma2 > ma1 && ma1 > ma5 && ma5 > ma4 && Bid > ma5) //Sell
     {
         CheckForSel();
     }
   if(ma3 < ma2 && ma2 < ma1 && ma1 < ma5 && ma5 < ma4 && Ask < ma5)//Sell
    {
        CheckForBuy();
    }
  
  
  }
//+------------------------------------------------------------------+



void CreateButton(){
   ObjectCreate(0,"Test",OBJ_BUTTON,0,0,0);
   ObjectSetInteger(0,"Test",OBJPROP_XDISTANCE,120); //ตำแน่งปุ่มX
   ObjectSetInteger(0,"Test",OBJPROP_YDISTANCE,120);//ตำแหน่งปุ่มY
   ObjectSetInteger(0,"Test",OBJPROP_XSIZE,80);      //ขนาดปุ่ม Y
   ObjectSetInteger(0,"Test",OBJPROP_YSIZE,40);      //ขนาดปุ่ม 
   ObjectSetInteger(0,"Test",OBJPROP_BGCOLOR,clrBlue);    //สีปุ่มกด
   ObjectSetInteger(0,"Test",OBJPROP_COLOR,clrWhite);      //สีข้อควาทปุ่มกด
   ObjectSetString(0,"Test",OBJPROP_TEXT,"Test");      //ข้อความปุ่มกด
   
}
void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam)
   { 
   if(id == CHARTEVENT_OBJECT_CLICK && sparam == "Test")
   {
      
      Massage = "Test Ea Option";
      CheckForBuy();
      CheckForSel();
      Line();
      
   }
    
   }
void Line()
{
   string headers;
 char data[], result[];

headers="Authorization: Bearer "+Token+"\r\n	application/x-www-form-urlencoded\r\n";


ArrayResize(data,StringToCharArray("message="+Massage,data,0,WHOLE_ARRAY,CP_UTF8)-1);

int res = WebRequest("POST", "https://notify-api.line.me/api/notify", headers, 0, data, data, headers);
   if(res==-1) 
     { 
      Print("Error in WebRequest. Error code  =",GetLastError()); 
      MessageBox("Add the address 'https://notify-api.line.me' in the list of allowed URLs on tab 'Expert Advisors'","Error",MB_ICONINFORMATION); 
     } 
}