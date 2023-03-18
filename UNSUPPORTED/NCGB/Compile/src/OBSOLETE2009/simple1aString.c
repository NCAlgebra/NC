// simpleString.c

#include "simpleString.hpp"
#include "StringImpl.hpp"
#include "RecordHere.hpp"

bool s_record_string = true;
bool s_save_variables = false;

void simpleString::reserve(int n) {
  if(d_impl_p->d_place==-999 && n>d_cap && n >d_len) {
    char * s = new char[n+1];
    strcpy(s,d_s);
    delete [] d_s;
    d_s = s;
    d_cap = n;
  };
};

simpleString::simpleString() : d_s(0), d_len(0), d_cap(0), d_impl_p(0) {
  RECORDHERE(d_impl_p=new StringImpl;)
  RECORDHERE(d_s = new char[1]);
  *d_s = '\0';
};

simpleString::simpleString(const simpleString & x) : d_s(x.d_s), 
     d_len(x.d_len), d_cap(-999), d_impl_p(0) {
  RECORDHERE(d_impl_p=new StringImpl(*x.d_impl_p);)
  if(d_impl_p->d_place==-999) {
    d_cap = x.d_len;
    RECORDHERE(d_s = new char[x.d_len+1];)
    strcpy(d_s,x.d_s);
  };
};

simpleString::simpleString(const char * s) : d_impl_p(0) {
  RECORDHERE(d_impl_p=new StringImpl;)
  (*d_impl_p) = s;
  if(d_impl_p->d_place==-999) {
    d_len = strlen(s);
    RECORDHERE(d_s = new char[d_len+1];)
    d_cap = d_len;
    strcpy(d_s,s);
  } else {
    d_s = d_impl_p->value(d_len);
    d_cap = -999;
  };
};

void simpleString::operator =(const simpleString & x) {
  if(d_impl_p->d_place==-999) {
    if(x.d_impl_p->d_place==-999) {
      // *this and x are both genuine strings
      if(d_cap<x.d_cap) { 
        delete [] d_s;
        RECORDHERE(d_s = new char[x.d_len+1];)
        d_cap = x.d_len;
      };
      strcpy(d_s,x.d_s);
    } else {
      // *this is a genuine string, x is a hashed value
      delete [] d_s;
      d_cap = -999;
      d_s = x.d_s;
    }
  } else {
    if(x.d_impl_p->d_place==-999) {
      // *this is a hash value and x is genuine strings
      RECORDHERE(d_s = new char[x.d_len+1];)
      d_cap = x.d_len;
      strcpy(d_s,x.d_s);
    } else {
      // *this and x are both hashed values
      d_cap = -999;
      d_s = x.d_s;
    };
  };
  d_len = x.d_len;
  (*d_impl_p) = *x.d_impl_p;
};

void simpleString::operator =(const char * s) {
  if(d_impl_p->d_place==-999) {
    delete [] d_s;
    d_cap = -999;
  };
  (*d_impl_p) = s;
  if(d_impl_p->d_place==-999) {
    d_len = strlen(s);
    RECORDHERE(d_s = new char[d_len+1];)
    d_cap = d_len;
    strcpy(d_s,s);
  } else {
    d_cap = -999;
    d_s = d_impl_p->value(d_len);
  };
};

simpleString::~simpleString() {
  if(d_impl_p->d_place==-999) {
    delete [] d_s;
  }
  delete d_impl_p;
};

bool simpleString::operator==(const char * s) const {
  return strcmp(s,d_s)==0;
};

bool simpleString::operator==(const simpleString & x) const {
  bool result = (*d_impl_p)==(*x.d_impl_p);
  if(result && (d_impl_p->d_place==-999)) {
    result = d_len==x.d_len && strcmp(d_s,x.d_s)==0; 
  };
  return result;
};

bool simpleString::operator<(const simpleString & x) const {
  return strcmp(d_s,x.d_s) < 0;
};

MyOstream & operator <<(MyOstream & os,const simpleString & x) {
  return os << (x.chars());
};
