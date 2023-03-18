// Mark Stankus 1999 (c)
// Banner3.hpp

#ifndef INCLUDED_BANNER3_H
#define INCLUDED_BANNER3_H

#include "Banner.hpp"

class Banner3 : public Banner {
public:
  Banner3(MyOstream & os,int columns = 1,const char * FontSize = "normalsize") 
    : Banner(os,columns,FontSize) {};
  virtual ~Banner3();
  virtual void action(const BroadCastData &) const;
  virtual Recipient * clone() const;
};
#endif
