// Mark Stankus 1999 (c)
// CreateTags.cpp


#include "Command.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "stringGB.hpp"

void _CreateIntTag(Source & so,Sink & si) {
  stringGB name;
  int n;
  so >> name >> n;
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp1CreateTags("CreateIntTag",2,_CreateIntTag);
