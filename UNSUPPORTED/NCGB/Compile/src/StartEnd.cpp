// (c) Mark Stankus 1999
// StartEnd.c

#include "StartEnd.hpp"
#include "GBStream.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "Debug1.hpp"
#include "MyOstream.hpp"

using namespace std;

AnAction::~AnAction(){};

vector< AnAction * > * s_startup = 0;
vector< AnAction * > * s_endup = 0;
vector< AnAction * > * s_crash = 0;
vector< AnAction * > * s_version = 0;

const char * AnAction::s_last = 0;

AddingStart::AddingStart(AnAction *x) {
  if(!s_startup) s_startup = new vector<AnAction*>;
  s_startup->push_back(x);
};

void AddingStart::s_execute() { 
  if(s_startup) {
    typedef vector<AnAction*>::const_iterator VI;
    VI w = s_startup->begin(),e = s_startup->end();
    while(w!=e) {
      (*w)->action();
      ++w;
    };
  };
};

void AddingStart::s_print() { 
  if(s_startup) {
    typedef vector<AnAction*>::const_iterator VI;
    VI w = s_startup->begin(),e = s_startup->end();
    while(w!=e) {
      GBStream << (*w)->d_s << '\n';
      ++w;
    };
  };
};


AddingEnd::AddingEnd(AnAction *x) {
  if(!s_endup) s_endup = new vector<AnAction*>;
  s_endup->push_back(x);
};

void AddingEnd::s_execute() { 
  if(s_endup) {
    vector<AnAction*>::const_iterator w = s_endup->begin(),e = s_endup->end();
    while(w!=e) {
      (*w)->action();
      ++w;
    };
  };
};

AddingCrash::AddingCrash(AnAction *x) {
  if(!s_crash) s_crash = new vector<AnAction*>;
  s_crash->push_back(x);
};

void AddingCrash::s_execute() { 
  if(s_crash) {
    vector<AnAction*>::const_iterator w = s_crash->begin(),e = s_crash->end();
    while(w!=e) {
      (*w)->action();
      ++w;
    };
  };
};

AddingVersion::AddingVersion(AnAction *x) {
  if(!s_version) s_version = new vector<AnAction*>;
  s_version->push_back(x);
};

void AddingVersion::s_execute() { 
  if(s_version) {
    vector<AnAction*>::const_iterator w = s_version->begin(),e = s_version->end();
    while(w!=e) {
      GBStream << (*w)->str();
      ++w;
    };
  };
};
