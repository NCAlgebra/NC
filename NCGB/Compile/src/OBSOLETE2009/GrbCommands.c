// (c) Mark Stankus 1999
// GrbCommands.c

#include "Commands.hpp"
#include "stringGB.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#include <vector>
#else
#include <fstream.h>
#include <vector.h>
#endif
#include "Command.hpp"
#include "MLex.hpp"
#include "Polynomial.hpp"
#include "GrbSource.hpp"
#include "fstreamSource.hpp"
#include "RecordHere.hpp"
#include "CreateOrder.hpp"
#ifndef INCLUDED_OUMONOMIAL_H
#include "OuMonomial.hpp"
#endif
#include "MyOstream.hpp"

using namespace std;

#include "setStartingRelations.hpp"


void _GrbGetOrder(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  Variable v;
  ifstream ifs(x.value().chars());
  bool lowerplaces[26];
  bool upperplaces[26];
  bool * lowerend = &lowerplaces[26];
  bool * upperend = &upperplaces[26];
  bool * b;
  for(b = lowerplaces;b!=lowerend;++b) *b= false;
  for(b = upperplaces;b!=upperend;++b) *b= false;
  char c;
  int num_true = 0;
  int n;
  while(ifs>>c) {
    if('a'<=c && c <='z') {
      n = c-'a';
      if(!lowerplaces[n])  { lowerplaces[n]= true; ++num_true;};
    } else if('A'<=c && c <='Z') {
      int n = c-'A';
      if(!upperplaces[n])  { upperplaces[n]= true; ++num_true;};
    };
  };
  char var[2];
  vector<Variable> L1;
  vector<vector<Variable> > LL;
  LL.push_back(L1);
  vector<Variable> & L2 = *LL.begin();
  var[0] = 'a';
  var[1] = '\0';
  L2.reserve(num_true);
  bool * bb;
  for(bb = lowerplaces;bb!=lowerend;++bb,++var[0]) {
    if(*bb) {
      v.assign(var);
      L2.push_back(v);
    };
  };
  var[0] = 'A';
  for(bb = upperplaces;bb!=upperend;++bb,++var[0]) {
    if(*bb) {
      v.assign(var);
      L2.push_back(v);
    };
  };
  ifs.close();
  RECORDHERE(MLex * p = new MLex(LL);)
  setOrderAdopt(p);
  si.noOutput();
};

AddingCommand temp2Commands("GrbGetOrder",1,_GrbGetOrder);

void _GrbstartingRelations(Source & so,Sink & si) {
  stringGB x;
  so >> x;
  ifstream ifs(x.value().chars());
  fstreamSource so2(ifs);
  GrbSource grb(so2);
  GBList<Polynomial> L;
  Polynomial p;
  while(!grb.eoi()) {
    grb.get(p);
GBStream << "Got the polynomial :" << p << '\n';
    L.push_back(p);
  };
  registerStartingRelationsHelper(L);
  ifs.close();
  si.noOutput();
};

AddingCommand temp3Commands("GrbstartingRelations",1,_GrbstartingRelations);


void print(const Monomial & x) {
  OuMonomial::NicePrint(GBStream,x);
};

void print(const Polynomial & x) {
  GBStream << x;
};
