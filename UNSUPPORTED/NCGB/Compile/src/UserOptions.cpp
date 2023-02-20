// UserOptions.c

#include "UserOptions.hpp"
#include "RecordHere.hpp"
#include "GBStream.hpp"
#include "load_flags.hpp"
extern const int  UserOptions_FactoryDefault;
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#ifndef INCLUDED_VERSIONCONTROL_H
#include "VersionControl.hpp"
#endif
#include "MyOstream.hpp"

int  UserOptions::s_FactorySetting = 0;
const int UserOptions_FactoryDefault = 0;

bool UserOptions::s_recordHistory = true;
bool UserOptions::s_RecordHistoryReductions = true;
bool UserOptions::s_Experimental = 0;
bool UserOptions::s_supressOutput = false; 
bool UserOptions::s_supressAllCOutput= false;
bool UserOptions::s_cutOffs = false;
int  UserOptions::s_minNumber = 0;
int  UserOptions::s_sumNumber = 0;
bool UserOptions::s_shouldStopForHighDegree = false;
int  UserOptions::s_stopForDegree = 0;

void UserOptions::reset() {
  UserOptions::s_recordHistory = true;
  UserOptions::s_RecordHistoryReductions = true;
  GBStream << "MXS:UserOptions_FactoryDefault:"
           << UserOptions_FactoryDefault << '\n';
  UserOptions::s_FactorySetting = UserOptions_FactoryDefault;
  UserOptions::s_Experimental = 0;
  UserOptions::s_supressOutput = false; 
  UserOptions::s_supressAllCOutput= false;
  UserOptions::s_cutOffs = false;
  UserOptions::s_minNumber = 0;
  UserOptions::s_sumNumber = 0;
  UserOptions::s_shouldStopForHighDegree = false;
  UserOptions::s_stopForDegree = 0;
};

void UserOptions::s_experimental(bool yn) {
  s_Experimental = yn;
  if(s_Experimental) {
    for(int i=1;i<=5;++i) {
      GBStream << "Turing experimental code on!!!\n";
    }
  }
};

bool UserOptions::s_experimental() {
  return s_Experimental;
};

int UserOptions::s_SelectionOutputMethod = 1;

VersionControl * UserOptions::s_versionControl_p = 0;

void UserOptions::s_VersionNumber(float f,const char * const) {
  if(!s_versionControl_p) {
    RECORDHERE(s_versionControl_p = new VersionControl();)
  };
  s_versionControl_p->d_mma = f;
};

float UserOptions::s_VersionNumber(const char * const) {
  if(!s_versionControl_p) {
    RECORDHERE(s_versionControl_p = new VersionControl();)
  };
  return s_versionControl_p->d_mma;
};

bool UserOptions::s_UseSubMatch = false; // MXS
bool UserOptions::s_TellMultiGradedLex = false; 
