// AdmissibleOrder.c


#include "AdmissibleOrder.hpp"
#include "load_flags.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#ifndef INCLUDED_VARIABLE_H
#include "Variable.hpp"
#endif
#ifndef INCLUDED_MLEX_H
#include "MLex.hpp"
#endif
#include "CreateOrder.hpp"
//#pragma warning(disable:4786)
#ifndef INCLUDED_VECTOR_H
#define INCLUDED_VECTOR_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#endif

#include "vcpp.hpp"
  
AdmissibleOrder::~AdmissibleOrder() {};

// ------------------------------------------------------------------

AdmissibleOrder * AdmissibleOrder::s_Current_p = 0;

// ------------------------------------------------------------------

void AdmissibleOrder::s_setCurrentClone(AdmissibleOrder * p) {
  if(p==s_Current_p) errorc(__LINE__);
  if(s_Current_p) {
    RECORDHERE(delete s_Current_p;)
  }
  s_Current_p = p->clone();
};

// ------------------------------------------------------------------

void AdmissibleOrder::s_setCurrentAdopt(AdmissibleOrder * p) {
  if(p==s_Current_p) errorc(__LINE__);
  if(s_Current_p) {
    RECORDHERE(delete s_Current_p;)
  }
  s_Current_p = p;
};

void AdmissibleOrder::errorh(int n) { DBGH(n); };

void AdmissibleOrder::errorc(int n) { DBGC(n); };
