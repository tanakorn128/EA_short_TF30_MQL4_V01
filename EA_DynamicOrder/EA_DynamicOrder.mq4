//+------------------------------------------------------------------+
//|                                                            f.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "Thanakorn"
#property version   "1.00"
#property strict
// 30$ = 0.03 cen 
int adx_sell = 0; //ออกออเดอร์
double Win_Price = WindowPriceOnDropped(); //The script isdropped here
string Symb=Symbol();   //Symble
double Dist=1000000.0; //Preseting
int totalorder = 0;
int Real_Order=-1; //No maket orders yet
bool stage = true; //ปุ่มกด
bool adxsell = false;
string adxsells = "false";
bool adxbuy = false;
string adxbuys = "false";
bool adxbule = false;
int psstage = 0;
int nextorder = 1;
string adxbules = "false";
input int Di_up = 25;
input int Di_low = 25;
input int Di_mid = 25;
input string lable1 = "----------------------------------------------------------------------------------------------------";
input int bb_Up = 14;
input int bb_Mid = 14;
input int bb_Low = 14;
input string lable2 = "----------------------------------------------------------------------------------------------------";
input int MA = 14;
input string lable3 = "----------------------------------------------------------------------------------------------------";
input int TP = 100;
input int SL = 100;
input int x = 10;
input double Lot = 0.01;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
    CreateButton();
   return(INIT_SUCCEEDED);
//---
        
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
   CreateButton();
   countorder();
   Indy();
   User();
    
//---
  }
//+------------------------------------------------------------------+
void CreateButton()
{
   ObjectCreate(0,"Start",OBJ_BUTTON,0,0,0); //สร้างปุ่มStart/Stop
   ObjectSetInteger(0,"Start",OBJPROP_XDISTANCE,1030); //ตำแน่งปุ่มY
   ObjectSetInteger(0,"Start",OBJPROP_YDISTANCE,250); //ตำแหน่งปุ่มX
   ObjectSetInteger(0,"Start",OBJPROP_XSIZE,80);      //ขนาดปุ่ม Y
   ObjectSetInteger(0,"Start",OBJPROP_YSIZE,40);      //ขนาดปุ่ม X
   ObjectSetInteger(0,"Start",OBJPROP_BGCOLOR,clrGreen);    //สีปุ่มกด
   ObjectSetInteger(0,"Start",OBJPROP_BORDER_COLOR,clrWheat);     //สีกรอบ
   ObjectSetInteger(0,"Start",OBJPROP_COLOR,clrWhite);      //สีข้อควาทปุ่มกด
   ObjectSetString(0,"Start",OBJPROP_TEXT,"OrderNext = "+nextorder);      //ข้อความปุ่มกด
   //-----------------------------------------------------------------------------
   //-----------------------------------------------------------------------------
  
}

 void OnChartEvent(const int id,const long& lparam,const double& dparam,const string& sparam)
       {
        if(id == CHARTEVENT_OBJECT_CLICK && sparam == "Start")
        {
        stage = !stage;
        if(stage) //เปลี่ยนสี่ปุ่มStart/Stop
            {
         ObjectSetString(0,"Start",OBJPROP_TEXT,"Start");
         ObjectSetInteger(0,"Start",OBJPROP_BGCOLOR,clrGreen);
         ObjectSetInteger(0,"Start",OBJPROP_COLOR,clrWhite);
           
            }
         else
            {
         ObjectSetString(0,"Start",OBJPROP_TEXT,"Stop");
         ObjectSetInteger(0,"Start",OBJPROP_BGCOLOR,clrRed);
         ObjectSetInteger(0,"Start",OBJPROP_COLOR,clrWhite);
             }
            }
         //-----------------------------------------------------------------------------------
         //-----------------------------------------------------------------------------------
         
            
       }
      

void Indy()
{
   double bb_Up = iBands(NULL,0,bb_Up,2,0,PRICE_CLOSE,MODE_UPPER,0); //BBบน
   double bb_Low = iBands(NULL,0,bb_Low,2,0,PRICE_CLOSE,MODE_LOWER,0);//BBล่าง
   double bb_Mid = iBands(NULL,0,bb_Mid,2,0,PRICE_CLOSE,MODE_BASE,0);//BBกลาง
   double MA = iMA(NULL,0,MA,2,MODE_EMA,PRICE_WEIGHTED,0);// MA
   double ADXBUY = iADX(NULL,0,Di_up,PRICE_CLOSE,MODE_PLUSDI,0); 
   double ADXSELL = iADX(NULL,0,Di_low,PRICE_CLOSE,MODE_MINUSDI,0);
   double ADXBULE = iADX(NULL,0,Di_mid,PRICE_CLOSE,MODE_MAIN,0);
   int m=TimeMinute(TimeCurrent()); //เวลา0 -60นาที
 /*  Comment("BB_Up = "+bb_Up,"\n"+"bb_Mid =" +bb_Mid,"\n"+"bb_Low =" +bb_Low,"\n"+"MA =" +MA //แสดลข้อมูลต่าง ๆ
   ,"\n"+"ADXBUY =" +ADXBUY,"\n"+"ADXSELL =" +ADXSELL,"\n"+"ADXBULE =" +ADXBULE ,"\n"+"adxsell =" +ADXSELL
   ,"\n"+"ADXBUY =" +ADXBUY,"\n"+"ADXBULE =" +adxbules,"\n"+"Time =" +m,"\n"+"nextorder =" +nextorder); */
  
//;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
   if(ADXSELL > Di_low){adxsell = true; adxsells = "true";} else{ adxsell = false; adxsells = "false";}
   if(ADXBUY > Di_up){adxbuy = true; adxbuys = "true";} else{adxbuy = false;adxbuys = "false";}
   if(ADXBULE > Di_mid){adxbule = true;adxbules = "true";}else{adxbule = false;adxbules = "false";}
 //;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
 
  //เปิดออเดอร์Sell
    if(true)
   {
     if(ADXBULE < Di_mid-x)
     {
      if(m == 30||(m == 60)){if(ADXSELL > Di_low){if(totalorder < nextorder){int ticket = OrderSend(Symbol(),OP_SELL,Lot,Bid,10,Bid+Point*SL,Bid-Point*TP,"My order",0,0,clrRed); }}} 
    psstage = totalorder;
      }
  
  //เปิดออเดอร์Buy
   if(ADXBULE < Di_mid-x)
     {
      if(m == 30||(m == 60)){if(ADXBUY >Di_up){if(totalorder < nextorder){int ticket = OrderSend(Symbol(),OP_BUY,Lot,Ask,10,Ask-Point*SL,Ask+Point*TP,"My order",0,0,clrGreen); }}}
    psstage = totalorder;
      }
   if(m == 29)
     {
     nextorder = totalorder+1;
     }
    if(m == 28)
     {
      nextorder = totalorder+1;
     }
     }
  //------------------------------------------------------------------------------------------------------------------------
   // Comment("sellorder ="+sellorder,"\n"+"buyorder ="+buyorder,"\n"+"totalorder ="+totalorder);
 //-------------------------------------------------------------------------------------------------------------
 
 //Update the exchange rates before closing the orders
   RefreshRates();
      //Log in the terminal the total of orders, current and past
      Print(OrdersTotal());
      
   //Start a loop to scan all the orders
   //The loop starts from the last otherwise it would miss orders
   for(int i=(OrdersTotal()-1);i>=0;i--){
      
      //If the order cannot be selected throw and log an error
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==false){
         Print("ERROR - Unable to select the order - ",GetLastError());
         break;
      } 
 
      //Create the required variables
      //Result variable, to check if the operation is successful or not
      bool res=false;
      
      //Allowed Slippage, which is the difference between current price and close price
      int Slippage=0;
      
      //Bid and Ask Price for the Instrument of the order
      double BidPrice=MarketInfo(OrderSymbol(),MODE_BID);
      double AskPrice=MarketInfo(OrderSymbol(),MODE_ASK);
 
      //Closing the order using the correct price depending on the type of order
      if(OrderType()==OP_BUY){
      if(ADXSELL<ADXBUY)
        {
      //    res=OrderClose(OrderTicket(),OrderLots(),BidPrice,Slippage);
          totalorder = 0;
        }
        
      }
      if(OrderType()==OP_SELL){
      if(ADXBUY>ADXSELL)
        {
     //    res=OrderClose(OrderTicket(),OrderLots(),AskPrice,Slippage);
         totalorder = 0;
        }
         
      }
      
      //If there was an error log it
      if(res==false) Print("ERROR - Unable to close the order - ",OrderTicket()," - ",GetLastError());
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

void User(){
   //--- Name of the company 
   string company=AccountInfoString(ACCOUNT_COMPANY); 
//--- Name of the client 
   string name=AccountInfoString(ACCOUNT_NAME); 
//--- Account number 
   
//--- Name of the server 
   string server=AccountInfoString(ACCOUNT_SERVER); 
//--- Account currency 
   string currency=AccountInfoString(ACCOUNT_CURRENCY); 
//--- Demo, contest or real account 
   ENUM_ACCOUNT_TRADE_MODE account_type=(ENUM_ACCOUNT_TRADE_MODE)AccountInfoInteger(ACCOUNT_TRADE_MODE); 
//--- Now transform the value of  the enumeration into an understandable form 
   string trade_mode; 
   switch(account_type) 
     { 
      case  ACCOUNT_TRADE_MODE_DEMO: 
         trade_mode="demo"; 
         break; 
      case  ACCOUNT_TRADE_MODE_CONTEST: 
         trade_mode="contest"; 
         break; 
      default: 
         trade_mode="real"; 
         break; 
     } 
//--- Stop Out is set in percentage or money 
   ENUM_ACCOUNT_STOPOUT_MODE stop_out_mode=(ENUM_ACCOUNT_STOPOUT_MODE)AccountInfoInteger(ACCOUNT_MARGIN_SO_MODE); 
//--- Get the value of the levels when Margin Call and Stop Out occur 
   double margin_call=AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL); 
   double stop_out=AccountInfoDouble(ACCOUNT_MARGIN_SO_SO); 
//--- Show brief account information 
  // Comment("The account of the client '%s' #%d %s opened in '%s' on the server '%s'", 
      //         name,login,trade_mode,company,server); 
  // Comment("Account currency - %s, MarginCall and StopOut levels are set in %s", 
    //           currency,(stop_out_mode==ACCOUNT_STOPOUT_MODE_PERCENT)?"percentage":" money"); 
  // Comment("MarginCall=%G, StopOut=%G",margin_call,stop_out); 
   
}

