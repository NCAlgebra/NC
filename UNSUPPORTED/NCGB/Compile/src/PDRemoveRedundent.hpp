// PDRemoveRedundent.h

#ifndef INCLUDED_PDREMOVEREDUNDENT_H
#define INCLUDED_PDREMOVEREDUNDENT_H

#include "load_flags.hpp"
#ifdef PDLOAD
#ifndef INCLUDED_REMOVEREDUNDENT_H
#include "RemoveRedundent.hpp"
#endif
#ifndef INCLUDED_GRAPHWALK_H
#include "GraphWalk.hpp"
#endif
#include "GBVector.hpp"
class FactControl;

class PDRemoveRedundent : public RemoveRedundent {
  PDRemoveRedundent();
    // not implemented
  PDRemoveRedundent(const PDRemoveRedundent &);
    // not implemented
  void operator=(const PDRemoveRedundent &);
    // not implemented
public:
  explicit PDRemoveRedundent(const FactControl & fc);
  virtual ~PDRemoveRedundent();

  virtual void setDesiredLeafs(int * input,int len);
  virtual void setDesiredLeafsVector(const GBVector<int> &);
  virtual vector<int> tryToEliminate();
  static const int s_ID;
private:
  void updateGraph();
  Graph d_graph;
  const FactControl & d_fc;
  GraphWalk * d_walk;
};
#endif 
#endif 
