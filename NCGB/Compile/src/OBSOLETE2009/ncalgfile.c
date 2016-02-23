// ncalgfile.c

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "RecordHere.hpp"
#include "stringGB.hpp"
#include <ctype.h>
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#include "RecordHere.hpp"
#include "Polynomial.hpp"
#include "GBIO.hpp"
#include "MLex.hpp"
#include "CreateOrder.hpp"
#include "setStartingRelations.hpp"
#include "PrintVector.hpp"
#include "PrintVector.hpp"
#include "MyOstream.hpp"
#include "Source.hpp"
#include "Sink.hpp"

//#define DEBUG_NCALGFILE


int grabInteger(char c,istream & is,char & d);

class MngrStart;

extern MngrStart * run;

void grabVariableAux(istream & is,vector<char> & str) {
  int n = 1;
  char d;
  while(n>0  && is>>d) {
    str.push_back(d);
    if(d=='[') {
      ++n;
    } else if(d==']') {
      --n;
    };
  };
};

Variable grabVariable(char c,istream & is,char & d) {
  vector<char> str;
  str.reserve(100);
  str.push_back(c);
  bool extra = false;
  while(is>>d) {
    if(isalnum(d)) {
      str.push_back(d);
    } else if(d=='[') {
       str.push_back(d);
       grabVariableAux(is,str);
       is >> d;
       extra = true;
       break;
    } else {
       extra = true;
       break;
    };
  };
  if(!extra) d = '\0';
  RECORDHERE(char * s = new char[str.size()+1];)
  copy(str.begin(),str.end(),s);
  s[str.size()] = '\0';
  Variable result(s);
  RECORDHERE(delete s;)
  return result;
};

void ncalgfileRelations(list<Polynomial> & L,const char * s) {
  L.erase(L.begin(),L.end());
  ifstream ifs(s);
  Polynomial cp;
  Field cf;
  cf.setToZero();
  Monomial cm;
  cm.setToOne();
  char c,tempc;
  int skip = 0;
  while(skip>0|| (ifs>>c)) {
#ifdef DEBUG_NCALGFILE
cerr << "c:" << c << '\n'
     << "cp:" << cp << '\n'
     << "cf:" << cf << '\n'
     << "cm:" << cm << '\n';
#endif
    if(skip>0) --skip;
    if(c=='{' || c=='*') {
      // do nothing
    } else if(c==',' || c=='}') {
      // Done with a polynomial, put it into the list
      if(!cf.zero()) {
        Term x(cf,cm);
        cp += x;
      };
      L.push_back(cp);
      cp.setToZero();
      cf.setToZero();
      cm.setToOne();
    } else if(c=='\n') {
      // do nothing
    } else if(('a'<=c && c <='z')|| ('A'<=c && c <='Z')) {
      if(cf.zero()) cf.setToOne();
      cm *= grabVariable(c,ifs,tempc);
      c = tempc; ++skip;
    } else if(c=='+' || c=='-') {
      if(!cf.zero()) {
        Term x(cf,cm);
        cp += x;
        cf.setToZero();
        cm.setToOne();
      };
      if(c=='-') cf *= -1;
      cm.setToOne();
    } else if('0'<=c && c <='9') {
      int n = grabInteger(c,ifs,tempc);
      if(cf.zero()) cf.setToOne();
      cf *= n;
      c = tempc;++skip;
      cm.setToOne();
    } else DBG();
#ifdef DEBUG_NCALGFILE
cerr << "cp:" << cp << '\n'
     << "cf:" << cf << '\n'
     << "cm:" << cm << '\n';
#endif
  };
  ifs.close();
};

void ncalgfileOrder(vector<vector<Variable> > & L,const char * s) {
  list<vector<Variable> > X;
  vector<Variable> V;
  ifstream ifs(s);
  char c,tempc;
  int skip = 0;
  while(skip>0|| (ifs>>c)) {
#ifdef DEBUG_NCALGFILE
cerr << "V:";
PrintVector("V:",V);
cerr << '\n'
#endif
    if(skip>0) --skip;
    if(c=='<') {
      ifs>>tempc;
      if(tempc=='<') {
       X.push_back(V); 
       V.erase(V.begin(),V.end());
      } else {
       c = tempc; ++skip;
      };
    } else if(c=='\n') {
      // do nothing
    } else if(('a'<=c && c <='z')|| ('A'<=c && c <='Z')) {
      V.push_back(grabVariable(c,ifs,tempc));
      c = tempc; 
      if(tempc!='\0') ++skip;
    } else {
      GBStream << "Encountered:" << c << '\n';
      GBStream << "tempc:" << tempc << '\n';
      GBStream << "V:";
      PrintVector("V:",V);
      GBStream << '\n';
      DBG();
    };
#ifdef DEBUG_NCALGFILE
cerr << "V:";
PrintVector("V:",V);
cerr << '\n'
#endif
  };
  L.erase(L.begin(),L.end());
  L.reserve(X.size());
  copy(X.begin(),X.end(),back_inserter(L));
  ifs.close();
};

int _StartingRelationsFromNCAlgFile(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  list<Polynomial> L;
  list<Polynomial>::const_iterator w = L.begin();
  list<Polynomial>::const_iterator e = L.end();
  while(w!=e) {
    GBStream << *w << '\n';
    ++w;
  };
  so.shouldBeEnd();
  ncalgfileRelations(L,x.value().chars());
  setStartingRelations(L,run);
  si.noOutput();
};


void _SetOrderFromNCAlgFile(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  so.shouldBeEnd();
  si.noOutput();
  vector<vector<Variable> > L;
  ncalgfileOrder(L,x.value().chars());
  RECORDHERE(MLex * p = new MLex(L);)
  setOrderAdopt(p);
};
