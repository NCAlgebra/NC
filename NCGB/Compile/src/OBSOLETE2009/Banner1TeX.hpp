// Mark Stankus 1999 (c)
// Banner1TeX.hpp

#ifndef INCLUDED_BANNER1TEX_H
#define INCLUDED_BANNER1TEX_H

#include "Banner.hpp"

class Banner1TeX : public Banner {
public:
  Banner1TeX(MyOstream & os,int columns = 1,
     const char * FontSize = "normalsize") : Banner(os,columns,FontSize) {};
  virtual ~Banner1TeX();
  virtual void action(const BroadCastData &) const;
  virtual Recipient * clone() const;
};
#endif
