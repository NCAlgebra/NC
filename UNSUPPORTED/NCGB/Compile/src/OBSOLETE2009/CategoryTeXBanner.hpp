// Mark Stankus 1999 (c)
// CategoryBannerTeX.hpp

#ifndef INCLUDED_CATEGORYTEXBANNER_H
#define INCLUDED_CATEGORYTEXBANNER_H

class BroadCastData;
#include "Banner.hpp"

class CategoryTeXBanner : public Banner {
public:
  CategoryTeXBanner(int columns = 1,const char * FontSize = "normalsize") 
    : Banner(columns,FontSize) {};
  virtual ~CategoryTeXBanner();
  virtual void action(const BroadCastData & x) const;
  virtual Recipient * clone() const;
};
#endif
