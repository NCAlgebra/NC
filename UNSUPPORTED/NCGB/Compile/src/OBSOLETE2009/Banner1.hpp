// Mark Stankus 1999 (c)
// Banner1.hpp

#ifndef INCLUDED_BANNER1_H
#define INCLUDED_BANNER1_H

#include "Banner.hpp"

class Banner1 : public Banner {
  static const int s_ID;
public:
  Banner1(MyOstream & os,int columns = 1,const char * FontSize = "normalsize") 
    : Banner(os,columns,FontSize) {};
  virtual ~Banner1();
  virtual void action(const BroadCastData &) const;
  virtual Recipient * clone() const;
};
#endif
