// Graph.h

#ifndef INCLUDED_GRAPH_H
#define INCLUDED_GRAPH_H

#include "load_flags.hpp"
#ifdef PDLOAD
#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif
#ifndef INCLUDED_GBLIST_H
#include "GBList.hpp"
#endif
#ifndef INCLUDED_MEMBER_H
#include "Member.hpp"
#endif
//#pragma warning(disable:4661)

class Graph {
  Graph();
    // not implemented
  Graph(const Graph &);
    // not implemented
  void operator=(const Graph &);
    // not implemented
public:
  explicit Graph(int nvertices);
  ~Graph(){};
  void addVertex();
  void addEdge(int from,int to);
  const GBList<int> & edgesFrom(int from) const;
  int numberOfVertices() const;
    void print(MyOstream & os) const;
private:
  int _nvertices;
  GBVector<GBList<int> > _edges;
};

MyOstream & operator << (MyOstream & os,const Graph & g);

inline void Graph::addEdge(int from,int to) {
  insertIfNotMember(_edges[from],to);
};

inline const GBList<int> & Graph::edgesFrom(int from) const {
  return _edges[from];
};

inline int Graph::numberOfVertices() const {
  return _nvertices;
};

inline void Graph::addVertex() {
  ++_nvertices;
  GBList<int> emptyList;
  _edges.push_back(emptyList);
};
#endif
#endif
