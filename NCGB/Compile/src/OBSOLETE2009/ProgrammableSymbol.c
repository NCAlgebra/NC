// (c) Mark Stankus 1999
// ProgrammableSymbol.c


#include "ProgrammableSymbol.hpp"


#include "GBInput.hpp"
#include "asStringGB.hpp"
#include "AdmissibleOrder.hpp"
#include "AdmPolySource.hpp"
#include "AdmReduce.hpp"
#include "AdmRuleSet.hpp"
#include "AppendItoString.hpp"
#include "AuxilaryProgrammableSymbolData.hpp"
#include "Debug1.hpp"
#include "GBAlg.hpp"
#include "MLex.hpp"
#include "PolySource.hpp"
#include "RuleSet.hpp"
#include "SelectionOrder.hpp"
#include "Reduce.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "StdGBAlg.hpp"
#include "simpleString.hpp"
#include "stringGB.hpp"
#include "MyOstream.hpp"
#include "Command.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#include <algorithm>
#ifdef HAS_INCLUDE_NO_DOTS
#include <iterator>
#else
#include <iterator.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#include "vcpp.hpp"

typedef map<simpleString,AuxilaryProgrammableSymbolData> TYPEINFO;
TYPEINFO d_type_info;
typedef map<simpleString,simpleString> NAME2TYPE;
NAME2TYPE d_name_to_type;

void _DeclareProgrammableVariableDefault(Source & so,Sink & sink) {
  asStringGB type, name;
  so >> type >> name;
  so.shouldBeEnd();
  sink.noOutput();
  TYPEINFO::const_iterator w = d_type_info.find(type.value());
  if(w==d_type_info.end()) {
    GBStream << "Cannot find the type " << type.value() << "\n";
    DBG();
  };
  d_name_to_type[name.value()] = type.value();
  void (*func)(const simpleString &) = (*w).second.d_construct_default;
  if(!func) DBG();
  func(name.value());
};

void _DeclareProgrammableVariableNotDefault(Source & so,Sink & sink) {
  asStringGB type, name;
  so >> type >> name;
  TYPEINFO::const_iterator w = d_type_info.find(type.value());
  if(w==d_type_info.end()) {
    GBStream << "Cannot find the type " << type.value() << "\n";
    DBG();
  };
  d_name_to_type[name.value()] = type.value();
  void (*func)(const simpleString &,Source & so) = (*w).second.d_construct_not_default;
  if(!func) DBG();
  func(name.value(),so);
  so.shouldBeEnd();
  sink.noOutput();
};


AddingCommand temp1aProgrammableSymbol("DeclareProgrammableVariable",2,_DeclareProgrammableVariableDefault);
AddingCommand temp1bProgrammableSymbol("DeclareAndAssignProgrammableVariable",3,_DeclareProgrammableVariableNotDefault);

void _RemoveProgrammableVariable(Source & so,Sink & si) {
  asStringGB name;
  so >> name;
  so.shouldBeEnd();
  si.noOutput();
  NAME2TYPE::const_iterator w = d_name_to_type.find(name.value());
  if(w==d_name_to_type.end()) {
    GBStream << name.value() << " is not a programmable variable"
             << " and, therefore, cannot be removed.\n";
  } else {
    TYPEINFO::const_iterator ww = d_type_info.find((*w).second);
    void (*func)(const simpleString&) = (*ww).second.d_remove;
    if(!func) DBG();
    func(name.value());
  };
};

AddingCommand temp2ProgrammableSymbol("RemoveProgrammableVariable",1,_RemoveProgrammableVariable);

void _CreateProgrammableVariable(Source & so,Sink & si) {
  asStringGB type;
  so >> type;
  so.shouldBeEnd();
  TYPEINFO::const_iterator ww = d_type_info.find(type.value());
  stringGB newName;
  DBG();
  int i = 0;
  bool todo = true;
  char * temp = 0;
  char s[100];
  simpleString S;
  while(todo) {
    strcpy(s,"GBMarker[");
    ItoString(i,temp);
    strcat(s,temp);
    strcat(s,",\"");
    strcat(s,type.value().chars());
    strcat(s,"\"]");
    S = s;
    todo = d_name_to_type.find(S)!=d_name_to_type.end();
  };
  delete [] temp;
  newName.assign(s);
  d_name_to_type[newName.value()] = type.value();
  void (*func)(const simpleString &) = (*ww).second.d_construct_default;
  if(!func) DBG();
  func(newName.value());
  si << newName;
};

AddingCommand temp3ProgrammableSymbol("CreateProgrammableVariable",1,_CreateProgrammableVariable);

void _SetProgrammableVariable(Source & so,Sink & si) {
  asStringGB name;
  so >> name;
  NAME2TYPE::const_iterator w = d_name_to_type.find(name.value());
  if(w==d_name_to_type.end()) {
    GBStream << name.value() << " is not a programmable variable"
             << " and, therefore, cannot be set to a value.\n";
  } else {
    TYPEINFO::const_iterator ww = d_type_info.find((*w).second);
    void (*func)(const simpleString &,Source & so) = (*ww).second.d_input;
    if(!func) DBG();
    func(name.value(),so);
  };
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp4ProgrammableSymbol("SetProgrammableVariable",1,_SetProgrammableVariable);

void _PrintProgrammableVariable(Source & so,Sink & si) {
  asStringGB name;
  so >> name;
  NAME2TYPE::const_iterator w = d_name_to_type.find(name.value());
  if(w==d_name_to_type.end()) {
    GBStream << name.value() << " is not a programmable variable"
             << " and, therefore, cannot be printed.\n";
  } else {
    TYPEINFO::const_iterator ww = d_type_info.find((*w).second);
    void (*func)(const simpleString &,MyOstream &) = (*ww).second.d_print;
    if(!func) DBG();
    func(name.value(),GBStream);
  };
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp4aProgrammableSymbol("PrintProgrammableVariable",1,
        _PrintProgrammableVariable);

        
void _ObtainProgrammableVariable(Source & so,Sink & si) {
  asStringGB name;
  so >> name;
  so.shouldBeEnd();
  NAME2TYPE::const_iterator w = d_name_to_type.find(name.value());
  if(w==d_name_to_type.end()) {
    GBStream << name.value() << " is not a programmable variable"
             << " and, therefore, its value cannot be accessed.\n";
  } else {
    TYPEINFO::const_iterator ww = d_type_info.find((*w).second);
    void (*func)(const simpleString &,Sink &) = (*ww).second.d_output;
    if(!func) DBG();
    func(name.value(),si);
  };
};

AddingCommand temp5ProgrammableSymbol("ObtainProgrammableVariable",1,_ObtainProgrammableVariable);

template<class T>
bool StorageGet(const map<simpleString,T> & MAP,const simpleString & s,T & t) {
  map<simpleString,T>::const_iterator w = MAP.find(s);
  bool result = w!=MAP.end();
  if(result) t = (*w).second;
  return result;
};

template<class T>
void StorageRemove(const simpleString & s,map<simpleString,T> & X) {
  X.erase(X.find(s));
};

template<class T>
void StoragePointerRemove(const simpleString & s,map<simpleString,T*> & X) {
  map<simpleString,T*>::iterator w = X.find(s);
  T * p = (*w).second;
  delete p;
  X.erase(w);
};

    // FOR INTEGERS

typedef map<simpleString,int> INT_STORAGE;
INT_STORAGE int_storage;

void construct_int(const simpleString & s) {
  int_storage.insert(make_pair(s,0));
};

void remove_int(const simpleString & s) {
  StorageRemove(s,int_storage);
};

void input_int(const simpleString & s,Source & source) {
  int m;
  source >> m;
  (*int_storage.find(s)).second = m; 
};

void output_int(const simpleString & s,Sink & sink) {
  sink << (*int_storage.find(s)).second; 
};

void print_int(const simpleString & s,MyOstream & os) {
  os << (*int_storage.find(s)).second; 
};


   // FOR ADMISSIBLEORDERS
typedef map<simpleString,AdmissibleOrder*> ADMISSIBLE_ORDER_STORAGE;
ADMISSIBLE_ORDER_STORAGE order_storage;

void construct_mlex(const simpleString & s,Source & source) {
  Variable v;
  Source p(source.inputNamedFunction("List"));
  list<vector<Variable> > result1;
  while(!p.eoi()) {
    list<Variable> L;
    Source q(p.inputNamedFunction("List"));
    while(!q.eoi()) {
      q >> v;
      L.push_back(v);
    };
    vector<Variable> V;
    V.reserve(L.size());
    copy(L.begin(),L.end(),back_inserter(V));
    result1.push_back(V);
  };
  vector<vector<Variable> > result2;
  result2.reserve(result1.size());
  copy(result1.begin(),result1.end(),back_inserter(result2));
  MLex * ord_p = new MLex(result2);
  AdmissibleOrder::s_setCurrentAdopt(ord_p);
  order_storage.insert(make_pair(s,ord_p));
};

void remove_order(const simpleString & s) {
  StorageRemove(s,order_storage);
};

void print_mlex(const simpleString & s,MyOstream & os) {
  (*order_storage.find(s)).second->PrintOrder(os);
};

  // FOR REDUCE

typedef map<simpleString,Reduce*> REDUCE_STORAGE;
REDUCE_STORAGE reduce_storage;


// MUST BE CUSTOMIZED FOR EACH Reduce
void construct_reduce_adm(const simpleString & s,Source & source) {
  asStringGB orderName;
  source >> orderName;
  AdmissibleOrder  * p;
  bool valid = StorageGet(order_storage,orderName.value(),p);
  if(valid) {
    Reduce * q = new AdmReduce(*p);
    reduce_storage.insert(make_pair(s,q));
  } else DBG();
};

void remove_reduce(const simpleString & s) {
  StoragePointerRemove(s,reduce_storage);
};

void print_reduce(const simpleString &s , MyOstream & os) {
  (*reduce_storage.find(s)).second->print(os);
};

    // RULESET

typedef map<simpleString,RuleSet*> RULESET_STORAGE;
RULESET_STORAGE ruleset_storage;

// MUST BE CUSTOMIZED FOR EACH RuleSet
void construct_ruleset_adm(const simpleString & s,Source & source) {
  asStringGB orderName;
  list<Polynomial> L;
  Source so(source.inputNamedFunction("List"));
  so >> orderName;
  GBInputSpecial(L,so);
  AdmissibleOrder * p;
  bool valid = StorageGet(order_storage,orderName.value(),p);
  if(valid) {
    RuleSet * result = new AdmRuleSet(*p);
    typedef list<Polynomial>::const_iterator LI; 
    LI w = L.begin(), e = L.end();
    int i = 1;
    while(w!=e) {
      RuleID rid(*w,i);
      result->insert(rid);
      ++w;++i;
    };
GBStream << "Constructing the  ruleset with name " << s << '\n';
result->print(GBStream);
GBStream << "end\n";
    ruleset_storage.insert(make_pair(s,result));
  } else DBG();
};

void remove_ruleset(const simpleString & s) {
  StoragePointerRemove(s,ruleset_storage);
};

void print_ruleset(const simpleString & s,MyOstream & os) {
  RuleSet * p = (*ruleset_storage.find(s)).second; 
  AdmRuleSet * q = (AdmRuleSet*)(p);
  const set<RuleID,AdmRuleIDCompare> & X = q->ADMSET();
  set<RuleID,AdmRuleIDCompare>::const_iterator w = X.begin(),e = X.end();
  while(w!=e) {
    os << *w << '\n';
    ++w;
  };
};

    // FOR SELECTION ORDERS

typedef map<simpleString,SelectionOrder>  SELECTION_ORDER_STORAGE; 
SELECTION_ORDER_STORAGE selection_order_storage;

    // FOR POLYSOURCE

typedef map<simpleString,PolySource*> POLYSOURCE_STORAGE;
POLYSOURCE_STORAGE polysource_storage;

// MUST BE CUSTOMIZED FOR EACH PolySource
#if 0
void construct_polyset_std(const simpleString & s,Source & source) {
  asStringGB nameSel;
  source >> nameSel; 
  SelectionOrder sel;
  bool valid = StorageGet(selection_order_storage,nameSel.value(),sel);
  PolySource * p = StdPolySource(sel);
  polyset_storage.insert(make_pair(s,p));
};
#endif

void construct_polyset_adm(const simpleString & s,Source & source) {
  asStringGB nameAdm, nameRuleSet;
  Source so(source.inputNamedFunction("List"));
  so >> nameAdm >> nameRuleSet;
  AdmissibleOrder * ord_p;
  bool valid = StorageGet(order_storage,nameAdm.value(),ord_p);
  if(valid) {
    RuleSet * rset_p;
    valid = StorageGet(ruleset_storage,nameRuleSet.value(),rset_p);
    if(valid) {
      PolySource * p = new AdmPolySource(*ord_p,*(AdmRuleSet*)rset_p);
      polysource_storage.insert(make_pair(s,p));
    } else DBG();
  } else DBG();
};

void remove_polyset(const simpleString & s) {
  StoragePointerRemove(s,polysource_storage);
};

void print_polyset_adm(const simpleString & s,MyOstream & os) {
  (*polysource_storage.find(s)).second->print(os);
};


    // FOR GBALG

typedef map<simpleString,GBAlg*> GBALG_STORAGE;
GBALG_STORAGE gbalg_storage;

void construct_source_standard(Source & source,Reduce * &p1, 
           PolySource * &p2,RuleSet* &p3) {
  Source so(source.inputNamedFunction("List"));
  asStringGB polyName, reduceName, ruleGBName;
  so >> polyName >> reduceName >> ruleGBName;
  so.shouldBeEnd();
  bool valid = StorageGet(reduce_storage,reduceName.value(),p1);
  if(!valid) DBG();
  valid = valid && StorageGet(polysource_storage,polyName.value(),p2);
  if(!valid) DBG();
  valid = valid && StorageGet(ruleset_storage,ruleGBName.value(),p3);
  if(!valid) DBG();
};

// MUST BE CUSTOMIZED FOR EACH GBAlg
void construct_stdgbalg(const simpleString & s,Source & source) {
  Reduce * p1;
  PolySource * p2;
  RuleSet * p3;
  construct_source_standard(source,p1,p2,p3);
  if(!!p1&&!!p2&&!!p3) {
    gbalg_storage.insert(make_pair(s,new StdGBAlg(*p1,*p2,*p3)));
  };
};

void remove_gbalg(const simpleString & s) {
  StoragePointerRemove(s,gbalg_storage);
};

void print_gbalg(const simpleString & s,MyOstream & os) {
  (*gbalg_storage.find(s)).second->print(os);
};

void do_nothing(const simpleString & s) {
  GBStream << "Blank function for " << s.chars() << '\n';
};

void do_nothing(const simpleString & s,Source &) {
  GBStream << "Blank input function for " << s.chars() << '\n';
};

void do_nothing(const simpleString & s,Sink &) {
  GBStream << "Blank output function for " << s.chars() << '\n';
};

void do_nothing(const simpleString & s,MyOstream &) {
  GBStream << "Blank print function for " << s.chars() << '\n';
};

void _RunGBAlg(Source & source,Sink & sink) {
  asStringGB name;
  source >> name;
  source.shouldBeEnd();
  sink.noOutput();
  GBALG_STORAGE::const_iterator w = gbalg_storage.find(name.value());
  if(w==gbalg_storage.end()) DBG();
  (*w).second->perform();
};

AddingCommand temp6ProgrammableSymbol("RunGBAlg",1,_RunGBAlg);

void _SetUpProgrammableSymbols(Source &so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  { 
    AuxilaryProgrammableSymbolData x(construct_int,remove_int,print_int,
        input_int,output_int);
    simpleString I("int");
    d_type_info.insert(make_pair(I,x));
  }
  {
    AuxilaryProgrammableSymbolData x(construct_mlex,remove_order,
            print_mlex,do_nothing,do_nothing);
    simpleString I("mlex");
    d_type_info.insert(make_pair(I,x));
  }
  {
    AuxilaryProgrammableSymbolData x(construct_reduce_adm,remove_reduce,
        print_reduce,do_nothing,do_nothing);
    simpleString I("admreduction");
    d_type_info.insert(make_pair(I,x));
  }
  {
    AuxilaryProgrammableSymbolData x(construct_ruleset_adm,
       remove_ruleset,print_ruleset,do_nothing,do_nothing);
    simpleString I("admruleset");
    d_type_info.insert(make_pair(I,x));
  }
  {
    AuxilaryProgrammableSymbolData x(construct_polyset_adm,remove_polyset,
          print_polyset_adm,do_nothing,do_nothing);
    simpleString I("admpolyset");
    d_type_info.insert(make_pair(I,x));
  }
  {
    AuxilaryProgrammableSymbolData x(construct_stdgbalg,remove_gbalg,
         print_gbalg,do_nothing,do_nothing);
    simpleString I("standardgbalgorithm");
    d_type_info.insert(make_pair(I,x));
  }
};

AddingCommand temp7ProgrammableSymbol("SetUpProgrammableSymbols",0,_SetUpProgrammableSymbols);
