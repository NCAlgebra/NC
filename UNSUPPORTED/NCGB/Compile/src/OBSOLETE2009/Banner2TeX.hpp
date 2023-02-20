// Mark Stankus 1999 (c)
// Banner2TeX.hpp

#ifndef INCLUDED_BANNER2TEX_H
#define INCLUDED_BANNER2TEX_H

#include "Banner.hpp"

class Banner2TeX : public Banner {
public:
  Banner2TeX(MyOstream & os,int columns = 1,const char * FontSize = "normalsize") 
    : Banner(os,columns,FontSize) {};
  virtual ~Banner2TeX();
  virtual void action(const BroadCastData &) const;
  virtual Recipient * clone() const;
};
#endif
