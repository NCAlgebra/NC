// Mark Stankus 1999 (c)
// ColoredGraphHTML.cpp

#include "ColoredGraphHTML.hpp"

#include "HTML.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"
#include <algorithm>
#include <iterator>
#include <set>
#include <vector>
#include "ColoredGraph.hpp"

template<class Vertex,class Color>
vector<HTML*> print(const ColoredGraph<Vertex,Color> &  x,const Vertex & v,
  set<Vertex> S) {
  vector<HTML*> result;
  bool border = true;
  HTMLTable * table = new HTMLTable(border); 
  result.push_back(table);
  if(S.find(v)==S.end()) {
    table->add(x.HTMLFor(v),1,1);
    typedef map<Vertex,list<Vertex> >::const_iterator MI;
    MI w = x.childrenMap().find(v),e = x.childrenMap().end();
    if(w!=e) {
      // has children
      const list<Vertex> & L = (*x.childrenMap().find(v)).second;
      typedef list<Vertex>::const_iterator LI;
      LI ww = L.begin(), ee = L.end();
      if(ww!=ee) {
        HTMLTable * tab = new HTMLTable(border);
        table->add(tab,1,2);
        int i = 1;
        while(ww!=ee) {
          vector<HTML*> V = print(x,*ww,S);
          typedef vector<HTML*>::const_iterator VI; 
          VI w2 = V.begin(), e2 = V.end();
          while(w2!=e2) {
            tab->add(*w2,i,1);
            ++w2;
          };
          ++ww;++i;
        };
      };
    }; // if(ww!=ee) 
  } else {
    table->add(new HTMLVerbatim("Loop on"),1,1);
    table->add(x.HTMLFor(v),2,1);
  };
  return result;
};

template<class Vertex,class Color>
vector<HTML*> print(const ColoredGraph<Vertex,Color> &  x) {
  vector<HTML*> result;
  set<Vertex> roots,path;
  x.findRoots(roots);
  typedef set<Vertex>::const_iterator SI;
  SI w =  roots.begin(), e =  roots.end();
  while(w!=e) {
    const Vertex & v =  *w;
    set<Vertex> S;
    vector<HTML*> rooted = print(x,v,S);
    copy(rooted.begin(),rooted.end(),back_inserter(result));
    result.push_back(new HTMLVerbatim("<br><hr><br>"));
    ++w;
  };
  return result;
};

#include "GraphVertex.hpp"
#include "TriColor.hpp"
template vector<HTML*> print(const ColoredGraph<GraphVertex,TriColor> &  x,const GraphVertex & v,set<GraphVertex> S);
template vector<HTML*> print(const ColoredGraph<GraphVertex,TriColor> &  x);
