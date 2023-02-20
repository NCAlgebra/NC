// Mark Stankus 1999 (c)
// ColoredGraphHTML.hpp

#ifndef INCLUDE_COLOREDGRAPHHTML_H
#define INCLUDE_COLOREDGRAPHHTML_H

class HTML;
#include <set>
#include <vector>
#include "ColoredGraph.hpp"


template<class Vertex,class Color>
vector<HTML*> print(const ColoredGraph<Vertex,Color> &,const Vertex &, set<Vertex>);

template<class Vertex,class Color>
vector<HTML*> print(const ColoredGraph<Vertex,Color> &  x);

template<class Vertex,class Color>
inline HTML * HTMLFor(ColoredGraph<Vertex,Color> & x,const Vertex & v) const {
  HTML * result;
  if(s_includecolor) {
    HTMLTable * table= new HTMLTable(false);
    table->add(new HTMLVerbatim(v.d_s.c_str()),1,1);
    table->add((*d_vertexColoring.find(v)).second.HTMLFor(),1,2);
    result = table;
  } else {
    result = new HTMLVerbatim(v.d_s.c_str());
  };
  return result;
};
#endif
