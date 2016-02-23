// Graph.c

#include "Graph.hpp"
#include "load_flags.hpp"
#ifdef PDLOAD
#include "MyOstream.hpp"

Graph::Graph(int nvertices) : _nvertices(nvertices) {
  GBList<int> emptyList;
  _edges.reserve(nvertices);
  for(int i=1;i<=nvertices;++i) {
    _edges.push_back(emptyList);
  };
};

void Graph::print(MyOstream & os) const {
  os << "Edges for the graph -- begin\n";
  int numberOnLine = 0;
  for(int k=1;k<=_nvertices;++k) {
    const int len = _edges[k].size();
    GBList<int>::const_iterator w = _edges[k].begin();
    for(int j=1;j<=len;++j,++w) {
      os << '(' << k << ',' << *w << ')';
      ++numberOnLine;
      if(numberOnLine>11) {
        os << '\n';
        numberOnLine = 0;
      }
    }
  };
  if(numberOnLine>0) os << '\n';
  os << "Edges for the graph -- end\n";
};

MyOstream & operator << (MyOstream & os,const Graph & g) { 
  g.print(os); 
  return os;
};

#include "Choice.hpp"
#include "GBVector.cpp"
#include "constiterGBVector.cpp"
#include "iterGBVector.cpp"

template class GBVector<GBList<int> >;
template class iter_GBVector<GBList<int> >;
template class const_iter_GBVector<GBList<int> >;
#endif
