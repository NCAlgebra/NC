// idValue.c

#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "RecordHere.hpp"
#include "idValue.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifndef INCLUDED_VECTOR_H
#define INCLUDED_VECTOR_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#endif
#include <limits.h>
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif
#ifndef INCLUDED_SIMPLESTRING_H
#include "simpleString.hpp"
#endif
#include <algorithm>
#include "vcpp.hpp"
#include "StartEnd.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"

#if 0
extern int hash(const unsigned char *);

int myhash(const char * s) { return hash((const unsigned char *)s);};
#endif

int * s_idValue = 0;

vector<simpleString> * s_AllStrings_p = 0;

int readInFile(vector<simpleString> & vec,const char * s) {
  ifstream ifs(s);
  simpleString S;
  char word[100];
  while(true) {
    ifs.get(word,100);
    ifs.ignore(INT_MAX,'\n');
    if(*word=='\0') break;
    S = word;
    vec.push_back(S);
  };
  return vec.size();
};

int idValue(const char * s){
  if(!s_AllStrings_p) s_AllStrings_p = new vector<simpleString>;
  if(!s_idValue) {
    RECORDHERE(s_idValue = new int(0);)
//    *s_idValue = readInFile(*s_AllStrings_p,"ncgb_strings.txt");
    s_AllStrings_p->reserve(500);
  };
#if 0
  int n = myhash(s);
GBStream << "hash is " << n << '\n';
#else
  int n = -1;
#endif
  if(n<0 || n>=(int)s_AllStrings_p->size()) {
    n = -1;
  } else if(!((*s_AllStrings_p)[n]==s)) {
    typedef vector<simpleString>::const_iterator VI;
    VI w=s_AllStrings_p->begin(),e=s_AllStrings_p->end();
    n = -1;
    int kk = 0; 
    while(w!=e) {
      if(*w==s) {
        n = kk; break;
      };
      ++w;++kk;
    };
  };
  if(n==-1) {
#if 0
GBStream << "Could not find" << s << " in \n";
vector<simpleString>::const_iterator w=s_AllStrings_p->begin(),e=s_AllStrings_p->end();
while(w!=e) {
  GBStream << myhash((*w).chars()) << " for " << *w << "!!" << '\n';
  ++w;
};
#endif
    ++(*s_idValue);
    n = *s_idValue;
    simpleString S(s);
    s_AllStrings_p->push_back(S);
  };
  return n;
};    

#if 0
int idValue(simpleString * & s){
  if(!s_AllStrings_p) s_AllStrings_p = new vector<simpleString>;
  if(s_idValue) {
     ++(*s_idValue);
  } else {
    RECORDHERE(s_idValue = new int(0);)
    s_AllStrings_p->reserve(500);
  };
  s_AllStrings_p->reserve(*s_idValue);
  s_AllStrings_p->push_back(*s);
  RECORDHERE(delete s;)
  return * s_idValue;
};
#endif

const char * idString(int i) {
  if(!s_AllStrings_p) s_AllStrings_p = new vector<simpleString>;
  if(i>=(int) s_AllStrings_p->size()) {
     DBG();
  };
  return (*s_AllStrings_p)[i].chars();
};

int numberOfIdStrings() {
  if(!s_AllStrings_p) s_AllStrings_p = new vector<simpleString>;
  return  (int) s_AllStrings_p->size();
};

void idValuePrepareFor(int n) {
  if(!s_AllStrings_p) s_AllStrings_p = new vector<simpleString>;
  s_AllStrings_p->reserve(s_AllStrings_p->size()+n);
};

#include "Command.hpp"
#include "Source.hpp"
#include "Sink.hpp"

void _PrintIds(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  int n = (int) s_AllStrings_p->size();
  for(int i=0;i<n;++i) {
    GBStream << "String:" << (*s_AllStrings_p)[i] << " #:" << i << '\n';
  };
};

AddingCommand temp1ids("PrintIds",0,_PrintIds);
