// StartUpCommon.c

#include "StartUpCommon.hpp"
#include "Edit4ThisFile.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"
#include "CreateNewFactory.hpp"
#include "PlatformSpecific.hpp"
#include "ExperienceLevel.hpp"
#include "AllTimings.hpp"
#include "Debug1.hpp"
#include "UserOptions.hpp"
#include "CreateOrder.hpp"
#include "FieldChoice.hpp"
#include "choose_mynew.hpp"
#include "MyOstream.hpp"

#ifdef MYNEW
#include "mynew.hpp"
#endif

void StartUpFields();

#include "MLex.hpp"

void PrintFactorySetting() {
  GBStream << "> You are using factory version:" 
           << UserOptions::s_FactorySetting << '\n';
};

void StartUpCommon() {
  Debug1::s_before_crash = PrintFactorySetting;
  Variable::s_newStringList();
  s_inInitialize = false;
#ifdef SEMIGROUP_IMPLEMENTATION
#if 0
  NCSemigroup rc_sg;
  CSemigroup rc_sg;
#else
  CNCSemigroup rc_sg;
#endif
  Monomial::s_setDefault(rc_sg);
#endif
  Debug1::s_DebugSetUp();
  AllTimings temp;
  CreateNewFactory();
  GBStream << "Starting Main\n";
  Debug1::s_Pause();

  setOrderAdopt(CreateOrder());
  ExperienceLevel::s_setExperienceLevel(
  PlatformSpecific::s_default_user_level,true);
#ifdef USE_VIRT_FIELD
  StartUpFields();
#endif
};

void EndUpCommon() {
#ifdef MYNEW
  reportAllUndeleted();
#endif
};
