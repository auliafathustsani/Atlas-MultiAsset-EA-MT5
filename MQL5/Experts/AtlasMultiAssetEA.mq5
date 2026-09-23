#property copyright "Atlas EA Research Project"
#property version   "1.00"
#property strict
#property description "Trend-momentum EA with fixed-fractional risk and portfolio-grade safeguards"

#include <Trade/Trade.mqh>
#include <Atlas/RiskManager.mqh>
#include <Atlas/TradeGuards.mqh>

input group "Identity and execution"
input ulong InpMagicNumber=26092301;
input ENUM_TIMEFRAMES InpSignalTimeframe=PERIOD_H4;
input int InpSlippagePoints=20;
input int InpMaxSpreadPoints=60;
input int InpSessionStartHour=0;
input int InpSessionEndHour=0;

input group "Signal"
input int InpFastEMA=40;
input int InpSlowEMA=160;
input int InpADXPeriod=14;
input double InpMinADX=20.0;
input int InpRSIPeriod=14;
input double InpLongRSIMin=52.0;
input double InpShortRSIMax=48.0;
input int InpATRPeriod=14;
input double InpStopATR=2.2;
input double InpTakeProfitR=2.0;

input group "Risk controls"
input double InpRiskPerTradePct=0.50;
input double InpMaxDailyLossPct=2.0;
input double InpMaxEquityDrawdownPct=25.0;
input int InpMaxTradesPerDay=2;
input bool InpAllowLong=true;
input bool InpAllowShort=true;
input bool InpCloseOnOppositeSignal=true;

input group "Position management"
input bool InpUseBreakEven=true;
input double InpBreakEvenAtR=1.0;
input double InpBreakEvenOffsetPoints=5.0;
input bool InpUseATRTrail=true;
input double InpTrailATR=2.0;
input int InpMaxBarsInTrade=120;

CTrade trade;
int fast_handle=INVALID_HANDLE,slow_handle=INVALID_HANDLE;
int adx_handle=INVALID_HANDLE,rsi_handle=INVALID_HANDLE,atr_handle=INVALID_HANDLE;
datetime last_bar=0;
datetime current_day=0;
double day_start_equity=0.0,peak_equity=0.0;
int trades_today=0;
bool circuit_breaker=false;

datetime DayStart(datetime value)
{
   MqlDateTime dt;
   TimeToStruct(value,dt);
   dt.hour=0; dt.min=0; dt.sec=0;
   return StructToTime(dt);
}

void RefreshRiskState()
{
   const datetime today=DayStart(TimeCurrent());
   if(today!=current_day)
   {
      current_day=today;
      day_start_equity=AccountInfoDouble(ACCOUNT_EQUITY);
      trades_today=0;
   }
   const double equity=AccountInfoDouble(ACCOUNT_EQUITY);
   if(equity>peak_equity) peak_equity=equity;
   if(peak_equity>0.0)
   {
      const double dd=100.0*(peak_equity-equity)/peak_equity;
      if(dd>=InpMaxEquityDrawdownPct) circuit_breaker=true;
   }
}

bool DailyLossExceeded()
{
   if(day_start_equity<=0.0) return false;
   const double equity=AccountInfoDouble(ACCOUNT_EQUITY);
   return 100.0*(day_start_equity-equity)/day_start_equity>=InpMaxDailyLossPct;
}

bool ReadIndicators(double &fast1,double &fast2,double &slow1,double &slow2,
                    double &adx1,double &rsi1,double &atr1)
{
   double a[2],b[2],c[1],d[1],e[1];
   if(CopyBuffer(fast_handle,0,1,2,a)!=2) return false;
   if(CopyBuffer(slow_handle,0,1,2,b)!=2) return false;
   if(CopyBuffer(adx_handle,0,1,1,c)!=1) return false;
   if(CopyBuffer(rsi_handle,0,1,1,d)!=1) return false;
   if(CopyBuffer(atr_handle,0,1,1,e)!=1) return false;
   fast2=a[0]; fast1=a[1]; slow2=b[0]; slow1=b[1];
   adx1=c[0]; rsi1=d[0]; atr1=e[0];
   return atr1>0.0;
}

int Signal(double &atr)
{
   double fast1,fast2,slow1,slow2,adx,rsi;
   if(!ReadIndicators(fast1,fast2,slow1,slow2,adx,rsi,atr)) return 0;
   const double close1=iClose(_Symbol,InpSignalTimeframe,1);
   if(close1<=0.0 || adx<InpMinADX) return 0;
   const bool rising=fast1>fast2;
   const bool falling=fast1<fast2;
   if(InpAllowLong && fast1>slow1 && close1>fast1 && rising && rsi>=InpLongRSIMin) return 1;
   if(InpAllowShort && fast1<slow1 && close1<fast1 && falling && rsi<=InpShortRSIMax) return -1;
   return 0;
}

bool SelectOwnPosition()
{
   if(!PositionSelect(_Symbol)) return false;
   return (ulong)PositionGetInteger(POSITION_MAGIC)==InpMagicNumber;
}

void CloseOwnPosition(const string reason)
{
   if(!SelectOwnPosition()) return;
   if(!trade.PositionClose(_Symbol))
      Print("Close failed [",reason,"]: ",trade.ResultRetcodeDescription());
}

void ManagePosition(const double atr)
{
   if(!SelectOwnPosition()) return;
   const ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
   const double open=PositionGetDouble(POSITION_PRICE_OPEN);
   const double old_sl=PositionGetDouble(POSITION_SL);
   const double tp=PositionGetDouble(POSITION_TP);
   const datetime opened=(datetime)PositionGetInteger(POSITION_TIME);
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick)) return;
   const double price=(type==POSITION_TYPE_BUY ? tick.bid : tick.ask);
   const double initial_r=(tp>0.0 && InpTakeProfitR>0.0) ? MathAbs(tp-open)/InpTakeProfitR : InpStopATR*atr;
   double new_sl=old_sl;

   if(InpUseBreakEven && initial_r>0.0)
   {
      const bool trigger=(type==POSITION_TYPE_BUY ? price-open : open-price)>=InpBreakEvenAtR*initial_r;
      if(trigger)
      {
         const double offset=InpBreakEvenOffsetPoints*_Point;
         const double be=(type==POSITION_TYPE_BUY ? open+offset : open-offset);
         if(type==POSITION_TYPE_BUY && (new_sl==0.0 || be>new_sl)) new_sl=be;
         if(type==POSITION_TYPE_SELL && (new_sl==0.0 || be<new_sl)) new_sl=be;
      }
   }
   if(InpUseATRTrail && atr>0.0)
   {
      const double trail=(type==POSITION_TYPE_BUY ? price-InpTrailATR*atr : price+InpTrailATR*atr);
      if(type==POSITION_TYPE_BUY && trail>open && (new_sl==0.0 || trail>new_sl)) new_sl=trail;
      if(type==POSITION_TYPE_SELL && trail<open && (new_sl==0.0 || trail<new_sl)) new_sl=trail;
   }
   new_sl=AtlasNormalizePrice(_Symbol,new_sl);
   if(new_sl>0.0 && MathAbs(new_sl-old_sl)>=_Point)
      if(!trade.PositionModify(_Symbol,new_sl,tp)) Print("Modify failed: ",trade.ResultRetcodeDescription());

   const int seconds=PeriodSeconds(InpSignalTimeframe);
   if(InpMaxBarsInTrade>0 && seconds>0 && (TimeCurrent()-opened)>=InpMaxBarsInTrade*seconds)
      CloseOwnPosition("time exit");
}

bool StopsValid(const ENUM_ORDER_TYPE type,const double entry,const double sl,const double tp)
{
   const double min_distance=(double)SymbolInfoInteger(_Symbol,SYMBOL_TRADE_STOPS_LEVEL)*_Point;
   if(type==ORDER_TYPE_BUY) return entry-sl>=min_distance && tp-entry>=min_distance;
   return sl-entry>=min_distance && entry-tp>=min_distance;
}

void OpenTrade(const int direction,const double atr)
{
   MqlTick tick;
   if(!SymbolInfoTick(_Symbol,tick)) return;
   const ENUM_ORDER_TYPE type=(direction>0 ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
   const double entry=(direction>0 ? tick.ask : tick.bid);
   const double risk_distance=InpStopATR*atr;
   double sl=(direction>0 ? entry-risk_distance : entry+risk_distance);
   double tp=(direction>0 ? entry+InpTakeProfitR*risk_distance : entry-InpTakeProfitR*risk_distance);
   sl=AtlasNormalizePrice(_Symbol,sl);
   tp=AtlasNormalizePrice(_Symbol,tp);
   if(!StopsValid(type,entry,sl,tp)) return;
   const double risk_money=AccountInfoDouble(ACCOUNT_EQUITY)*InpRiskPerTradePct/100.0;
   const double volume=AtlasRiskVolume(_Symbol,type,entry,sl,risk_money);
   if(volume<=0.0) return;
   bool sent=false;
   if(direction>0) sent=trade.Buy(volume,_Symbol,0.0,sl,tp,"Atlas long");
   else sent=trade.Sell(volume,_Symbol,0.0,sl,tp,"Atlas short");
   if(sent) trades_today++;
   else Print("Entry failed: ",trade.ResultRetcodeDescription());
}

int OnInit()
{
   if(InpFastEMA<=0 || InpSlowEMA<=InpFastEMA || InpATRPeriod<=0 ||
      InpStopATR<=0.0 || InpTakeProfitR<=0.0 || InpRiskPerTradePct<=0.0) return INIT_PARAMETERS_INCORRECT;
   fast_handle=iMA(_Symbol,InpSignalTimeframe,InpFastEMA,0,MODE_EMA,PRICE_CLOSE);
   slow_handle=iMA(_Symbol,InpSignalTimeframe,InpSlowEMA,0,MODE_EMA,PRICE_CLOSE);
   adx_handle=iADX(_Symbol,InpSignalTimeframe,InpADXPeriod);
   rsi_handle=iRSI(_Symbol,InpSignalTimeframe,InpRSIPeriod,PRICE_CLOSE);
   atr_handle=iATR(_Symbol,InpSignalTimeframe,InpATRPeriod);
   if(fast_handle==INVALID_HANDLE || slow_handle==INVALID_HANDLE || adx_handle==INVALID_HANDLE ||
      rsi_handle==INVALID_HANDLE || atr_handle==INVALID_HANDLE) return INIT_FAILED;
   trade.SetExpertMagicNumber(InpMagicNumber);
   trade.SetDeviationInPoints(InpSlippagePoints);
   trade.SetTypeFillingBySymbol(_Symbol);
   current_day=DayStart(TimeCurrent());
   day_start_equity=AccountInfoDouble(ACCOUNT_EQUITY);
   peak_equity=day_start_equity;
   return INIT_SUCCEEDED;
}

void OnDeinit(const int reason)
{
   if(fast_handle!=INVALID_HANDLE) IndicatorRelease(fast_handle);
   if(slow_handle!=INVALID_HANDLE) IndicatorRelease(slow_handle);
   if(adx_handle!=INVALID_HANDLE) IndicatorRelease(adx_handle);
   if(rsi_handle!=INVALID_HANDLE) IndicatorRelease(rsi_handle);
   if(atr_handle!=INVALID_HANDLE) IndicatorRelease(atr_handle);
}

void OnTick()
{
   RefreshRiskState();
   double atr=0.0;
   const int direction=Signal(atr);
   ManagePosition(atr);
   if(!AtlasIsNewBar(_Symbol,InpSignalTimeframe,last_bar)) return;
   if(SelectOwnPosition())
   {
      const ENUM_POSITION_TYPE type=(ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
      if(InpCloseOnOppositeSignal && ((type==POSITION_TYPE_BUY && direction<0) ||
                                     (type==POSITION_TYPE_SELL && direction>0))) CloseOwnPosition("opposite signal");
      return;
   }
   if(direction==0 || circuit_breaker || DailyLossExceeded() || trades_today>=InpMaxTradesPerDay) return;
   if(!AtlasInSession(InpSessionStartHour,InpSessionEndHour)) return;
   if(AtlasSpreadPoints(_Symbol)>InpMaxSpreadPoints) return;
   OpenTrade(direction,atr);
}

double OnTester()
{
   const double profit=TesterStatistics(STAT_PROFIT);
   const double pf=TesterStatistics(STAT_PROFIT_FACTOR);
   const double dd=TesterStatistics(STAT_EQUITY_DDREL_PERCENT);
   const double trades=TesterStatistics(STAT_TRADES);
   if(profit<=0.0 || pf<1.0 || trades<60.0 || dd>=30.0) return -1000000.0-dd;
   return profit*MathMin(pf,3.0)*MathSqrt(trades)/(1.0+dd*dd);
}
