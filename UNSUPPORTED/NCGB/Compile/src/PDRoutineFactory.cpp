// PDRoutineFactory.c

#include "PDRoutineFactory.hpp"
#include "load_flags.hpp"
#include "CreateOrder.hpp"
#ifdef PDLOAD
#ifdef WANT_MNGRSUPER
#ifndef INCLUDED_MNGRSUPER_H
#include "MngrSuper.hpp"
#endif
#ifndef INCLUDED_IDVALUE_H
#include "idValue.hpp"
#endif
#include "RecordHere.hpp"

PDRoutineFactory::~PDRoutineFactory(){};

MngrStart * PDRoutineFactory::create() {
  RECORDHERE(MngrSuper * result = new MngrSuper();)
  setOrderAdopt(CreateOrder());
  return result;
};

const int PDRoutineFactory::s_ID = idValue("PDRoutineFactory::s_ID");
#endif
#endif
