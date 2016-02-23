// StringAccumulator.c

#include "StringAccumulator.hpp"
#include "RecordHere.hpp"
#include "GBStream.hpp"
#ifndef INCLUDED_CSTRING_H
#define INCLUDED_CSTRING_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif
#endif

void StringAccumulator::add(const char * const p) {
  int sz = strlen(p);
  RECORDHERE(char * q = new char[sz+1];)
  strcpy(q,p);
  d_v.push_back(q);
  d_sz += sz;
};

void StringAccumulator::add(const char x) {
  RECORDHERE(char * q = new char[2];)
  q[0] = x;
  q[1] = '\0';
  d_v.push_back(q);
  ++d_sz;
};

void StringAccumulator::add(unsigned int) {
  errorc(__LINE__);
};

void StringAccumulator::add(int) {
  errorc(__LINE__);
};

void StringAccumulator::add(long int) {
  errorc(__LINE__);
};

#ifdef USE_UNIX
void StringAccumulator::add(long long int) {
  errorc(__LINE__);
};
#endif

void StringAccumulator::add(float) {
  errorc(__LINE__);
};

void StringAccumulator::add(double) {
  errorc(__LINE__);
};

StringAccumulator::~StringAccumulator() {
  clear();
};

void StringAccumulator::clear() {
  const int sz = d_v.size();
  vector<char *>::iterator w = d_v.begin();
  for(int i=1;i<=sz;++i,++w) {
    RECORDHERE(delete [](*w);)
  };
  d_v.erase(d_v.begin(),d_v.end());
  RECORDHERE(delete [] d_result;)
  d_result = 0;
  d_sz = 0;
};

const char * const StringAccumulator::chars() const {
  RECORDHERE(delete [] d_result; )
  d_result = 0;
  const int sz = d_v.size();
  vector<int> sizes;
  sizes.reserve(sz);
  vector<char *>::const_iterator w = d_v.begin();
  RECORDHERE(d_result = new char[d_sz+1];)
  *d_result = '\0';
  w = d_v.begin();
  for(int j=1;j<=sz;++j,++w) {
    strcat(d_result,*w);
  };
  return d_result;
};

#ifdef INCLUDED_DEBUG1_H
void StringAccumulator::errorh(int n) { 
  DBGH(n); 
};
#else
void StringAccumulator::errorh(int) { 
  exit(-999);
};
#endif

#ifdef INCLUDED_DEBUG1_H
void StringAccumulator::errorc(int n) { 
  DBGC(n); 
#else
void StringAccumulator::errorc(int) { 
  exit(-999);
#endif
};
