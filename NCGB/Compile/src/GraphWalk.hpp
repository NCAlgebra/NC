// GraphWalk.h

#ifndef GraphWalk_h
#define GraphWalk_h

#include "load_flags.hpp"
#ifdef PDLOAD

#ifndef INCLUDED_GRAPH_H
#include "Graph.hpp"
#endif

class GraphWalk {
   GraphWalk();
     // not implemented
   GraphWalk(const GraphWalk &);
     // not implemented
   void operator = (const GraphWalk &);
     // not implemented
public:
  explicit GraphWalk(const Graph & aGraph);
  ~GraphWalk();
  void setDesiredLeafsVector(const GBVector<int> & desireLeafs);
  void setDesiredLeafs(const int *  arrayPointer,int len);
  bool walkThroughStartingAt(int start);
  void setProtectedLeafs(const int * arrayPointer,int len);
  const GBVector<int> & desiredLeafs() const;
private:
  int d_cnt;
  bool walkThroughStartingAtAux(int start);
  const Graph & d_graph;
  GBVector<int> d_desireLeafs;
  GBVector<int> d_protected;
  GBVector<int> d_leafGoodOrNot;
  void markUnencountered(int i);
  void markEncountered(int i,bool flag);
  void markEverythingUnencountered();
  bool encountered(int n) const;
};

inline GraphWalk::GraphWalk(const Graph & aGraph) : d_cnt(0),
  d_graph(aGraph), d_desireLeafs(), d_protected(), d_leafGoodOrNot() { };

inline GraphWalk::~GraphWalk() {};

inline const GBVector<int> & GraphWalk::desiredLeafs() const {
  return d_desireLeafs;
};
 
// 2 means unencountered
// 1 means encountered and the result of walkThroughStartingAt
//     has been determined to be true
// 0 means encountered and the result of walkThroughStartingAt
//     has been determined to be false
inline bool GraphWalk::encountered(int i) const {
  return d_leafGoodOrNot[i] != 2;
};

inline void GraphWalk::markUnencountered(int i) {
  d_leafGoodOrNot[i] = 2;
};

inline void GraphWalk::markEncountered(int i,bool flag) {
  d_leafGoodOrNot[i] =  flag ? 1 : 0;
}; 
#endif
#endif
