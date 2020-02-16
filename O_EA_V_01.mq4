//+------------------------------------------------------------------+
//|                                                            f.mq4 |
//|                        Copyright 2019, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2019, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
bool stage = true; //ปุ่มกด
bool adxsell = false;
string adxsells = "false";
bool adxbuy = false;
string adxbuys = "false";
bool adxbule = false;
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
   Indy();
//---
  }
//+------------------------------------------------------------------+
void CreateButton()
{
   ObjectCreate(0,"Start",OBJ_BUTTON,0,0,0); //สร้างปุ่มStart/Stop
   ObjectSetInteger(0,"Start",OBJPROP_XDISTANCE,80); //ตำแน่งปุ่มY
   ObjectSetInteger(0,"Start",OBJPROP_YDISTANCE,80); //ตำแหน่งปุ่มX
   ObjectSetInteger(0,"Start",OBJPROP_XSIZE,80);      //ขนาดปุ่ม Y
   ObjectSetInteger(0,"Start",OBJPROP_YSIZE,40);      //ขนาดปุ่ม X
   ObjectSetInteger(0,"Start",OBJPROP_BGCOLOR,clrGreen);    //สีปุ่มกด
   ObjectSetInteger(0,"Start",OBJPROP_BORDER_COLOR,clrWheat);     //สีกรอบ
   ObjectSetInteger(0,"Start",OBJPROP_COLOR,clrWhite);      //สีข้อควาทปุ่มกด
   ObjectSetString(0,"Start",OBJPROP_TEXT,"Start");      //ข้อความปุ่มกด
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
      
void OpenBuy()
{
  Comment("OK");
  int ticket = OrderSend(Symbol(),OP_SELL,1,Ask,10,0,0,"My order",0,0,clrGreen);       
}

void OpenSell()
{
  Comment("OK");
  int ticket = OrderSend(Symbol(),OP_SELL,1,Bid,10,0,0,"My order",0,0,clrRed);   

}
void Indy()
{
   double bb_Up = iBands(NULL,0,bb_Up,2,0,PRICE_CLOSE,MODE_UPPER,0);
   double bb_Low = iBands(NULL,0,bb_Low,2,0,PRICE_CLOSE,MODE_LOWER,0);
   double bb_Mid = iBands(NULL,0,bb_Mid,2,0,PRICE_CLOSE,MODE_BASE,0);
   double MA = iMA(NULL,0,MA,2,MODE_EMA,PRICE_WEIGHTED,0);
   double ADXBUY = iADX(NULL,0,Di_up,PRICE_CLOSE,MODE_PLUSDI,0);
   double ADXSELL = iADX(NULL,0,Di_low,PRICE_CLOSE,MODE_MINUSDI,0);
   double ADXBULE = iADX(NULL,0,Di_mid,PRICE_CLOSE,MODE_MAIN,0);
   Comment("BB_Up = "+bb_Up,"\n"+"bb_Mid =" +bb_Mid,"\n"+"bb_Low =" +bb_Low,"\n"+"MA =" +MA
   ,"\n"+"ADXBUY =" +ADXBUY,"\n"+"ADXSELL =" +ADXSELL,"\n"+"ADXBULE =" +ADXBULE ,"\n"+"adxsell =" +adxsells
   ,"\n"+"ADXBUY =" +adxbuys,"\n"+"ADXBULE =" +adxbules);
   
   if(ADXSELL > Di_low)
     {
      adxsell = true;
      adxsells = "true";
     }
     else
       {
        adxsell = false;
        adxsells = "false";
       }
       if(ADXBUY > Di_up)
         {
          ADXBUY = true;
          adxbuys = "true";
         }
         else
           {
            ADXBUY = false;
            adxbuys = "false";
           }
           if(ADXBULE > Di_mid)
             {
              adxbule = true;
              adxbules = "true";
             }
             else
               {
                adxbule = false;;
                adxbules = "false";
               }
           
}
