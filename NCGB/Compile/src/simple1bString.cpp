//  simpleString.c

#ifndef INCLUDED_SIMPLESTRING_H
#include "simpleString.hpp"
#endif
#include "RecordHere.hpp"
#include "Choice.hpp"
#ifndef INCLUDED_STRING_H
#define INCLUDED_STRING_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif
#endif
#include "MyOstream.hpp"

bool s_record_string = true;
bool s_save_variables = false;

// NEED TO PUT IN d_cap for EFFICIENCY

void simpleString::reserve(int){};

simpleString::simpleString() : d_len(0) {
  RECORDHERE(d_s = new char[1];)
  strcpy(d_s,"");
};

simpleString::simpleString(const simpleString & x) {
  d_len = x.d_len;
  RECORDHERE(d_s = new char[d_len + 1];)
  strcpy(d_s,x.d_s);
}

simpleString::simpleString(const char * s) :d_len(strlen(s)) {
  RECORDHERE(d_s = new char[d_len+1]; )
  strcpy(d_s,s);
};

void simpleString::operator =(const char * s) {
  int len = strlen(s);
  if(d_len<len) {
    RECORDHERE(delete [] d_s;)
    RECORDHERE(d_s = new char[len + 1];)
  };
  d_len = strlen(s);
  strcpy(d_s,s);
};

void simpleString::operator =(const simpleString & x) {
  if(this!=&x) {
    if(d_len<x.d_len) {
      RECORDHERE(delete [] d_s;)
      RECORDHERE(d_s = new char[x.d_len + 1];)
    };
    d_len = x.d_len;
    strcpy(d_s,x.d_s);
  };
};

simpleString::~simpleString() {
  RECORDHERE(delete [] d_s;)
};

bool simpleString::operator==(const simpleString & x) const {
  return !strcmp(d_s,x.d_s);
};

bool simpleString::operator==(const char * x) const {
  return !strcmp(d_s,x);
};

bool simpleString::operator<(const simpleString & x) const {
  return strcmp(d_s,x.d_s)<0;
};

MyOstream & operator <<(MyOstream & os,const simpleString & s) {
  return (os << s.chars()); 
};
