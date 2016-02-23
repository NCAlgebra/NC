// (c) Mark Stankus 1999
// CharBracketSource.hpp

#ifndef INCLUDED_CHARBRACKETSOURCE_H
#define INCLUDED_CHARBRACKETSOURCE_H

#include "CharacterSource.hpp"

class  CharBracketSource : public CharacterSource {
  CharBracketSource(const CharBracketSource &);
    // not implemented
  void operator=(const CharBracketSource &);
    // not implemented
  bool d_own;
  const char * d_s;
  const char * d_current;
  int d_nest;
  void setUp(CharacterSource & so);  
  char d_front,d_back;
public:
  CharBracketSource(const char * s,char front,char back) : d_own(false), 
       d_s(s), d_current(s),d_nest(0), d_front(front), d_back(back) {};
  CharBracketSource(CharacterSource & so,char front,char back) : d_own(true), 
       d_s(0), d_current(0), d_front(front), d_back(back) {
    setUp(so);
  };
  virtual ~CharBracketSource();
  virtual bool eof() const;
  virtual void vGet(char & c);
  const char * const allChars() const {
    return d_s;
  };
  const char * const currentChars() const {
    return d_current;
  };
};
#endif
