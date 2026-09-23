#ifndef __ATLAS_TRADE_GUARDS_MQH__
#define __ATLAS_TRADE_GUARDS_MQH__

bool AtlasIsNewBar(const string symbol,const ENUM_TIMEFRAMES timeframe,datetime &last_bar)
{
   const datetime current=iTime(symbol,timeframe,0);
   if(current<=0 || current==last_bar) return false;
   last_bar=current;
   return true;
}

double AtlasSpreadPoints(const string symbol)
{
   MqlTick tick;
   const double point=SymbolInfoDouble(symbol,SYMBOL_POINT);
   if(point<=0.0 || !SymbolInfoTick(symbol,tick)) return DBL_MAX;
   return (tick.ask-tick.bid)/point;
}

bool AtlasInSession(const int start_hour,const int end_hour)
{
   MqlDateTime now;
   TimeToStruct(TimeCurrent(),now);
   if(start_hour==end_hour) return true;
   if(start_hour<end_hour) return now.hour>=start_hour && now.hour<end_hour;
   return now.hour>=start_hour || now.hour<end_hour;
}

#endif
