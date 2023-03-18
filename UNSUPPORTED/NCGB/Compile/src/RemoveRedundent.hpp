// RemoveRedundent.h

#ifndef INCLUDED_REMOVEREDUNDENT_H
#define INCLUDED_REMOVEREDUNDENT_H

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "vcpp.hpp"

class RemoveRedundent {
  RemoveRedundent();
    // not implemented
  RemoveRedundent(const RemoveRedundent &);
    // not implemented
  void operator=(const RemoveRedundent &);
    // not implemented
private:
  int d_ID;
protected:
  explicit RemoveRedundent(int id) : d_ID(id) {};
public:
  virtual ~RemoveRedundent() = 0;
  virtual void setDesiredLeafs(int * input,int len) = 0;
  virtual vector<int> tryToEliminate() = 0;
};
#endif 
