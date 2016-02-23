// Mark Stankus 1999 (c)
// RegRecipients.cpp

#include "GBStream.hpp"
#include "tPool.hpp"
#include "tdPool.hpp"
#include "ICopy.hpp"
#include "Tag.hpp"
#include "RuleID.hpp"
#include "PDReduction.hpp"
#include "PDPolySource.hpp"
#include "GBList.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "ReportReduced.hpp"
#include "PrintGBList.hpp"
#include "Command.hpp"
#include "Polynomial.hpp"
#include "GBList.hpp"
#include "BroadCast.hpp"
#include "Debug1.hpp"
#include "GBLoop.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "stringGB.hpp"
#include "Ownership.hpp"
#include "Names.hpp"
#include "GBHistory.hpp"
#include "RecordHistory.hpp"
#include "Commands.hpp"
#include "RecordToPolySource.hpp"
#include "RecordToReduction.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif




void _AddDefaultToPool(Source & so,Sink & si) {
  stringGB pool_name,item_name;
  so >> pool_name >> item_name;
  so.shouldBeEnd();
  si.noOutput();
  Names::s_add(item_name.value().chars(),pool_name.value().chars());
};

AddingCommand temp1RegisterRecipients("AddDefaultToPool",2,_AddDefaultToPool);

void _RemoveFromPool(Source & so,Sink & si) {
  stringGB pool_name,item_name;
  so >> item_name;
  so.shouldBeEnd();
  si.noOutput();
  Names::s_remove(item_name.value().chars());
};

AddingCommand temp1aRegisterRecipients("RemoveFromPool",1,_RemoveFromPool);

void _IncludeReportReduced(Source & so,Sink & si) {
  stringGB broadcast_name;
  so >> broadcast_name;
  so.shouldBeEnd();
  si.noOutput();
  BroadCast * p = (BroadCast *) Names::s_lookup_error(GBStream,
         broadcast_name.value().chars(),"BroadCast").ptr();
  if(p) {
    ICopy<Recipient> item(new ReportReduced(GBStream),Adopt::s_dummy);
    p->d_L.push_back(item);
  } else {
    GBStream << "Reporting of the reduced polynomials not accepted.\n";
  };
};

AddingCommand temp2RegisterRecipients("IncludeReportReduced",1,
                           _IncludeReportReduced);

void _PrintPolySource(Source & so,Sink & si) {
  stringGB polysource_name;
  so >> polysource_name;
  so.shouldBeEnd();
  si.noOutput();
  PolySource * ps_p = (PolySource *) Names::s_lookup_error(GBStream,
            polysource_name.value().chars(),"PolySource").ptr();
  if(!!ps_p) {
    ps_p->print(GBStream);
  } else {
    GBStream << "Printing of the reduced polynomials not accepted.\n";
  };
};

AddingCommand temp2aRegisterRecipients("PrintPolySource",1,
                           _PrintPolySource);

void _IncludeRecordPolynomialPolySource(Source & so,Sink & si) {
  stringGB broadcast_name,polysource_name;
  so >> broadcast_name >> polysource_name;
  so.shouldBeEnd();
  si.noOutput();
  BroadCast * bro_p = (BroadCast *) Names::s_lookup_error(GBStream,
           broadcast_name.value().chars(),"BroadCast").ptr();
  PolySource * ps_p = (PolySource *) Names::s_lookup_error(GBStream,
             polysource_name.value().chars(),"PolySource").ptr();
  if(!!bro_p && !!ps_p) {
    ICopy<Recipient> item(new RecordToPolySource(*ps_p),Adopt::s_dummy);
    bro_p->d_L.push_back(item);
  } else {
    GBStream << "Reporting of the reduced polynomials not accepted.\n";
  };
};

AddingCommand temp2bRegisterRecipients("IncludeRecordPolynomialPolySource",2,
                           _IncludeRecordPolynomialPolySource);

void _IncludeRecordReduce(Source & so,Sink & si) {
  stringGB broadcast_name,reduction_name;
  so >> broadcast_name >> reduction_name;
  so.shouldBeEnd();
  si.noOutput();
  BroadCast * p = (BroadCast *) Names::s_lookup_error(GBStream,
          broadcast_name.value().chars(),"BroadCast").ptr();
  Reduction * q = (Reduction *) Names::s_lookup_error(GBStream,
          reduction_name.value().chars(),"Reduction").ptr();
  if(!!p && !!q) {
    ICopy<Recipient> item(new RecordToReduction(*q),Adopt::s_dummy);
    p->d_L.push_back(item);
  } else {
    GBStream << "Reporting of the reduced polynomials not accepted.\n";
  };
};

AddingCommand temp2cRegisterRecipients("IncludeRecordReduce",1,
                           _IncludeRecordReduce);

void _IncludeRecordGBHistory(Source & so,Sink & si) {
  stringGB broadcast_name, gbhistory_name;
  so >> broadcast_name >> gbhistory_name;
  so.shouldBeEnd();
  si.noOutput();
  list<GBHistory> * p = (list<GBHistory> *) Names::s_lookup_error(GBStream,
         gbhistory_name.value().chars(),"list<GBHistory>").ptr();
  BroadCast * bro = (BroadCast *) Names::s_lookup_error(GBStream,
             broadcast_name.value().chars(),"BroadCast").ptr();
  if(p) {
    ICopy<Recipient> item(new RecordHistory(*p),Adopt::s_dummy);
    bro->d_L.push_back(item);
  } else {
    GBStream << "Recording of history not accepted.\n";
  };
};

AddingCommand temp3RegisterRecipients("IncludeRecordGBHistory",1,
                           _IncludeRecordGBHistory);

bool InternalCallGBLoop(int num,
     const simpleString & poly_source_name,
     const simpleString &  poly_source_tag_name,
     const simpleString &  reduce_name,
     const simpleString &  reduce_tag_name,
     const simpleString &  broadcast_name,
     const simpleString &  giveNumber_name) {
  GBStream << "Calling GBLoop with " << poly_source_name
       << ' ' << poly_source_tag_name << ' ' << reduce_name
       << ' ' << reduce_tag_name << ' ' << broadcast_name 
       << ' ' << giveNumber_name << '\n';
  PolySource * poly_source_p = (PolySource *) Names::s_lookup_error(GBStream,
         poly_source_name.chars(),"PolySource").ptr();
  Tag * polysource_tag_p =  (Tag *) Names::s_lookup_error(GBStream,
         poly_source_tag_name.chars(),"Tag").ptr();
  Reduction * reduce_p = (Reduction *) Names::s_lookup_error(GBStream,
         reduce_name.chars(),"Reduction").ptr();
  Tag * reduce_tag_p =  (Tag *) Names::s_lookup_error(GBStream,
         reduce_tag_name.chars(),"Tag").ptr();
  BroadCast * broadcast_p = (BroadCast *) Names::s_lookup_error(GBStream,
         broadcast_name.chars(),"BroadCast").ptr();
  GiveNumber * give_p = (GiveNumber *) Names::s_lookup_error(GBStream,
         giveNumber_name.chars(),"GiveNumber").ptr();
  bool foundSomething = false;
  if(!!poly_source_p &&!!polysource_tag_p && !!reduce_p && 
     !!reduce_tag_p && !!broadcast_p) {
    GBStream << "Initial Clean Up\n";
    GBLoop(*poly_source_p,*polysource_tag_p,*reduce_p,reduce_tag_p,
           *broadcast_p,foundSomething,*give_p);
    for(int i=1;i<=num;++i) {
      GBStream << "Starting iteration " << i << " of " << num << '\n';
      poly_source_p->fillForUnknownReason();
      GBLoop(*poly_source_p,*polysource_tag_p,*reduce_p,reduce_tag_p,
           *broadcast_p,foundSomething,*give_p);
      GBStream << "Ending iteration " << i << " of " << num << '\n';
    };
  } else {
    GBStream << "GBLoop not run due to above mentioned error(s).\n";
  };
  return foundSomething;
};


void _CallGBLoop(Source & so,Sink & si) {
  stringGB poly_source_name,poly_source_tag_name,
           reduce_name,reduce_tag_name,
           broadcast_name,giveNumber_name;
  int num;
  so >> num >> poly_source_name >> poly_source_tag_name >> reduce_name 
     >> reduce_tag_name >> broadcast_name >> giveNumber_name;
  so.shouldBeEnd();
  si << InternalCallGBLoop(num,poly_source_name.value(),
        poly_source_tag_name.value(),
        reduce_name.value(),reduce_tag_name.value(),
        broadcast_name.value(),giveNumber_name.value());
};

AddingCommand temp4RegisterRecipients("CallGBLoop",7,_CallGBLoop);

void _PrintPoolNames(Source & so,Sink & si) {
  stringGB pool_name;
  so >> pool_name;
  so.shouldBeEnd();
  si.noOutput();
  Names::s_listPool(GBStream,pool_name.value().chars());
};

AddingCommand temp5RegisterRecipients("PrintPoolNames",1,_PrintPoolNames);

void _PrintAllPools(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  Names::s_listPools(GBStream);
};

AddingCommand temp6RegisterRecipients("PrintAllPools",0,_PrintPoolNames);

void _AddPolynomialsToGBListPool(Source & so,Sink & si) {
  stringGB name;
  so >> name;
  GBList<Polynomial> * ptr = (GBList<Polynomial> *)  
        Names::s_lookup(name.value().chars(),"GBList<Polynomial>").ptr();
  Polynomial p;
  if(ptr) {
    Source so2(so.inputNamedFunction("List"));
    while(!so2.eoi()) {
      so2 >> p;
      ptr->push_back(p);     
    };
  } else {
    GBStream << "The name \"" << name << "\" is not recognized.\n";
    DBG();
  };
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp7RegisterRecipients("AddPolynomialsToGBListPool",2,
             _AddPolynomialsToGBListPool);

void _PrintPolynomialGBList(Source & so,Sink & si) {
  stringGB name;
  so >> name;
  GBList<Polynomial> * ptr = (GBList<Polynomial> *) 
      Names::s_lookup(name.value().chars(),"GBList<Polynomial>").ptr();
  Polynomial p;
  if(ptr) {
    PrintGBList(name.value().chars(),*ptr);
  } else {
    GBStream << "Cannot print the polynomials with the name \""
             << name << "\"\n";
  };
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp8RegisterRecipients("PrintPolynomialGBList",1,
  _PrintPolynomialGBList);

void _CreateReduceTagInfinity(Source & so,Sink & si) {
  stringGB tag_name;
  so >> tag_name;
  so.shouldBeEnd();
  si.noOutput();
  IntTag * p = new IntTag;
  tdPool<IntTag> * pl = new tdPool<IntTag>(p);
  Names::s_add(tag_name.value().chars(),pl);
};

AddingCommand temp11RegisterRecipients("CreateReduceTagInfinity",1,
     _CreateReduceTagInfinity);

void _CreatePolySourceTagInfinity(Source & so,Sink & si) {
  stringGB tag_name;
  so >> tag_name;
  so.shouldBeEnd();
  si.noOutput();
  IntTag * p = new IntTag;
  tdPool<IntTag> * pl = new tdPool<IntTag>(p);
  Names::s_add(tag_name.value().chars(),pl);
};

AddingCommand temp12RegisterRecipients("CreatePolySourceTagInfinity",1,
     _CreatePolySourceTagInfinity);
