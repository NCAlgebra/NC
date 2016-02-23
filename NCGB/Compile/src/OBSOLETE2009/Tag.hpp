// Mark Stankus 1999 (c)
// Tag.h

#ifndef INCLUDED_TAG_H
#define INCLUDED_TAG_H

#include "Debug1.hpp"
class MyOstream;

class Tag {
  const int d_ID;
  bool d_infinity;
  static void errorh(int);
  static void errorc(int);
protected:
  Tag(int id,bool infinity) : d_ID(id), d_infinity(infinity) {}; 
public:
  virtual ~Tag() = 0;
  virtual void print(MyOstream &) const = 0;
  virtual bool less(const Tag & x) const = 0;
  virtual bool equal(const Tag & x) const = 0;
  bool operator <(const Tag & x) const {
    if(d_ID!=x.d_ID) errorh(__LINE__);
    bool result = true;
    if(d_infinity) {
      result = false;
    } else if(x.d_infinity) {
      result = true;
    } else result = less(x);
    return result;
  };
  bool operator ==(const Tag & x) const {
    if(d_ID!=x.d_ID) errorh(__LINE__);
    return equal(x);
  };
  bool operator >(const Tag & x) const {
    if(d_ID!=x.d_ID) errorh(__LINE__);
    return x.less(*this);
  };
};

class IntTag : public Tag {
  static const int s_ID;
  int d_n;
public:
  IntTag() : Tag(s_ID,true), d_n(0) {};
  IntTag(int n) : Tag(s_ID,false), d_n(n) {};
  ~IntTag();
  virtual bool less(const Tag &) const;
  virtual bool equal(const Tag & x) const;
  virtual void print(MyOstream &) const;
};
#endif 
