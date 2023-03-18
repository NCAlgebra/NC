#include "ItoString.hpp"
#include "RecordHere.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif
#include "Debug1.hpp"

char * StringThenInt(const char * s,int i) {
  char * result = new char[strlen(s)+10];
  char * num = new char[9];
  AppendItoStringHelper(i,num);
  strcpy(result,s);
  strcat(result,num);
  delete [] num;
  return result;
};

char * UniformStringThenInt(const char * s,int i,int numdigits) {
  char * result = new char[strlen(s)+10];
  char * num = new char[9];
  AppendItoStringHelper(i,num);
  strcpy(result,s);
  int diff = numdigits-strlen(num);
  if(diff<0) {
    GBStream << "s is " << s << '\n';
    GBStream << "i is " << i << '\n';
    GBStream << "numdigits is " << numdigits << '\n';
    GBStream << "diff is " << diff << '\n';
    GBStream << "num is " << num << '\n';
    GBStream << "strlen(num) is " << (long) strlen(num) << '\n';
    DBG();
  };
  while(diff) {
    strcat(result,"0");
    --diff;
  };
  strcat(result,num);
  delete [] num;
  return result;
};

// My own append i to the end of a string function.
// The library class way (sprintf) is way to slow.

void AppendItoStringHelper(int i,char * p) {
  int k = i;
  char * s = p;
  if(k<0) {
    *s = '-';
    ++s;
    k = -k;
  }
  /* find the base */

  int rem = k;
  int maxBase = 1;
  for(int j=1;j<=10 && rem >= 10;++j) {
    maxBase *= 10;
    rem /= 10;
  }
  if(rem>10) {
    {int m = 0;m=1/m;}; // Run time error
  };
  rem = k;
  int ww;
  char ch;
  for(;maxBase!=1;) {
    ww = rem/maxBase;
    rem = rem - maxBase*ww;
    ch = ww;
    ch += '0';
    *s = ch;
    ++s;
    maxBase /= 10;
  }
  ch = rem;
  ch += '0';
  *s  = ch;
  ++s;
  *s = '\0';
};

// ------------------------------------------------------------------

void ItoString(int i,char * & s) {
  RECORDHERE(delete [] s;)
  char p[10];
  AppendItoStringHelper(i,p);
  RECORDHERE(s = new char[strlen(p)+1];)
  strcpy(s,p);
};
