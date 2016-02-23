// SetUpErrorInformation.c

#include "SetUpErrorInformation.hpp"

#include "ErrorInformation.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif

using namespace std;

void s_TRIED_TO_DEREFERENCE(void *,MyOstream & os) {
  os << "Tried to dereference a vector iterator at or past end\n";
};

void s_GBVECTOR_BADCONSTRUCTOR(void * v,MyOstream & os) {
  const pair<int,int> & x = * (const pair<int,int> *) v;
  os << "Tried to initialize a vector iterator with value "
     << x.first 
     << " on a container with size "
     << x.second
     << '\n';
};

void s_GBVECTOR_ERROR1F(void * v,MyOstream & os) {
  const pair<int,int> & x = * (const pair<int,int> *) v;
  os << "Tried to ++ a vector iterator with value "
     << x.first
     << " on a container with size "
     << x.second
     << '\n';
};

void s_GBVECTOR_ERROR2F(void * v,MyOstream & os) {
  const pair<int,int> & x = * (const pair<int,int> *) v;
  os << "Tried to -- a vector iterator with value "
     << x.first
     << " on a container with size "
     << x.second
     << '\n';
};

void s_dummy(void *,MyOstream &) {
  DBG();
};

ErrorInformation s_allErrors_p[] = {
   {"Vector::operator*",s_TRIED_TO_DEREFERENCE,&GBStream},
   {"s_GBVECTOR_BADCONSTRUCTOR",s_GBVECTOR_BADCONSTRUCTOR,&GBStream},
   {"s_GBVECTOR_ERROR1F",s_GBVECTOR_ERROR1F,&GBStream},
   {"s_GBVECTOR_ERROR2F",s_GBVECTOR_ERROR2F,&GBStream},
   {(char *) 0,s_dummy,&GBStream}
};

int s_VECTOR_TRIED_PAST_END = 0;
int s_GBVECTOR_CONSTRUCTOR = 1;
int s_GBVECTOR_ERROR1 = 2;
int s_GBVECTOR_ERROR2 = 2;

int s_grabMessageNumber(const char * const X) {
  int result = -1;
  int i = 0;
  ErrorInformation * p = s_allErrors_p;
  while(p->d_hint) {
    if(strcmp(p->d_hint,X)==0) {
      result = i;
      break;
    };
    ++p; ++i;
  };
  return result;
};
