// (c) Mark Stankus 1999
// Command.c

//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#include <list>
#else
#include <map.h>
#include <list.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#include "Command.hpp"
#include "CommandPlace.hpp"
#include "GBStream.hpp"
#include "Debug1.hpp"
#include "Debug3.hpp"
#include "charsless.hpp"
#include "MyOstream.hpp"
#include "Source.hpp"
#include "Sink.hpp"

#include "vcpp.hpp"

ofstream * s_outputfile_p = 0;


typedef map<const char *,CommandPlace *,charsless> MAP;
MAP * s_command_map_p = 0;

typedef vector<void (*)(Source &,Sink&)>  COMMAND_VEC;
COMMAND_VEC * command_vec_p = 0;

typedef vector<pair<const char *,const char *> > ALL_COMMAND_NAMES;
ALL_COMMAND_NAMES * s_all_command_names_p = 0;

inline void reportittomo(const char * x, const char * y) {
#if 0
  if(!s_outputfile_p) {
    s_outputfile_p = new ofstream("mo");
  };
  *s_outputfile_p <<  x << " in the " << y << "\n";
#endif
  pair<const char *,const char *> pr(x,y);
  if(!s_all_command_names_p) {
    s_all_command_names_p = new ALL_COMMAND_NAMES;
  };
  s_all_command_names_p->push_back(pr);
};

void printAllCommands() {
  GBStream << "The commands are:\n";
  typedef vector<pair<const char*,const char *> >::const_iterator VI;
  VI w = s_all_command_names_p->begin(), e = s_all_command_names_p->end();
  while(w!=e) {
    const pair<const char *,const char *> & pr = *w;
    GBStream << pr.first << " in the " << pr.second << '\n';
    GBStream.flush();
    ++w;
  };
};

void getAllCommands(list<simpleString> & L) {
  simpleString x;
  typedef vector<pair<const char*,const char *> >::const_iterator VI;
  VI w = s_all_command_names_p->begin(), e = s_all_command_names_p->end();
  while(w!=e) {
    x = (*w).first;
    L.push_back(x);
    ++w;
  };
};

OfstreamProxy s_TkOutput("tkOutput");

AddingCommand::AddingCommand(const char * x,int args,void (*f)(Source &,Sink &),const char * filename) {
  if(filename) {
    s_TkOutput() << "set commandToFile(x) filename;\n";
  };
  if(!s_command_map_p) {
     s_command_map_p = new MAP;
  };
  if(!command_vec_p) {
    command_vec_p = new COMMAND_VEC;
  };
  bool doit = s_command_map_p->empty();
  MAP::const_iterator w;
  if(!doit) {
    w = s_command_map_p->find(x);
    doit = w==s_command_map_p->end();
  };
  if(doit) {
    int sz = command_vec_p->size();
    CommandPlace * p = new CommandPlace(1,sz,args,x);
    pair<const char * const,CommandPlace*> pr(x,p);
    s_command_map_p->insert(pr);
    command_vec_p->push_back(f);
reportittomo(x,"command_vec");
  } else {
    GBStream << "Internal Error: Trying to add the string " << x
             << " twice.\n";
    DBG();
  };
};

void execute_command(const char * x,Source & source,Sink & sink) {
  if(!CommandPlace::s_CommandPlace ||
     strcmp(CommandPlace::s_CommandPlace->d_s,x)!=0) {
    CommandPlace::s_setCommandPlace(x);
  };
  switch(CommandPlace::s_CommandPlace->d_which_list) {
  case 1: 
    (*command_vec_p)[CommandPlace::s_CommandPlace->d_data](source,sink);
    break;
  default:
    GBStream << "The command \"" << x << "\" does not exist.\n";
    DBG();
  };
};
