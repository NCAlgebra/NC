// Mark Stankus 1999 (c)
// Banner2.hpp

#ifndef INCLUDED_BANNER2_H
#define INCLUDED_BANNER2_H

#include "Banner.hpp"

class Banner2 : public Banner {
public:
  Banner2(MyOstream & os,int columns = 1,const char * FontSize = "normalsize") 
    : Banner(os,columns,FontSize) {};
  virtual ~Banner2();
  virtual void action(const BroadCastData &) const;
  virtual Recipient * clone() const;
};
#endif
