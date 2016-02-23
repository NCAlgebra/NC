// Mark Stankuc 1999 (c)
// FCRecipients.c

#include "GBStream.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "CntSource.hpp"
#include "Ownership.hpp"
#include "FactControl.hpp"
#include "TripleList.hpp"
#include "PDPolySource.hpp"
#include "PDReduction.hpp"
#include "GBList.hpp"
#include "Polynomial.hpp"
#include "FCGiveNumber.hpp"
#include "SetSource.hpp"
#include "MyOstream.hpp"
#include "stringGB.hpp"
#include "Names.hpp"
#include "tPool.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif

TripleList<int> * s_TripleList = 0;

void _CreatePolySource(Source & so,Sink & si) {
  if(!s_TripleList) {
    s_TripleList = new TripleList<int>;
  };
  int count;
  stringGB poly_name, source_name, givenumber_name;
  so >> count >> poly_name >> source_name >> givenumber_name;  
  so.shouldBeEnd();
  si.noOutput();
  GBList<Polynomial> * p = (GBList<Polynomial> *) Names::s_lookup_error(
      GBStream, poly_name.value().chars(),"GBList<Polynomial>").ptr();
  GiveNumber * give_p = (GiveNumber *) Names::s_lookup_error(GBStream,
       givenumber_name.value().chars(),"GiveNumber").ptr();
  if(!!p && !!give_p) {
    typedef GBList<Polynomial>::const_iterator LI;
    LI w = p->begin(), e = p->end();
    GroebnerRule ru;
    set<RuleID,less<RuleID> > inactive,active;
    int num;
    while(w!=e) {
      const Polynomial & poly = *w;
      num = (*give_p)(poly);
      give_p->setPerm(num);
      s_TripleList->addItem(num);
      RuleID id(poly,num);
      active.insert(id);
      ++w;
    }; 
    ICopy<SetSource<pair<int,int> > > ic((*s_TripleList)());
    SetSource<pair<int,int> > * cnt = new 
       CntSource<pair<int,int>,TripleList<int> >(count,ic,*s_TripleList);
    ICopy<SetSource<pair<int,int> > > icc(cnt,Adopt::s_dummy);
    PDPolySource * ps = new PDPolySource(*give_p,
         active,inactive,icc);
    tPool<PolySource> * pl = new tPool<PolySource>(ps);
    Names::s_add(source_name.value().chars(),pl);
  } else {
    GBStream << "Cannot execute command due to error. (See above).\n";
  };
};

AddingCommand temp1FCRecipients("CreatePolySource",3,_CreatePolySource);

void _CreateFCNumber(Source & so,Sink & si) {
  stringGB give_name,fc_name;
  so >> give_name >> fc_name;
  so.shouldBeEnd();
  si.noOutput();
  FactControl * fc_p = (FactControl *) Names::s_lookup_error(GBStream,
      fc_name.value().chars(),"FactControl").ptr();
  FCGiveNumber * fcgive_p = new FCGiveNumber(*fc_p);
  tPool<GiveNumber> * pl = new tPool<GiveNumber>(fcgive_p);
  Names::s_add(give_name.value().chars(),pl);
};

AddingCommand temp2FCRecipients("CreateFCNumber",2,_CreateFCNumber);

#if 0
void _CreateCounterGiveNumber(Source & so,Sink & si) {
  stringGB give_name, poly_source_name;
  so >> give_name >> poly_source_name;
  so.shouldBeEnd();
  si.noOutput();
  PolySource * ps_p = (PolySource * )Names>::s_lookup_error(GBStream,
      poly_source_name.value().chars(),"PolySource").ptr();
  if(ps_p->ID()!=CommonPolynomials::s_ID) DBG();
  CommonPolynomials * cp_p = (CommonPolynomials *) ps_p;
  // This is a MEMORY LEAK!!! Mark Stankus MXS
  CounterGiveNumber * thegive_p = new CounterGiveNumber(*cp_p,new int(1));
  tPool<PolySource> * pl = new tPool<
  Names::s_add(give_name.value().chars(),pl);
};

AddingCommand temp3FCRecipients("CreateCounterGiveNumber",2, 
                                _CreateCounterGiveNumber);
#endif

void _PrintAnswer(Source & so,Sink & si) {
  stringGB fc_name;
  so >> fc_name;
  so.shouldBeEnd();
  si.noOutput();
  FactControl * fc_p = (FactControl *) Names::s_lookup_error(GBStream,
         fc_name.value().chars(),"FactControl").ptr();
  if(!fc_p) DBG();
  int num = fc_p->numberOfFacts();
  GBStream << "There are  " << num << " facts.\n";
  const GBList<int> & L = fc_p->indicesOfPermanentFacts();
  GBList<int>::const_iterator w = L.begin();
  const int sz = L.size();
  GBStream << "There are  " << sz << " permanent facts.\n";
  for(int i=1;i<=sz;++i,++w) {
    GBStream << fc_p->fact(*w) << '\n';
  };
};

AddingCommand temp4FCRecipients("PrintAnswer",2,_PrintAnswer);

void _CreateReduction(Source & so,Sink & si) {
  stringGB reduce_name,giveNumber_name;
  so >> reduce_name >> giveNumber_name;  
  GiveNumber * give_p = (GiveNumber *) Names::s_lookup_error(GBStream,giveNumber_name.value().chars(),"GiveNumber").ptr();
  if(!give_p) DBG();
  so.shouldBeEnd();
  si.noOutput();
  PDReduction * p = new PDReduction(*give_p);
  if(!!p) {
    const vector<int> & V = give_p->perm_numbers();
    vector<int>::const_iterator w = V.begin(), e = V.end();
    while(w!=e) {
      SPIID id(*w);
      p->addFact(id);
      ++w;
    };
    tPool<Reduction> * pl = new tPool<Reduction>(p);
    Names::s_add(reduce_name.value().chars(),pl);
  } else {
    DBG();
  };
};

AddingCommand temp5FCRecipients("CreateReduction",2,_CreateReduction);

#ifdef USE_UNIX
#include "tPool.c"
#else
#include "tPool.cpp"
#endif
const char * tPool<GiveNumber>::s_poolname = "GiveNumber";
const char * tPool<PolySource>::s_poolname = "PolySource";
const char * tPool<Reduction>::s_poolname = "Reduction";

template class tPool<GiveNumber>;
template class tPool<PolySource>;
template class tPool<Reduction>;

AddPool temp1tFCRec("GiveNumber",new tPool<GiveNumber>);
AddPool temp2tFCRec("PolySource",new tPool<PolySource>);
AddPool temp3tFCRec("Reduction",new tPool<Reduction>);
