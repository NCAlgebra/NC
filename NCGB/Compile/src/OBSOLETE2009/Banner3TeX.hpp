// Mark Stankus 1999 (c)
// Banner3TeX.hpp

#ifndef INCLUDED_BANNER3TEX_H
#define INCLUDED_BANNER3TEX_H

#include "Banner.hpp"

class Banner3TeX : public Banner {
public:
  Banner3TeX(MyOstream & os,int columns = 1,const char * FontSize = "normalsize") 
    : Banner(os,columns,FontSize) {};
  virtual ~Banner3TeX();
  virtual void action(const BroadCastData &) const;
  virtual Recipient * clone() const;
};
#endif
