// Mark Stankus 1999 (c)
// SimpleTable.h

#ifndef INCLUDED_SIMPLE_TABLE_H
#define INCLUDED_SIMPLE_TABLE_H

#include "Holder.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#include <utility>
#else
#include <vector.h>
#include <pair.h>
#endif

template<class CLASS>
class SimpleTable {
  // BEGIN MAURICIO 
  // typedef vector<pair<int,void(*)(CLASS &,Holder &)> > VEC;
  // typedef vector<pair<int,void(*)(CLASS &,const Holder &)> > VECC;
  typedef typename std::vector<typename std::pair<int, void(*)(CLASS &, Holder &)> > VEC;
  typedef typename std::vector<typename std::pair<int, void(*)(CLASS &, const Holder &)> > VECC;
  // END MAURICIO
  VEC d_V;
  VECC d_VC;
  void error(const CLASS & x,const Holder & h,int);
public:
  SimpleTable() {};
  ~SimpleTable() {};
  void execute(CLASS & x, Holder & h);
  void executeconst(CLASS & x, const Holder & h);
  void add(int i,void(*f)(CLASS &, Holder &));
  void addconst(int i,void(*f)(CLASS &, const Holder &));
};
#endif
