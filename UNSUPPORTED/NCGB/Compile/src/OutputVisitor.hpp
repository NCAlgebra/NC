// OutputVisitor.h

#ifndef INCLUDED_OUTPUTVISITOR_H
#define INCLUDED_OUTPUTVISITOR_H

#include "FieldChoice.hpp"
#ifdef USE_VIRT_FIELD
#include "tRational.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"
#include "MyInteger.hpp"
#include "IntegerChoice.hpp"
#include "Zp.hpp"

class MyOstream;

class OutputVisitor {
protected:
  MyOstream & d_os;
public:
  OutputVisitor(MyOstream & os) : d_os(os) {};
  virtual ~OutputVisitor();
  virtual void go(const Zp &) = 0;
  virtual void go(const tRational<INTEGER> &) = 0;
  virtual void go(const tRational<LINTEGER> &) = 0;
  static void s_put(const Zp &,Sink &);
  static void s_put(const tRational<INTEGER> &,Sink &);
  static void s_put(const tRational<LINTEGER> &,Sink &);
#ifdef USE_MyInteger
  virtual void go(const tRational<MyInteger> &) = 0;
  static void s_put(const tRational<MyInteger> &,Sink &);
#endif
};
#endif
#endif
