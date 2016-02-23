// Mark Stankus 1999 (c)
// MonomialForest.h
#ifndef INCLUDED_MONOMIALFOREST_H
#define INCLUDED_MONOMIALFOREST_H

#include "SFSGNode.hpp"
#include "PrintStyle.hpp"
#include "ByAdmissible.hpp"
#include "AdmissibleOrder.hpp"
#include "Variable.hpp"
#include "Choice.hpp"
#include "MatcherMonomial.hpp"
#include "GBMatch.hpp"
#include "simpleString.hpp"
#include "UserOptions.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#include <set>
#else
#include <map.h>
#include <set.h>
#endif

#define DEBUG_MONOMIALFOREST
#define SFSG_DEBUG

struct TheRuleCompare {
  bool operator()(const TheRule *p, const TheRule * q) const {
    return AdmissibleOrder::s_getCurrent().monomialLess(p->d_m,q->d_m);
  };
};

class MonomialForest {
  static void errorh(int);
  static void errorc(int);
  bool d_acceptor_has_children;
  bool d_giver_has_children;
  bool d_acceptor_has_rule;
  bool d_giver_has_rule;
  list<Polynomial> d_to_be_added;
  typedef map<Variable,SFSGNode *,ByAdmissible> MAP;
  typedef set<TheRule *,TheRuleCompare> SET;
  MAP d_tree_map;
  SET d_set;
  bool d_contraction_found;
    // Does the set contain the give monomial as a tip of a polynomial?
  SET::iterator setfind(const Monomial &m);
    // Add a nonzero polynomial.
  SET::iterator addPolynomialPrivate(const Polynomial & p);
public:
  mutable int d_htmlnumberfiles;
  MonomialForest() : d_contraction_found(false), d_htmlnumberfiles(0) {};
  ~MonomialForest(){};
           // TREE STUFF
    // Does there exist a root with variable v?
  bool FindTree(const Variable & v,SFSGNode *& result) const {
    MAP::const_iterator w = d_tree_map.find(v);
    bool b = w!=d_tree_map.end();
    if(b) {
      result = (*w).second; 
    };
    return b;
  };
    // Return a root with variable v.
    // If root does not exist, create it.
  void ForceTree(const Variable & v,SFSGNode *& result) {
    if(!FindTree(v,result)) {
      result = new SFSGNode(v);
      pair<const Variable,SFSGNode *> pr(v,result);
      d_tree_map.insert(pr);
    };
  }; 
           // ADDING POLYNOMIAL 
    // add the polynomial's tip as a path.
    // no sophisticated tree manipulations
  void addPolynomial(const Polynomial & p) {
    if(!p.zero()) (void) addPolynomialPrivate(p); 
  }; 
  void dump(
     const list<SFSGNode *> & acceptorpassed,
     const list<SFSGNode *> & giverpassed,
     const SET::iterator & w,const SET::iterator & e,SFSGNode * childacceptor,
     SFSGNode * childgiver,const  MonomialIterator & monw,int monsz,
     int count) const;
    // Returns whether or not reduction occured
  bool process(MyOstream & os,
         list<SFSGNode *> & acceptorpassed,
         list<SFSGNode *> & giverpassed,
         SET::iterator & w,SET::iterator & e,
         SFSGNode * childacceptor,SFSGNode * childgiver,
         MonomialIterator monw,int monsz);
  bool fixRule(TheRule * rule,SET::iterator & w,SET::iterator & e);
  void fixTree();
  void removeRule(SET::iterator w);
       // SPOLYNOMIAL STUFF
  enum AlgorithmApproach { INLIST, INFOREST};
  void goforit(TheRule * r1,TheRule * r2,AlgorithmApproach style); 
  void makeRecent(AlgorithmApproach style);
  void copyIntoList(list<Polynomial> & L) const;
  void PrintAllTrees(MyOstream & os) const;
  void PrintAllTrees(MyOstream & os,PrintStyle s) const;
  void PrintAllTrees(MyOstream & os,PrintStyle s,bool) const;
  void PrintTheSet(MyOstream & os) const;
  void PrintTheSet(MyOstream & os,PrintStyle s) const;
  void PrintTheSet(MyOstream & os,PrintStyle s,bool) const;
  void reduceIt(SFSGNode * & childacceptor,SFSGNode * & childgiver,
        MonomialIterator & monw,
        const list<SFSGNode *> & acceptorpassed, 
        const list<SFSGNode *> & giverpassed,
        int & monsz,SET::iterator & w,SET::iterator & e);
  void lookForCycles() const;
  void myprint(MyOstream &,const list<SFSGNode*> & L) const;
};
#endif
