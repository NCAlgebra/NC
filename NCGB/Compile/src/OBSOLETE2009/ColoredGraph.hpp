// Mark Stankus (c) 1999
// ColoredGraph.hpp

#ifndef INCLUDED_COLOREDGRAPH_H
#define INCLUDED_COLOREDGRAPH_H

#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <iostream>
#include <list>
#include <map>
#include <set>
#include <functional>
#else
#include <iostream.h>
#include <list.h>
#include <map.h>
#include <set.h>
#include <function.h>
#endif

template<class Vertex,class Color>
class ColoredGraph {
  static bool s_includecolor;
  typedef map<Vertex,list<Vertex>,less<Vertex> > MAPONE;
  typedef map<Vertex,Color,less<Vertex> > MAPTWO;
  MAPONE d_children;
  MAPTWO d_vertexColoring;
public:
  ColoredGraph(){};
  ~ColoredGraph(){};
  void clearColoring();
  void clearChildren();
  void addEdge(const Vertex & from,const Vertex & to);
  void addVertex(const Vertex & from);
  void colorVertex(const Vertex & v,const Color & c);
  const MAPONE & childrenMap() const {
    return d_children;
  };
  const MAPTWO & coloring() const {
    return d_vertexColoring;
  };
  void ColorChildComponents(const Color & startingColor,
                            const Color & endingColor);
  void ColorParentComponents(const Color & colored,const Color & uncolored);
  void ColorParentComponents(const Color & colored);
  list<Vertex> getColored(const Color & C) const {
    list<Vertex> result;
    typedef MAPTWO::const_iterator MI;
    MI w =  d_vertexColoring.begin(), e =  d_vertexColoring.end();
    while(w!=e) {
      const pair<const Vertex,Color> & pr = *w;
      if(pr.second==C) result.push_back(pr.first);
      ++w;
    };
    return result;
  }; 
  void findRoots(set<Vertex,less<Vertex> > & S) const {
    typedef MAPONE::const_iterator MI;
    typedef MAPTWO::const_iterator CMI;
    typedef list<Vertex>::const_iterator LI;
      // empty S.
    S.erase(S.begin(),S.end());
      // Put all vertices into S
    CMI w2 =  d_vertexColoring.begin(), e2 =  d_vertexColoring.end();
    while(w2!=e2) {
      S.insert((*w2).first);
      ++w2;
    };
    cerr << S.size() << " nodes.\n";
    MI w =  d_children.begin(), e =  d_children.end();
    LI w3,e3;
    set<Vertex,less<Vertex> >::iterator sf,se = S.end();
      // Remove vertices which are children
    while(w!=e) {
      const list<Vertex> & L = (*w).second;
      w3 = L.begin();e3 = L.end();
      while(w3!=e3) {
        sf = S.find(*w3);
        if(sf!=se) {
          S.erase(sf);
          se = S.end();
        };
        ++w3;
      }; 
      ++w;
    };
    cerr << S.size() << " roots.\n";
  };
};
#endif
