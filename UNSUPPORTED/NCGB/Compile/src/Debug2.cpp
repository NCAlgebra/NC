// Debug2.c

#include "Debug2.hpp"

vector<int> Debug2::s_DebugDisownGBVector;
vector<int>   Debug2::s_traceNumbers;
vector<MyOstream *>   Debug2::s_MyOstreams;

MyOstream & Debug2::s_Log(int n) {
  return * s_MyOstreams[n];
};

int Debug2::s_setLogStream(MyOstream & os) {
   const int n = s_MyOstreams.size();
   s_MyOstreams.push_back(&os);
   return n;
};
