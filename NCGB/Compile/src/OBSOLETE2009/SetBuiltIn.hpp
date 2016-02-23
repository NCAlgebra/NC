// (c) Mark Stankus 1999
// SetBuiltIn.h

#ifndef INCLUDED_SETBUILTIN_H
#define INCLUDED_SETBUILTIN_H

struct SetBuiltIn {
  SetBuiltIn(const char * s,int * p);
  SetBuiltIn(const char * s,bool * p);
  SetBuiltIn(const char * s,int (*get)(),void (*set)(int));
  SetBuiltIn(const char * s,bool (*get)(),void (*set)(bool));
};
#endif
