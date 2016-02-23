// SBGBAlg.h

#ifndef INCLUDED_SBGBALG_H
#define INCLUDED_SBGBALG_H

#include "GBAlg.hpp"
#include "Polynomial.hpp"
#pragma warning(disable:4786)]
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
class Reduction;
#include "vcpp.hpp"


using namespace std;

class SBGBAlg : public GBAlg  {
  SBGBAlg();
    // not implemented
  SBGBAlg(const SBGBAlg &);
    // not implemented
  void operator=(const SBGBAlg &);
    // not implemented
  Reduction & d_red;
  list<Polynomial> d_L;
  int d_iter;
public:
  SBGBAlg(Reduction & red,list<Polynomial> & L,int iter) : 
     d_red(red), d_L(L), d_iter(iter) {};
  virtual ~SBGBAlg();
  virtual bool perform();
};
#endif
