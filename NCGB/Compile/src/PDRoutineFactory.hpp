// PDRoutineFactory.h

#ifndef INCLUDED_PDROUTINEFACTORY_H
#define INCLUDED_PDROUTINEFACTORY_H

#include "load_flags.hpp"
#include "EditChoices.hpp"
#ifdef PDLOAD
#ifdef WANT_MNGRSUPER
#include "BaRoutineFactory.hpp"
class MngrStart;

class PDRoutineFactory : public BaRoutineFactory {
  PDRoutineFactory(const PDRoutineFactory &);
    // not implemented
  void operator=(const PDRoutineFactory &);
    // not implemented
public:
  PDRoutineFactory() : BaRoutineFactory(s_ID) {};
  virtual ~PDRoutineFactory();

  virtual MngrStart * create();
  static const int s_ID;
};
#endif
#endif
#endif
