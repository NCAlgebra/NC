// mylog.c

#include "mylog.hpp"

int mylog(int x) {
  int Log  = 1;
  while(x>=10) {
    x/= 10;
     ++Log;
  };
  return Log;
};

int mylog(long x) {
  int Log  = 1;
  while(x>=10L) {
    x/= 10L;
    ++Log;
  };
  return Log;
};
