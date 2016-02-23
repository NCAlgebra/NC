// ncgbofstream.cpp

#include "ncgbofstream.hpp"

ncgbofstream::ncgbofstream(const char * s) : ofstream(s) {
  simpleString S(s);
  s_L.push_back(S);
};

ncgbofstream::~ncgbofstream() {};

list<simpleString> ncgbofstream::s_L;
