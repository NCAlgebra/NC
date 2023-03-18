// BaRoutineFactory.c

#include "BaRoutineFactory.hpp"
#include "UserOptions.hpp"
#include "GBStream.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

// ------------------------------------------------------------------

void BaRoutineFactory::s_setCurrent() {
  DBG();
};

// ------------------------------------------------------------------

void BaRoutineFactory::s_setCurrent(BaRoutineFactory * p) {
  s_Current_p = p;
};

// ------------------------------------------------------------------

BaRoutineFactory & BaRoutineFactory::s_getCurrent() {
  if(!s_Current_p) s_setCurrent();
  return * s_Current_p;
};

// ------------------------------------------------------------------

bool BaRoutineFactory::s_currentValid() {
  return !! s_Current_p;
};

// ------------------------------------------------------------------

BaRoutineFactory::~BaRoutineFactory(){};

// ------------------------------------------------------------------

BaRoutineFactory * BaRoutineFactory::s_Current_p = 0;

void PrintFactorySetting() {
  GBStream << "> You are using factory version:"
           << UserOptions::s_FactorySetting << '\n';
};

#include "StartEnd.hpp"
#include "Debug1.hpp"

struct setPrintFactorySetting : public AnAction {
  setPrintFactorySetting() : AnAction("setprintfactorysetting") {};
  void action();
};

void setPrintFactorySetting::action() {
  Debug1::s_before_crash =  PrintFactorySetting;
};

AddingStart temp1BaRoutineFactory(new setPrintFactorySetting);

