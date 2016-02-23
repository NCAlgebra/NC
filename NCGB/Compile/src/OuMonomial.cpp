// OuMonomial.c

#include "OuMonomial.hpp"
#ifndef INCLUDED_MONOMIAL_H
#include "Monomial.hpp"
#endif
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#include "MyOstream.hpp"
#include "vcpp.hpp"
#include "GBList.hpp"

#if 1

#include "MonomialToPowerList.hpp"

void OuMonomial::NicePrint(MyOstream & os,const Monomial & x) {
  const int num = x.numberOfFactors();
  if (num == 0) {
    os << '1';
  } else {
    list<pair<Variable,int> > L;
    MonomialToPowerList(x,L);
    list<pair<Variable,int> >::const_iterator w = L.begin();
    const int treesSizem1 = L.size()-1;
    for(int i=1;i<=treesSizem1;++i,++w) {
      const pair<Variable,int> & pr = *w;
      os << pr.first;
      if(pr.second!=1) {
        os << '^' << pr.second;
      }
      os << (pr.first.commutativeQ() ? " * " : " ** ");
    }
    const pair<Variable,int> & pr = *w;
    os << pr.first;
    if(pr.second!=1) {
      os << '^' << pr.second;
    }
  }
};
#else
void OuMonomial::NicePrint(MyOstream & os,const Monomial & x) {
  const int num = x.numberOfFactors();
  if (num == 0) {
    os << '1';
  } else {
    list<Variable> trees;
    list<int> powers;
    MonomialIterator j = x.begin();
    Variable var(*j);
    trees.push_back(var);
    powers.push_back(1);
    if(num>=2) {
      list<int>::iterator k = powers.begin();
      for(int i=2;i<=num;++i,++j) {
        if((* j)==var) {
//        GBStream << "repeating on " << *j << '\n';
          ++(* k); // *k is powers[k];
        } else {
//        GBStream << "starting on " << *j << '\n';
	  var = *j;
          trees.push_back(var);
          powers.push_back(1);
          ++k;
        }
      }
    }
    GBStream.flush();
    const list<Variable> & L1 = trees;
    const list<int> &      L2 = powers;
    list<Variable>::const_iterator tree_current = L1.begin();
    list<int>::const_iterator power_current = L2.begin();
    const int treesSizem1 = L1.size()-1;
    for(int i=1;i<=treesSizem1;++i,++tree_current,++power_current) {
      const Variable & var = * tree_current;
      os << var;
      if((* power_current)!=1) {
        os << '^' << * power_current;
      }
      os << (var.commutativeQ() ? " * " : " ** ");
    }
    if(L1.size() > 0) {
      os << * tree_current;
      if((*power_current)!=1) {
        os << '^' << * power_current;
      }
    }
  }
};
#endif
