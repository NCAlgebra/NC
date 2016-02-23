// Mark Stankus 1999 (c)
// Pools.cpp

#include "Pools.hpp"

#include "Debug1.hpp"
#include "FactControl.hpp"
#include "PrintList.hpp"
#include "PrintGBList.hpp"
#include "GBVector.hpp"
#include "GBList.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#include <map>
#else
#include <list.h>
#include <map.h>
#endif
#include "GroebnerRule.hpp"
#include "GBHistory.hpp"
#include "Polynomial.hpp"
#include "Variable.hpp"
#include "Spreadsheet.hpp"
#include "Tag.hpp"
#include "PolySource.hpp"
#include "Reduction.hpp"
#include "BroadCast.hpp"
#include "GiveNumber.hpp"

using namespace std;

template class Pools<list<GBHistory> >;
template class Pools<FactControl >;
template class Pools<list<Variable> >;
template class Pools<list<Polynomial> >;
template class Pools<list<GroebnerRule> >;
template class Pools<GBList<Variable> >;
template class Pools<GBList<Polynomial> >;
template class Pools<GBList<GroebnerRule> >;
template class Pools<GBVector<int> >;
template class Pools<Spreadsheet>;
template class Pools<Tag>;
template class Pools<PolySource>;
template class Pools<Reduction>;
template class Pools<BroadCast>;
template class Pools<GiveNumber>;

const char * const Pools<FactControl>::s_poolname = "FactControl";
const char * const Pools<list<GBHistory> >::s_poolname = "list<GBHistory>";
const char * const Pools<list<Variable> >::s_poolname = "list<Variable>";
const char * const Pools<list<Polynomial> >::s_poolname = "list<Polynomial>";
const char * const Pools<list<GroebnerRule> >::s_poolname = "list<GroebnerRule>";
const char * const Pools<GBList<Variable> >::s_poolname = "GBList<Variable>";
const char * const Pools<GBList<Polynomial> >::s_poolname = "GBList<Polynomial>";
const char * const Pools<GBList<GroebnerRule> >::s_poolname = "GBList<GroebnerRule>";
const char * const Pools<GBVector<int> >::s_poolname = "GBVector<int>";
const char * const Pools<Spreadsheet>::s_poolname = "Spreadsheet";
const char * const Pools<Tag>::s_poolname = "Tag";
const char * const Pools<PolySource>::s_poolname = "PolySource";
const char * const Pools<Reduction>::s_poolname = "Reduction";
const char * const Pools<BroadCast>::s_poolname = "BroadCast";
const char * const Pools<GiveNumber>::s_poolname = "GiveNumber";

map<simpleString,FactControl*,less<simpleString> >
       Pools<FactControl>::s_map;
map<simpleString,list<GBHistory>*,less<simpleString> >
       Pools<list<GBHistory> >::s_map;
map<simpleString,list<Variable>*,less<simpleString> >
       Pools<list<Variable> >::s_map;
map<simpleString,list<Polynomial>*,less<simpleString> >
        Pools<list<Polynomial> >::s_map;
map<simpleString,list<GroebnerRule>*,less<simpleString> >
        Pools<list<GroebnerRule> >::s_map;
map<simpleString,GBList<Variable>*,less<simpleString> >
        Pools<GBList<Variable> >::s_map;
map<simpleString,GBList<Polynomial>*,less<simpleString> >
        Pools<GBList<Polynomial> >::s_map;
map<simpleString,GBList<GroebnerRule>*,less<simpleString> >
        Pools<GBList<GroebnerRule> >::s_map;
map<simpleString,GBVector<int>*,less<simpleString> >
        Pools<GBVector<int> >::s_map;
map<simpleString,Spreadsheet*,less<simpleString> >
        Pools<Spreadsheet>::s_map;
map<simpleString,Tag*,less<simpleString> >
        Pools<Tag>::s_map;
map<simpleString,PolySource*,less<simpleString> >
        Pools<PolySource>::s_map;
map<simpleString,Reduction*,less<simpleString> >
        Pools<Reduction>::s_map;
map<simpleString,BroadCast*,less<simpleString> >
        Pools<BroadCast>::s_map;
map<simpleString,GiveNumber*,less<simpleString> >
        Pools<GiveNumber>::s_map;


void AddDefaultToPool(const simpleString & pool,
   const simpleString & name) {
  if(pool=="FactControl") {
     AddDefaultToPool(name,(FactControl *)0);
  } else if(pool=="list<GBHistory>") {
     AddDefaultToPool(name,(list<GBHistory> *)0);
  } else if(pool=="list<Variable>") {
     AddDefaultToPool(name,(list<Variable> *) 0);
  } else if(pool=="list<Polynomial>") {
     AddDefaultToPool(name,(list<Polynomial> *) 0);
  } else if(pool=="list<GroebnerRule>") {
     AddDefaultToPool(name,(list<GroebnerRule> *) 0);
  } else if(pool=="GBList<Variable>") {
     AddDefaultToPool(name,(GBList<Variable> *) 0);
  } else if(pool=="GBList<Polynomial>") {
     AddDefaultToPool(name,(GBList<Polynomial> *) 0);
  } else if(pool=="GBList<GroebnerRule>") {
     AddDefaultToPool(name,(GBList<GroebnerRule> *) 0);
  } else if(pool=="GBVector<int>") {
     AddDefaultToPool(name,(GBVector<int> *) 0);
  } else if(pool=="Spreadsheet") {
     AddDefaultToPool(name,(Spreadsheet *) 0);
  } else if(pool=="BroadCast") {
     AddDefaultToPool(name,(BroadCast *) 0);
  } else if(pool=="GiveNumber") {
     PoolError::errorc(__LINE__);
  } else {
    GBStream << "Error in AddDefaultToPool " 
             << "\"" << pool << "\" not recognized.\n";
    PoolError::errorc(__LINE__);
  };
};
void RemoveFromPool(const simpleString & pool,
   const simpleString & name) {
  if(pool=="FactControl") {
     RemoveFromPool(name,(FactControl *)0);
  } else if(pool=="list<GBHistory>") {
     RemoveFromPool(name,(list<GBHistory> *)0);
  } else if(pool=="list<Variable>") {
     RemoveFromPool(name,(list<Variable> *) 0);
  } else if(pool=="list<Polynomial>") {
     RemoveFromPool(name,(list<Polynomial> *) 0);
  } else if(pool=="list<GroebnerRule>") {
     RemoveFromPool(name,(list<GroebnerRule> *) 0);
  } else if(pool=="GBList<Variable>") {
     RemoveFromPool(name,(GBList<Variable> *) 0);
  } else if(pool=="GBList<Polynomial>") {
     RemoveFromPool(name,(GBList<Polynomial> *) 0);
  } else if(pool=="GBList<GroebnerRule>") {
     RemoveFromPool(name,(GBList<GroebnerRule> *) 0);
  } else if(pool=="GBVector<int>") {
     RemoveFromPool(name,(GBVector<int> *) 0);
  } else if(pool=="Spreadsheet") {
     RemoveFromPool(name,(Spreadsheet *) 0);
  } else if(pool=="BroadCast") {
     RemoveFromPool(name,(BroadCast *) 0);
  } else if(pool=="GiveNumber") {
     RemoveFromPool(name,(GiveNumber*) 0);
  } else {
    GBStream << "Error in RemoveFromPool " 
             << "\"" << pool << "\" not recognized.\n";
    PoolError::errorc(__LINE__);
  };
};

void PrintEntryOfPool(const simpleString & pool,const simpleString & name) {
  if(pool=="FactControl") {
    PoolError::errorc(__LINE__);
  } else if(pool=="list<GBHistory>") {
     list<GBHistory> * p = 
          Pools<list<GBHistory> >::s_lookup(name);
     PrintList("",*p);
  } else if(pool=="list<Variable>") {
     list<Variable> * p = 
     Pools<list<Variable> >::s_lookup(name);
     PrintList("",*p);
  } else if(pool=="list<Polynomial>") {
     list<Polynomial> * p = 
     Pools<list<Polynomial> >::s_lookup(name);
     PrintList("",*p);
  } else if(pool=="list<GroebnerRule>") {
     list<GroebnerRule> * p = 
     Pools<list<GroebnerRule> >::s_lookup(name);
     PrintList("",*p);
  } else if(pool=="GBList<Variable>") {
     GBList<Variable> * p = 
     Pools<GBList<Variable> >::s_lookup(name);
     PrintGBList("",*p);
  } else if(pool=="GBList<Polynomial>") {
     GBList<Polynomial> * p = 
     Pools<GBList<Polynomial> >::s_lookup(name);
     PrintGBList("",*p);
  } else if(pool=="GBList<GroebnerRule>") {
     GBList<GroebnerRule> * p = 
     Pools<GBList<GroebnerRule> >::s_lookup(name);
     PrintGBList("",*p);
#if 0 
  } else if(pool=="GBVector<int>") {
     GBVector<int> * p = 
     Pools<GBVector<int> >::s_lookup(name);
     GBStream << *p << '\n';
  } else if(pool=="Spreadsheet") {
     Spreadsheet * p = 
     Pools<Spreadsheet>::s_lookup(name);
     GBStream << *p << '\n';
  } else if(pool=="BroadCast") {
     BroadCast * p = 
     Pools<BroadCast>::s_lookup(name);
     GBStream << *p << '\n';
  } else if(pool=="GiveNumber") {
    PoolError::errorc(__LINE__);
#endif
  } else {
    GBStream << "Error in PrintEntryOfPool "
             << "\"" << pool << "\" not recognized.\n";
    PoolError::errorc(__LINE__);
  };
};

void PrintNames(const simpleString & pool) {
  if(pool=="list<GBHistory>") {
     Pools<list<GBHistory> >::s_listNames(GBStream);
  } else if(pool=="list<Variable>") {
     Pools<list<Variable> >::s_listNames(GBStream);
  } else if(pool=="list<Polynomial>") {
     Pools<list<Polynomial> >::s_listNames(GBStream);
  } else if(pool=="list<GroebnerRule>") {
     Pools<list<GroebnerRule> >::s_listNames(GBStream);
  } else if(pool=="GBList<Variable>") {
     Pools<GBList<Variable> >::s_listNames(GBStream);
  } else if(pool=="GBList<Polynomial>") {
     Pools<GBList<Polynomial> >::s_listNames(GBStream);
  } else if(pool=="GBList<GroebnerRule>") {
     Pools<GBList<GroebnerRule> >::s_listNames(GBStream);
  } else if(pool=="GBVector<int>") {
     Pools<GBVector<int> >::s_listNames(GBStream);
  } else if(pool=="Spreadsheet") {
     Pools<Spreadsheet>::s_listNames(GBStream);
  } else if(pool=="BroadCast") {
     Pools<BroadCast>::s_listNames(GBStream);
  } else if(pool=="GiveNumber") {
     Pools<GiveNumber>::s_listNames(GBStream);
  } else {
    GBStream << "Error in AddDefaultToPool " 
             << "\"" << pool << "\" not recognized.\n";
    PoolError::errorc(__LINE__);
  };
};

void PrintAllPools() {
  GBStream 
      << "list<GBHistory>\n"      << "list<Variable>\n"
      << "list<Polynomial>\n"     << "list<GroebnerRule>\n"
      << "GBList<Variable>\n"     << "GBList<Polynomial>\n"
      << "GBList<GroebnerRule>\n" << "GBVector<int>\n"
      << "Spreadsheet\n"          << "BroadCast\n" 
     << "GiveNumber\n" << "FactControl\n";
};
