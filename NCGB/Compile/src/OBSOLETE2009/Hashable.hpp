// Hashable.h

#ifndef INCLUDED_HASHABLE_H
#define INCLUDED_HASHABLE_H

class Hashable {
public:
  Hashable(){};
  virtual ~Hashable() = 0;
  virtual bool Hash(const char * s,int & hash) = 0;
  virtual char * HashString(int hash,int & len) = 0;
};
#endif
