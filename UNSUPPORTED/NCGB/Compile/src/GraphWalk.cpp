//  GraphWalk.c

#include "GraphWalk.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"

// Fill out the list if necessary
// Set all vertices unencountered.
void GraphWalk::markEverythingUnencountered() {
  const int diff = d_graph.numberOfVertices() - d_leafGoodOrNot.size();
  d_leafGoodOrNot.reserve(d_graph.numberOfVertices());
  int i=1;
  for(;i<=diff;++i) {
    d_leafGoodOrNot.push_back(0);
  };
  const int sz = d_graph.numberOfVertices();
  for(i=1;i<=sz;++i) {
    markUnencountered(i);
  }
};

// This function return true if the vertex "start" has
// a certain property OR this function returns true
// for each of the vertex's children.
// A vertex has the above mentioned property
// if it is not zero and it is a desired leaf
// (i.e., initially encounted) or has
// been determined to have this property
// during previous walks through the graph.
bool GraphWalk::walkThroughStartingAtAux(int start) {
  bool result;
  if(start==0) {
    result = false;
  } else if(encountered(start)) {
    result = d_leafGoodOrNot[start]!=0;
  } else {
//    const GBList<int> & children = _graph.edgesFrom(start);
    const GBList<int> children = d_graph.edgesFrom(start);
    const int len = children.size();
    result = len!=0;
    if(result) {
      // This implements an AND.
      GBList<int>::const_iterator w = children.begin();
      for(int i=1;i<=len && result;++i,++w) {
        result =  walkThroughStartingAtAux(*w);
      }
    };
    markEncountered(start,result);
  }
  return result;
};

// This function return true if and only if the 
// vertex start has a nonzero number of children
// and for each path from "start" to a leaf
// there is a vertex of the path which is a desired leaf
// (that is, encountered initially) or has been determined
// by previous walks through the graph.
bool GraphWalk::walkThroughStartingAt(int start) {
  const GBList<int> & edges = d_graph.edgesFrom(start);
  int len = edges.size();
  bool result = false;
  if(len>0) {
    // Check each of the children
    // This essentially implements an AND.
    result = true;
    GBList<int>::const_iterator k = edges.begin();
    for(int j=1;j<=len && result;++j,++k) {
      result = walkThroughStartingAtAux(*k);
    }
  }
  return result;
};

// Protected leafs are not yet implemented
void GraphWalk::setProtectedLeafs(const int * arrayPointer,int len) {
  d_protected.clear();
  for(int i=0;i<len;++i) {
    DBG();
    d_protected.push_back(arrayPointer[i]);
    markEncountered(arrayPointer[i],true);
  };
};

// Desired leafs...This is usually WhatAreGBNumbers[]
void GraphWalk::setDesiredLeafs(const int * arrayPointer,int len) {
  markEverythingUnencountered();
  d_desireLeafs.clear();
  d_desireLeafs.reserve(len);
  for(int i=0;i<len;++i) {
    d_desireLeafs.push_back(arrayPointer[i]);
    markEncountered(arrayPointer[i],true);
  };
}; 

// Desired leafs...This is usually WhatAreGBNumbers[]
void GraphWalk::setDesiredLeafsVector(const GBVector<int> & theLeafs) {
  markEverythingUnencountered();
  d_desireLeafs = theLeafs;
  const int sz = d_desireLeafs.size();
  for(int i=1;i<=sz;++i) {
GBStream << "MXS:GraphWalk:" <<  i << '\n';
    markEncountered(d_desireLeafs[i],true);
  }
}; 
