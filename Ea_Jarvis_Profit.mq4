//H1//

#define MAGICMA  20131111

input double lots =0.01;
int hour1 = 6;
int hour2 = 21;
int    res;
double ma1;
double ma2;
double ma3;
double ma4;
double ma5;
double ma6;
double ma1ma2;
double ma2ma1;
double ma3ma4;
double ma4ma3;
double TakeProfit;
double StopLoss;
double TakeProfit1;
double StopLoss1;
long login=AccountInfoInteger(ACCOUNT_LOGIN);
void CheckForSell()
  {
   
   if(Volume[0]>25) return;
   res=OrderSend(Symbol(),OP_SELL,lots,Bid,20,StopLoss,TakeProfit,"",MAGICMA,0,Red);
   return;

  }
  
void CheckForBuy()
  {
   
   if(Volume[0]>25) return;
   res=OrderSend(Symbol(),OP_BUY,lots,Ask,20,StopLoss1,TakeProfit1,"",MAGICMA,0,Blue);
   return;
 
  }
 
void OnTick()
  {
   if(login == 260304242)
   {
   ma1 = iMA(NULL,60,9,0,MODE_LWMA,PRICE_OPEN,0); //แส้นแดง
   ma2 = iMA(NULL,60,9,0,MODE_LWMA,PRICE_CLOSE,0); //เส้นเขียว
   ma3 = iMA(NULL,60,50,0,MODE_SMA,PRICE_CLOSE,0); //เส้นน้ำเงิน
   ma4 = iMA(NULL,60,1,0,MODE_SMA,PRICE_CLOSE,0); //เส้นดำ
   ma1ma2 = ma1-ma2;
   ma2ma1 = ma2-ma1;
   ma3ma4 = ma3-ma4;
   ma4ma3 = ma4-ma3;
   }
   else
   {
   Comment("Error login");
   }
   int CountSymbolPositions=0;
 
   for(int trade=OrdersTotal()-1;trade>=0;trade--)
    {
      if(!OrderSelect(trade,SELECT_BY_POS,MODE_TRADES))
         continue;
      if(OrderSymbol()==Symbol())
         {
         if((OrderType()==OP_SELL||OrderType()==OP_BUY) && OrderMagicNumber()==MAGICMA)
         CountSymbolPositions++;
         }
    }
  
   TakeProfit = Bid - 680*Point; //600 ตุด
   StopLoss = Ask + 550*Point; //550 จุด
   TakeProfit1 = Ask + 680*Point; // 680 จุด
   StopLoss1 = Bid - 550*Point; // 550จุด
   //Close[] ราคาปิดแท่งเทียน
   //ma3ma4 คือ
     
   if(ma3ma4<0.0048 && ma3>ma1 && ma3>ma2 && Close[1]<Close[2] && Close[2]<Open[2] && CountSymbolPositions<1 && Hour()>hour1 && Hour()<hour2 && ma1ma2<0.0013 && ma1ma2>0.0004){
   
   CheckForSell(); //เปิด Selma3-ma4l
   };
   
   if(ma4ma3<0.0048 && ma3<ma1 && ma3<ma2 && Close[1]>Close[2] && Close[2]>Open[2] && CountSymbolPositions<1 && Hour()>hour1 && Hour()<hour2  && ma2ma1<0.0013&& ma2ma1>0.0004){
   CheckForBuy(); //เปิด Buy
   };
   //เปิดทำงาน 6.00 -21.00 น.
   //------------------------------------------------

  }
  
