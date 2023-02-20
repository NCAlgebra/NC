#include "GraphVertex.hpp"
#include "ColoredGraph.hpp"
#include "ColoredGraphHTML.hpp"
#include "TriColor.hpp"
#include "readDoubleColumnGraph.hpp"
//#include "readSingleColumn.hpp"
#include <assert.h>
#include <fstream>
#include <set>
#include <vector>

int main() {
  bool updown; 
#if 0
  updown = true; // base class is NOT root
#else
  updown = false; // base class is root 
#endif
  ColoredGraph<GraphVertex,TriColor> gr;
  set<GraphVertex> super;
  ifstream ifs1("classespublic.txt");
  readDoubleColumnGraph(ifs1,super,gr,updown);
  vector<HTML*> V(print(gr));
  vector<HTML*>::const_iterator w = V.begin(), e = V.end();
  MyOstream os(cerr);
  os << "<html><body>\n";
  while(w!=e) {
    (*w)->print(os);
    ++w;
  };
  os << "</body></html>\n";
};

#ifdef USE_UNIX
#include "ColoredGraph.c"
#else
#include "ColoredGraph.cpp"
#endif
bool ColoredGraph<GraphVertex,TriColor>::s_includecolor = false;
template class ColoredGraph<GraphVertex,TriColor>;
