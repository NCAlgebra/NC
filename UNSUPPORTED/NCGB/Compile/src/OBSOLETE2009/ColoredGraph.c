// Mark Stankus (c) 1999
// ColoredGraph.cpp

#include "ColoredGraph.hpp"
#include <algorithm>

template<class Vertex,class Color>
void ColoredGraph<Vertex,Color>::clearColoring() {
  Color C;
  typedef MAPTWO::iterator MI;
  MI w = d_vertexColoring.begin(), e = d_vertexColoring.end();
  while(w!=e) {
    (*w).second = C; 
    ++w;
  };
};

template<class Vertex,class Color>
void ColoredGraph<Vertex,Color>::clearChildren() {
  list<Vertex> empty;
  typedef MAPONE::iterator MI;
  MI w = d_children.begin(), e = d_children.end();
  while(w!=e) {
    (*w).second = empty; 
    ++w;
  };
};

template<class Vertex,class Color>
void ColoredGraph<Vertex,Color>::addEdge(const Vertex & from,const Vertex & to) {
  addVertex(from);
  addVertex(to);
  list<Vertex> & L = d_children[from];
    // do not add duplicates
  if(find(L.begin(),L.end(),to)==L.end()) {
    d_children[from].push_back(to);
  };
};


template<class Vertex,class Color>
void ColoredGraph<Vertex,Color>::addVertex(const Vertex & x) {
  typedef MAPTWO::iterator MI;
  MI w = d_vertexColoring.find(x), e = d_vertexColoring.end();
  // if not found
  if(w==e) {
    Color C;
    pair<const Vertex,Color> pr(x,C);
    d_vertexColoring.insert(pr);
  };
};

template<class Vertex,class Color>
void ColoredGraph<Vertex,Color>::colorVertex(const Vertex & v,const Color & c) {
  addVertex(v);
  d_vertexColoring[v] = c;
};

template<class Vertex,class Color>
void ColoredGraph<Vertex,Color>::ColorChildComponents(
       const Color & startingColor,const Color & endingColor) {
  typedef MAPTWO::iterator MI;
  bool done = false;
  while(!done) {
    MI w = d_vertexColoring.begin(), e = d_vertexColoring.end();
    done = true;
    while(w!=e) {
      pair<const Vertex,Color> & pr = (*w);
      if(pr.second==startingColor) {
         const list<Vertex> & L = d_children[pr.first];
         list<Vertex>::const_iterator ww = L.begin(), ee = L.end(); 
         while(ww!=ee) {
           const Vertex & vv = *ww;
           if(d_vertexColoring[vv]!=startingColor && 
              d_vertexColoring[vv]!=endingColor) {
             d_vertexColoring[vv]=startingColor; done = false;
           };
           ++ww;
         }; 
         pr.second = endingColor;
      };
      ++w;
    };
  };
};

template<class Vertex,class Color>
void ColoredGraph<Vertex,Color>::ColorParentComponents(const Color & aColor) {
  typedef MAPTWO::iterator MI;
  bool done = false;
  while(!done) {
    MI w = d_vertexColoring.begin(), e = d_vertexColoring.end();
    done = true;
    while(w!=e) {
      pair<const Vertex,Color> & pr = (*w);
      if(pr.second!=aColor) {
        const list<Vertex> & L = d_children[pr.first];
        list<Vertex>::const_iterator ww = L.begin(), ee = L.end(); 
        if(ww!=ee) {
          bool checkedChildren = true;
          while(ww!=ee) {
            if(d_vertexColoring[*ww]==aColor) {
              checkedChildren = false;
              break;
            };
            ++ww;
          }; 
          if(checkedChildren) {
             pr.second = aColor;
             done = false;
          };
        };
      };
      ++w;
    };
  };
};

template<class Vertex,class Color>
void ColoredGraph<Vertex,Color>::ColorParentComponents(
           const Color & aColor,const Color & notcolored) {
  typedef MAPTWO::iterator MI;
  bool done = false;
  while(!done) {
    MI w = d_vertexColoring.begin(), e = d_vertexColoring.end();
    done = true;
    while(w!=e) {
      pair<const Vertex,Color> & pr = (*w);
      if(pr.second!=aColor) {
         const list<Vertex> & L = d_children[pr.first];
         list<Vertex>::const_iterator ww = L.begin(), ee = L.end(); 
         if(ww==ee) {
           pr.second = notcolored;
         } else {
           bool checkedChildren = true;
           while(ww!=ee) {
             if(d_vertexColoring[*ww]==aColor) {
               checkedChildren = false;
               break;
             };
             ++ww;
           }; 
           if(checkedChildren) {
              pr.second = aColor;
              done = false;
           };
         }; // if(ww==ee) 
      }; // if(pr.second!=aColor) 
      ++w;
    }; // while(w!=e)
  };
  MI w = d_vertexColoring.begin(), e = d_vertexColoring.end();
  while(w!=e) {
    Color & C = (*w).second;
    if(C !=aColor) {
      C = notcolored;
    };
    ++w;
  };
};
