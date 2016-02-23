// Mark Stankus 1999 (c)
// SFSGRecipients.cpp

#include "stringGB.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "SFSGPolySource.hpp"
#include "SFSGReduction.hpp"
#include "tPool.hpp"
#include "Command.hpp"

void _CreateSFSGPolySource(Source & so,Sink & si) {
  stringGB bimap_name , source_name, polys_name;
  so >> bimap_name >> source_name >> polys_name;   
  so.shouldBeEnd();
  si.noOutput();
  BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible> * bimap_p = 
      (BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible> *) 
      Names::s_lookup_error(GBStream,bimap_name.value().chars(),"BiMap").ptr();
  SFSGPolySource * ps = new SFSGPolySource(*bimap_p);
  GBList<Polynomial> * L = (GBList<Polynomial> *) Names::s_lookup_error(
     GBStream,polys_name.value().chars(),"GBList<Polynomial>").ptr();
  GBList<Polynomial>::const_iterator w = L->begin(), e = L->end();
  while(w!=e) {
    ps->insert(*w);
    GBStream << "Inserted:" << *w << '\n';
    ++w;
  };
  tPool<SFSGPolySource> * pl = new tPool<SFSGPolySource>(ps);
  Names::s_add(source_name.value().chars(),pl);
};

AddingCommand temp9bRegisterRecipients("CreateSFSGPolySource",3,
     _CreateSFSGPolySource);

void _CreateSFSGReduction(Source & so,Sink & si) {
  stringGB bimap_name, red_name;
  so >> bimap_name >> red_name;  
  so.shouldBeEnd();
  si.noOutput();
  BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible> * bimap_p = 
      (BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible> *) 
      Names::s_lookup_error(GBStream,bimap_name.value().chars(),"BiMap").ptr();
  SFSGReduction * ps = new SFSGReduction(*bimap_p);
  tPool<SFSGReduction> * pl = new tPool<SFSGReduction>(ps);
  Names::s_add(red_name.value().chars(),pl);
};

AddingCommand temp9cRegisterRecipients("CreateSFSGReduction",2,
     _CreateSFSGReduction);

#if 0
void _PrintTipDistinct(Source & so,Sink & si) {
  stringGB tip_distinct_name;
  so >> tip_distinct_name;  
  so.shouldBeEnd();
  si.noOutput();
  TipDistinct * tip_p = (TipDistinct *) Names::s_lookup_error(GBStream,
       tip_distinct_name.value().chars(),"TipDistinct").ptr();
  GBStream << "\n\n\nAll:\n";
  tip_p->print(GBStream);
  GBStream << "\n\n\nSome:\n";
  tip_p->printSmall(GBStream);
};

AddingCommand temp1cSFSGRecipients("PrintTipDistinct",1,_PrintTipDistinct);
#endif

void _PrintBiMap(Source & so,Sink & si) {
  stringGB bimap_name;
  so >> bimap_name;  
  so.shouldBeEnd();
  si.noOutput();
  BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible> * bimap_p = 
      (BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible> *) 
      Names::s_lookup_error(GBStream,bimap_name.value().chars(),"BiMap").ptr();
  bimap_p->print(GBStream);
};

AddingCommand temp1dSFSGRecipients("PrintBiMap",1,_PrintBiMap);

#include "Choice.hpp"
#ifdef USE_UNIX
#include "tPool.c"
#else
#include "tPool.cpp"
#endif

#include "SFSGPolySource.hpp"
#include "SFSGReduction.hpp"

const char * tPool<SFSGPolySource>::s_poolname = "SFSGPolySource";
const char * tPool<SFSGReduction>::s_poolname = "SFSGReduction";

template class tPool<SFSGPolySource>;
template class tPool<SFSGReduction>;

AddPool temp4tPool("SFSGPolySource",new tPool<SFSGPolySource>);
AddPool temp5tPool("SFSGReduction",new tPool<SFSGReduction>);
