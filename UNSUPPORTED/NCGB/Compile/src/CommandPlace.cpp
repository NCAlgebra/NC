// (c) Mark Stankus 1999
// CommandPlace.c

#include "CommandPlace.hpp"
#include "charsless.hpp"
#include "Debug1.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#include <list>
#include <map>
#else
#include <set.h>
#include <list.h>
#include <map.h>
#endif
#include "vcpp.hpp"
#include "simpleString.hpp"

void getAllCommands(list<simpleString> &);


extern map<const char *,CommandPlace *,charsless> * s_command_map_p;

void CommandPlace::s_setCommandPlace(const char * x) {
  if(!s_command_map_p) {
    s_command_map_p = new  map<const char *,CommandPlace *,charsless>;
  };
  map<const char *,CommandPlace *,charsless>::iterator w = 
         s_command_map_p->find(x);
  if(w==s_command_map_p->end()) {
    GBStream << "NCGB cannot recognize the command \"" 
             <<  x << "\".\n";
    list<simpleString> L;
    getAllCommands(L);
    typedef set<simpleString,less<simpleString> > SET;
    SET S;
    typedef list<simpleString>::const_iterator LI;
    LI w = L.begin(), e = L.end();
    while(w!=e) {
      S.insert(*w);
      ++w;
    };
    SET::const_iterator w2 = S.begin(), e2 = S.end();
    GBStream << '\n';
    int count = 0;
    while(w2!=e2) {
      GBStream << (*w2).chars() << ' ';
      count += (*w2).length() ;
      ++count;
      if(count>50) {
        count = 0;
        GBStream << '\n';
      };
      ++w2;
    };
    DBG();
  };
#if 0
  GBStream << "Setting command place for " << x << ' '  
           << (*w).second->d_s << '\n';
#endif
  s_CommandPlace = (*w).second;
};

CommandPlace * CommandPlace::s_CommandPlace = 0;
