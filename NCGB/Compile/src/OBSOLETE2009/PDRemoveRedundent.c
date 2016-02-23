// PDRemoveRedundent.c

#include "PDRemoveRedundent.hpp"
#include "load_flags.hpp"
#include "RuleIDSetImpl.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif

#ifdef PDLOAD
#ifndef INCLUDED_FACTCONTROL_H
#include "FactControl.hpp"
#endif
#include "MyOstream.hpp"

PDRemoveRedundent::~PDRemoveRedundent(){};

// The numbers which we are going to do RR on.
// This is usually WhatAreGBNumbers[].
void PDRemoveRedundent::setDesiredLeafs(int * input,int len) {
  d_walk->setDesiredLeafs(input,len);
};

void PDRemoveRedundent::setDesiredLeafsVector(const GBVector<int> & x) {
  d_walk->setDesiredLeafsVector(x);
};

// Fill in the graph with the fact control
PDRemoveRedundent::PDRemoveRedundent(const FactControl & fc) : 
    RemoveRedundent(s_ID), d_graph(fc.numberOfFacts()), d_fc(fc), d_walk(0) {
  const int totallen = fc.numberOfFacts();
  int i,temp;
  for(int item=1;item<=totallen;++item) {
    temp = d_fc.history(item).first();
    if(temp<0) temp = -temp;
    d_graph.addEdge(item,temp);
    temp = d_fc.history(item).second();
    if(temp<0) temp = -temp;
    d_graph.addEdge(item,temp);
    const int histlen = d_fc.history(item).reductions().SET().size();
    set<SPIID,less<SPIID> >::const_iterator w =
            d_fc.history(item).reductions().SET().begin();
    for(i=1;i<=histlen;++i,++w) {
       d_graph.addEdge(item,(*w).d_data);
    }
 }
#if 0
 GBStream << "Here is the graph\n";
 GBStream << _graph << '\n';
#endif
 d_walk = new GraphWalk(d_graph);
 if(d_walk==0) DBG();
};

//Expand graph to account for possibly expanded FactControl
void PDRemoveRedundent::updateGraph() {
  if(d_fc.numberOfFacts() > d_graph.numberOfVertices()) {
    const int totallen = d_fc.numberOfFacts();
    const int oldnn = d_graph.numberOfVertices();
    int i,temp;
    for(int item=oldnn+1;item<=totallen;++item) {
      d_graph.addVertex();
      temp = d_fc.history(item).first();
      if(temp<0) temp = -temp;
      d_graph.addEdge(item,temp);
      temp = d_fc.history(item).second();
      if(temp<0) temp = -temp;
      d_graph.addEdge(item,temp);
      const int histlen = d_fc.history(item).reductions().SET().size();
      set<SPIID,less<SPIID> >::const_iterator w =
              d_fc.history(item).reductions().SET().begin();
      for(i=1;i<=histlen;++i,++w) {
         d_graph.addEdge(item,(*w).d_data);
      }
    } 
  }
 GBStream << "Here is the updated graph\n";
 GBStream << d_graph << '\n';
};

// Try to remove redundent
// Return the result
// The numbers which are used must have been set previously.
vector<int> PDRemoveRedundent::tryToEliminate() {
  vector<int> result;
  bool canEliminate;
  const int len = d_walk->desiredLeafs().size();
  int j;
  for(int i=1;i<=len;++i) {
    j = d_walk->desiredLeafs()[i];
    canEliminate = d_walk->walkThroughStartingAt(j);
    if(!canEliminate) result.push_back(j);
  }
  return result;
};

#include "idValue.hpp"
const int PDRemoveRedundent::s_ID = idValue("PDRemoveRedundent::s_ID");
#endif
