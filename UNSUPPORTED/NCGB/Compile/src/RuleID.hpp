// (c) Mark Stankus 1999
// RuleID.h

#ifndef INCLUDED_RULEID_H
#define INCLUDED_RULEID_H

#include "Copy.hpp"
#include "RuleIDHelper.hpp"

#if 0
class RuleID {
  Copy<RuleIDHelper> d_data;
  bool d_valid;
public:
  RuleID() : d_data(), d_valid(false) {}; 
  RuleID(const Polynomial & p,int num) : 
    d_data(Copy<RuleIDHelper>(new RuleIDHelper(p,num,true),Adopt::s_dummy)),
    d_valid(true) {};
  RuleID(const RuleID & x) : d_data(x.d_data), d_valid(x.d_valid) {};
  void operator=(const RuleID & x) { d_data = x.d_data; d_valid = x.d_valid;};
  ~RuleID(){};
  bool operator==(const RuleID & x) const {
    return number()==x.number();
  };
  bool operator<(const RuleID & x) const {
    return number() < x.number();
  };
  const Polynomial & poly() const   { return d_data().d_p;}
  int  number() const { if(!d_valid) errorh(__LINE__); return d_data().d_num;}
  bool valid()  const { if(!d_valid) errorh(__LINE__); return d_data().d_valid;}
};
#else
class RuleID {
  Polynomial d_p;
  int d_num;
  bool d_valid;
public:
  RuleID() : d_p(), d_num(-999), d_valid(false) {}; 
  RuleID(const Polynomial & p,int num) : 
    d_p(p), d_num(num), d_valid(true) {};
  RuleID(const RuleID & x) : d_p(x.d_p), d_num(x.d_num), d_valid(x.d_valid) {};
  void operator=(const RuleID & x) { 
     d_p = x.d_p; d_num=x.d_num; d_valid = x.d_valid;
  };
  ~RuleID(){};
  static void errorh(int);
  static void errorc(int);
  bool operator==(const RuleID & x) const {
    return number()==x.number();
  };
  bool operator<(const RuleID & x) const {
    return number() < x.number();
  };
  const Polynomial & poly() const   { return d_p;}
  int  number() const { if(!d_valid) errorh(__LINE__); return d_num;}
  bool valid()  const { return d_valid;}
};
#endif
MyOstream & operator <<(MyOstream & os,const RuleID & x);
#endif
