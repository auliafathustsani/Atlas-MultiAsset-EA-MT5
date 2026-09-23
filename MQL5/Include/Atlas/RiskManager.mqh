#ifndef __ATLAS_RISK_MANAGER_MQH__
#define __ATLAS_RISK_MANAGER_MQH__

double AtlasNormalizePrice(const string symbol,const double price)
{
   const int digits=(int)SymbolInfoInteger(symbol,SYMBOL_DIGITS);
   return NormalizeDouble(price,digits);
}

double AtlasNormalizeVolume(const string symbol,double volume)
{
   const double min_volume=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MIN);
   const double max_volume=SymbolInfoDouble(symbol,SYMBOL_VOLUME_MAX);
   const double step=SymbolInfoDouble(symbol,SYMBOL_VOLUME_STEP);
   if(step<=0.0) return 0.0;
   volume=MathMax(min_volume,MathMin(max_volume,volume));
   volume=MathFloor(volume/step+1e-8)*step;
   int digits=0;
   double probe=step;
   while(digits<8 && MathRound(probe)!=probe){ probe*=10.0; digits++; }
   return NormalizeDouble(volume,digits);
}

double AtlasRiskVolume(const string symbol,const ENUM_ORDER_TYPE order_type,
                       const double entry,const double stop,const double risk_money)
{
   if(risk_money<=0.0 || entry<=0.0 || stop<=0.0 || entry==stop) return 0.0;
   double pnl_one_lot=0.0;
   if(!OrderCalcProfit(order_type,symbol,1.0,entry,stop,pnl_one_lot)) return 0.0;
   const double loss_one_lot=MathAbs(pnl_one_lot);
   if(loss_one_lot<=0.0) return 0.0;
   return AtlasNormalizeVolume(symbol,risk_money/loss_one_lot);
}

#endif
