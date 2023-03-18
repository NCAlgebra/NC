// Mark Stankus 1999 (c)
// MoraStats.c

#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "stringGB.hpp"
#include "GeneralMora.hpp"
#include "GBStream.hpp"

#include "vcpp.hpp"

void _ClearMoraStat(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  if(x.value()=="spolyomials") {
    s_number_of_spolynomials = 0; 
  } else if(x.value()=="reductionstar") {
    s_number_of_reductionstar = 0;
  } else if(x.value()=="reduction_didreduce") {
    s_number_of_reduction_didreduce = 0;
  } else if(x.value()=="reduction_didnotreduce") {
    s_number_of_reduction_didnotreduce = 0;
  } else if(x.value()=="all") {
    s_number_of_spolynomials = 0; 
    s_number_of_reductionstar = 0;
    s_number_of_reduction_didreduce = 0;
    s_number_of_reduction_didnotreduce = 0;
  } else DBG();
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp2SetMLex("ClearMoraStat",1,_ClearMoraStat);

void _GetMoraStat(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  so.shouldBeEnd();
  if(x.value()=="spolyomials") {
    si << s_number_of_spolynomials; 
  } else if(x.value()=="reductionstar") {
    si << s_number_of_reductionstar;
  } else if(x.value()=="reduction_didreduce") {
    si << s_number_of_reduction_didreduce;
  } else if(x.value()=="reduction_didnotreduce") {
    si << s_number_of_reduction_didnotreduce;
  } else if(x.value()=="all") {
    symbolGB L("List");
    Sink si2(si.outputFunction(L,4L));
    si2 << s_number_of_spolynomials << s_number_of_reductionstar 
        << s_number_of_reduction_didreduce << s_number_of_reduction_didnotreduce;
  } else DBG();
};

AddingCommand temp3SetMLex("GetMoraStat",1,_GetMoraStat);

void _PrintMoraStat(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  if(x.value()=="spolyomials") {
    GBStream << s_number_of_spolynomials; 
  } else if(x.value()=="reductionstar") {
    GBStream << s_number_of_reductionstar;
  } else if(x.value()=="reduction_didreduce") {
    GBStream << s_number_of_reduction_didreduce;
  } else if(x.value()=="reduction_didnotreduce") {
    GBStream << s_number_of_reduction_didnotreduce;
  } else if(x.value()=="all") {
    GBStream << "s_number_of_spolynomials: " 
             << s_number_of_spolynomials << '\n'; 
    GBStream << "s_number_of_reductionstar: " 
             << s_number_of_reductionstar << '\n';
    GBStream << "s_number_of_reduction_didreduce: " 
             << s_number_of_reduction_didreduce << '\n';
    GBStream << "s_number_of_reduction_didnotreduce: " 
             << s_number_of_reduction_didnotreduce << '\n';
  } else DBG();
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp4SetMLex("PrintMoraStat",0,_PrintMoraStat);
