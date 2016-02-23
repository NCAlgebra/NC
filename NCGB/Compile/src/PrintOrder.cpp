// PrintOrder.c

#include "GBIO.hpp"
#include "GBStream.hpp"
#include "Command.hpp"
#include "Source.hpp"
#include "Sink.hpp"

 
void _PrintOrder(Source & so,Sink & si) {
  so.shouldBeEnd();
  AdmissibleOrder::s_getCurrent().PrintOrder(GBStream);
  si.noOutput();
}; 

AddingCommand temp1PrintOrder("PrintOrder",0,_PrintOrder);
