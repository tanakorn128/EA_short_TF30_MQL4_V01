//+------------------------------------------------------------------+
//|                                                   EA_SHORT30.mq4 |
//|                        Copyright 2020, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#define MAGICMA  20131111
#property copyright "Copyright 2020, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
input double lots =0.01;
double ma1;
double ma2;
double ma3;
double TakeProfit;
double StopLoss;
double TakeProfit1;
double StopLoss1;
int hour1 = 6;
int hour2 = 21;
int    res;
void CheckForSell()
  {
   
   return;
   res=OrderSend(Symbol(),OP_BUY,lots,Ask,20,StopLoss1,TakeProfit1,"",MAGICMA,0,Blue);
   return;
 
  }
void CheckForBuy()
  {
   
   if(Volume[0]>25) return;
   res=OrderSend(Symbol(),OP_SELL,lots,Bid,20,StopLoss,TakeProfit,"",MAGICMA,0,Red);
   return;

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
   ma1 = iMA(NULL,0,14,0,MODE_EMA,PRICE_WEIGHTED,0); //bule
   ma2 = iMA(NULL,0,50,0,MODE_EMA,PRICE_OPEN,0); //red
   
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
   TakeProfit = Bid - 500*Point;
   StopLoss = Ask + 5000*Point;
   TakeProfit1 = Ask + 500*Point;
   StopLoss1 = Bid - 5000*Point;
      if(ma1>ma2){
        ma3 = ma1;
      }
    if(ma1-200*Point > ma3 && Close[1] > ma2 && CountSymbolPositions<1 && Hour()>hour1 && Hour()<hour2){
   
    CheckForSell();
   };
    if(ma1+200*Point > ma3 && Close[1] < ma2 && CountSymbolPositions<1 && Hour()>hour1 && Hour()<hour2){
   
    CheckForBuy();
   };
  
  }
//+------------------------------------------------------------------+
