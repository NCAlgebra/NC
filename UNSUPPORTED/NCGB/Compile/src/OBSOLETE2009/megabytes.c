// megabytes.c

#include <stdlib.h>
#include "MyOstream.hpp"

int main(int argc,char ** argv)  {
  int n = atoi(argv[1]);
  float f = n;
  f /= 1024.;
  f /= 1024.;
  cout << f << '\n';
  cout.flush();
  return 0;
};
