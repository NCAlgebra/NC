// Mark Stankus 1999 (c)

#include "GraphVertex.hpp"
#include "ColoredGraph.hpp"
#include "TriColor.hpp"
#include <assert.h>
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#include <string>
#include <set>
#include <iterator>
#include <algorithm>
#else
#include <fstream.h>
#include <string.h>
#include <set.h>
#include <iterator.h>
#include <algo.h>
#endif

void readDoubleColumnGraph(ifstream & ifs,set<GraphVertex,less<GraphVertex> > & S, 
              ColoredGraph<GraphVertex,TriColor> & gr,bool forward) {
  bool inWord = false;
  int word = 0;
  int i=1;
  string vec[2];
  char c;
  while(!ifs.eof()) {
    ifs.get(c); 
    if(c==' ' || c=='\r') {
      if(inWord) {
        inWord = false;
      };
    } else if(c=='\n') {
      assert(word==2 || word==0);
      if(word==2) {
        GraphVertex v0(vec[0]);
        GraphVertex v1(vec[1]);
        S.insert(v0);
        if(forward) {
          gr.addEdge(v0,v1);
        } else {
          gr.addEdge(v1,v0);
        };
        word = 0;
        inWord = false;
        vec[0]="";
        vec[1]="";
      };
      ++i;
    } else if(inWord) {
      vec[word-1] += c;
    } else {
      inWord = true;
      ++word;
      assert(word<=2);
      vec[word-1] = c;
    };
  }; 
  assert(vec[1]=="");
};
