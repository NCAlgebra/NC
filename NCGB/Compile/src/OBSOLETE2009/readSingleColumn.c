// Mark Stankus 1999 (c)

#include "GraphVertex.hpp"
#include "ColoredGraph.hpp"
#include "TriColor.hpp"
#include <assert.h>
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#include <string>
#include <set>
#include <list>
#include <iterator>
#include <algorithm>
#else
#include <fstream.h>
#include <string.h>
#include <set.h>
#include <list.h>
#include <iterator.h>
#include <algo.h>
#endif


void readSingleColumn(ifstream & ifs,ColoredGraph<GraphVertex,TriColor> & gr) {
  TriColor C(TriColor::s_one);
  bool inWord = false;
  int i=1;
  string vec;
  char c;
  while(!ifs.eof()) {
    ifs.get(c); 
    if(c==' ' || c=='\r') {
      if(inWord) {
        inWord = false;
        if(vec!="") {
          GraphVertex v0(vec);
          gr.colorVertex(v0,C);
          inWord = false;
          vec="";
        };
      };
    } else if(c=='\n') {
      if(vec!="") {
        GraphVertex v0(vec);
        gr.colorVertex(v0,C);
        inWord = false;
        vec="";
      };
      ++i;
    } else if(inWord) {
      vec += c;
    } else {
      inWord = true;
      vec = c;
    };
  }; 
  assert(vec=="");
};
