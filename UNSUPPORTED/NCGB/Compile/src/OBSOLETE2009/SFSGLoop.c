// Mark Stankus 1999 (c)
// SFSGLoop.cpp



#include "GBInput.hpp"
#include "stringGB.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "SFSGRules.hpp"
#include "MyOstream.hpp"
#include "Names.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

void SFSGHelp(SFSGRules & polys) {
  bool nonzero;
  list<SFSGEntry*>::iterator w = polys.current();
  while(!polys.isend(w)) {
    polys.inList(w);
    GBStream << '.';
    nonzero = polys.dumbReduction(w,true);
    if(nonzero) {
      GBStream << "\n(" << polys.size() << "):";
#if 0
      polys.markRecent(w);
      ++w;
#endif
    };
  };
};

void SFSGLoop(int n,SFSGRules & polys,bool & foundSomething) {
  GBStream << "Initial cleanup.\n";
  bool todo = true;
  SFSGHelp(polys);
  while(n>=0 && todo) {
    GBStream << n << " iterations remaining\n";
    todo = polys.fill();
    SFSGHelp(polys);
    --n;
  };
};

void _SFSG(Source & so,Sink & si) {
  int n;
  stringGB sfsgname;
  bool b;
  so >> b >> n >> sfsgname;
  so.shouldBeEnd();
  SFSGRules * p = (SFSGRules *) Names::s_lookup_error(GBStream,
        sfsgname.value().chars(),"SFSRules").ptr();
  if(!p) DBG();
  if(b) p->markAllRecent();
  bool found;
  SFSGLoop(n,*p,found);
  si << found;
};

AddingCommand temp1SFSG("SFSG",3,_SFSG);

void _PrintSFSG(Source & so,Sink & si)  {
  stringGB sfsgname;
  so >> sfsgname;
  so.shouldBeEnd();
  SFSGRules * p = (SFSGRules *) Names::s_lookup_error(GBStream,
        sfsgname.value().chars(),"SFSRules").ptr();
  if(!p) DBG();
  GBStream << "Here is the SFSG:\n";
  p->print(GBStream);
};

AddingCommand temp2SFSG("PrintSFSG",1,_PrintSFSG);

void _AddPolynomialsToSFSG(Source & so,Sink & si) {
  stringGB sfsgname;
  list<Polynomial> L;
  so >> sfsgname;
  GBInput(L,so);
  so.shouldBeEnd();
  SFSGRules * p = (SFSGRules *) Names::s_lookup_error(GBStream,
        sfsgname.value().chars(),"SFSRules").ptr();
  if(!p) DBG();
  list<Polynomial>::const_iterator w = L.begin(), e = L.end();
  list<SFSGEntry*>::iterator xx;
  while(w!=e) {
    xx = p->insert(*w);
    p->markRecent(xx);
    ++w;
  };
  si.noOutput();  
};

AddingCommand temp3SFSG("AddPolynomialsToSFSG",2,_AddPolynomialsToSFSG);
