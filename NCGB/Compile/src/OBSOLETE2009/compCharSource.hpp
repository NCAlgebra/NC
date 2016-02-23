// (c) Mark Stankus 1999
// compCharSource.h

#ifndef INCLUDED_COMPCHARSOURCE_H
#define INCLUDED_COMPCHARSOURCE_H

#include "CharacterSource.hpp"

class  compCharSource : public CharacterSource {
  compCharSource(const compCharSource &);
    // not implemented
  void operator=(const compCharSource &);
    // not implemented
  char d_c; bool d_valid;
public:
  vector<compCharSource *> d_vec;
  compCharSource() : d_c(' '), d_valid(false) {};
  virtual ~compCharSource();
  virtual bool eof() const;
  virtual void vGet(char & c);
};
#endif
