// (c) Mark Stankus 1999
// SetUp.hpp

#ifndef INCLUDED_SETUP_H
#define INCLUDED_SETUP_H

class Source;
class Sink;

class SetUp {
public:
  SetUp(){};
  ~SetUp() {};
  static void (*s_CreateSourceSink)(Source &,Sink &,const char *);
};
#endif
