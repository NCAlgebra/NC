// heuristic.c

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include <stdlib.h>
#include "vcpp.hpp"
#include "GBList.hpp"
#include "GBMatch.hpp"
#include "Variable.hpp"
#include "Polynomial.hpp"
#include "MatcherMonomial.hpp"
#include "GBIO.hpp"
#include "GBOutput.hpp"
#include "GBOutputSpecial.hpp"
#include "GBInput.hpp"
#include "GBString.hpp"
#include "AppendItoString.hpp"
#include "MyOstream.hpp"

using namespace std;

int s_newVariableCounter = 1;

Variable createNewVariable() {
  GBString s("newVariable");
  AppendItoString(s_newVariableCounter,s);
  ++s_newVariableCounter;
  return Variable(s.chars());
};

pair<vector<Variable>,vector<Polynomial> > heuristic1(const Polynomial & p) {
  vector<Variable> resultv;
  vector<Polynomial> resultp;
  Variable v(createNewVariable());
  resultv.push_back(v);
  Polynomial q(p.tip());
  Monomial dumbm;
  dumbm *= v;
  Term dumbt(dumbm);
  Polynomial dumbp(dumbt);
  q -= dumbp;
  resultp.push_back(q);
  pair<vector<Variable>,vector<Polynomial> > result(resultv,resultp);
  return result;
};

pair<vector<Variable>,vector<Polynomial> > heuristic2(const Polynomial & p) { 
  vector<Variable> resultv; 
  vector<Polynomial> resultp; 
  // See if there is an overlap of the leading term with itself 
  const Monomial & m = p.tip().MonomialPart(); 
  GBList<Match> matches;
  MatcherMonomial matcher;
  matcher.overlapMatch(m,-1,m,-1,matches);
  const int sz = matches.size();
  if(sz>0) {
    GBList<Match>::iterator w = matches.begin();
    for(int i=1;i<=sz;++i,++w) {
      GBStream << *w <<'\n';
    };
  };
  Variable v(createNewVariable()); 
  pair<vector<Variable>,vector<Polynomial> > result(resultv,resultp); 
  return result; 
};

pair<vector<Variable>,vector<Polynomial> > heuristic3(const Polynomial &) { 
  DBG();
  vector<Variable> resultv; 
  vector<Polynomial> resultp; 
  pair<vector<Variable>,vector<Polynomial> > result(resultv,resultp); 
  return result; 
};

pair<vector<Variable>,vector<Polynomial> > heuristic4(const Polynomial & p) { 
  vector<Variable> resultv; 
  vector<Polynomial> resultp; 
  const int sz = p.numberOfTerms();
  resultv.reserve(sz);
  resultp.reserve(sz);
  PolynomialIterator w = p.begin();
  Monomial dumbm;
  Polynomial dumbp;
  for(int i=1;i<=sz;++i,++w) {
    Variable v(createNewVariable());
    dumbm.setToOne();
    dumbm *= v;
    Term dumbt(dumbm);
    dumbp.setToZero();
    dumbp += *w;
    dumbp -= dumbt;
    resultv.push_back(v);
    resultp.push_back(dumbp);
  };
  pair<vector<Variable>,vector<Polynomial> > result(resultv,resultp); 
  return result; 
};

pair<vector<Variable>,vector<Polynomial> > heuristic5(const Polynomial &) { 
  DBG();
  vector<Variable> resultv; 
  vector<Polynomial> resultp; 
  pair<vector<Variable>,vector<Polynomial> > result(resultv,resultp); 
  return result; 
};

pair<vector<Variable>,vector<Polynomial> > heuristicn(const Polynomial &) { 
  vector<Variable> resultv; 
  vector<Polynomial> resultp; 
  pair<vector<Variable>,vector<Polynomial> > result(resultv,resultp); 
  return result; 
};

pair<vector<Variable>,vector<Polynomial> > heuristic(
         const Polynomial & p,int n) {
  pair<vector<Variable>,vector<Polynomial> > pr;
  if(n==1) {
    pr = heuristic1(p);
  } else if(n==2) {
    pr = heuristic2(p);
  } else if(n==3) {
    pr = heuristic3(p);
  } else if(n==4) {
    pr = heuristic4(p);
  } else if(n==5) {
    pr = heuristic5(p);
  } else DBG();
  return pr;
};

pair<vector<Variable>,vector<Polynomial> > heuristic(
    const vector<Polynomial> & p,int n) {
  vector<Variable> resultv;
  vector<Polynomial> resultp;
  const int sz = p.size();
  resultv.reserve(sz);
  resultp.reserve(sz);
  vector<Polynomial>::const_iterator w = p.begin();
  vector<Polynomial>::const_iterator e = p.begin();
  while(w!=e) {
    pair<vector<Variable>,vector<Polynomial> > temp(heuristic(*w,n));
    copy(temp.first.begin(),temp.first.end(),back_inserter(resultv));
    copy(temp.second.begin(),temp.second.end(),back_inserter(resultp));
    ++w;
  };
  pair<vector<Variable>,vector<Polynomial> > result(resultv,resultp);
  return result;
};


void _UseHeuristic(Source & so,Sink & si) {
  Polynomial p;
  int n;
  so >> p >> n;
  so.shouldBeEnd();
  Sink sink1(si.outputFunction("List",2L));
  pair<vector<Variable>,vector<Polynomial> > pr(heuristic(p,n));
  const vector<Variable> & L1 = pr.first;
  const int sz1 = L1.size();
  vector<Variable>::const_iterator w1 = L1.begin();
  Sink sink2(sink1.outputFunction("List",sz1));
  for(int i=1;i<=sz1;++i,++w1) {
    sink2 << *w1;
  };
  const vector<Polynomial> & L2 = pr.second;
  const int sz2 = L2.size();
  vector<Polynomial>::const_iterator w2 = L2.begin();
  Sink sink3(sink1.outputFunction("List",sz2));
  for(i=1;i<=sz2;++i,++w2) {
    sink3 << *w2;
  };
};
