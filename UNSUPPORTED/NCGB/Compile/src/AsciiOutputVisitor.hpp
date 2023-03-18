// AsciiOutputVisitor.h

#ifndef INCLUDED_ASCIIOUTPUTVISITOR_H
#define INCLUDED_ASCIIOUTPUTVISITOR_H

#include "FieldChoice.hpp"
#ifdef USE_VIRT_FIELD
#include "tRational.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"
#include "MyInteger.hpp"
#include "OutputVisitor.hpp"

class AsciiOutputVisitor : public OutputVisitor {
public:
  AsciiOutputVisitor(MyOstream & os);
  virtual ~AsciiOutputVisitor();
  virtual void go(const Zp &);
  virtual void go(const tRational<INTEGER> &);
  virtual void go(const tRational<LINTEGER> &);
#ifdef USE_MyInteger
  virtual void go(const tRational<MyInteger> &);
#endif
  bool d_showOne;
};
#endif
#endif
