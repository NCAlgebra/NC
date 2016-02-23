// TeXOutputVisitor.h

#ifndef INCLUDED_TEXOUTPUTVISITOR_H
#define INCLUDED_TEXOUTPUTVISITOR_H

#include "Field.hpp"
#ifdef USE_VIRT_FIELD
#include "tRational.hpp"
#include "OutputVisitor.hpp"

class TeXOutputVisitor : public OutputVisitor {
public:
  TeXOutputVisitor(MyOstream & os);
  virtual ~TeXOutputVisitor();
  virtual void go(const Zp &);
  virtual void go(const tRational<INTEGER> &);
  virtual void go(const tRational<LINTEGER> &);
#ifdef USE_MyInteger
  virtual void go(const tRational<MyInteger> &);
#endif
  bool d_showOne;
  bool d_showPlusWithNumbers;      
};
#endif
#endif
