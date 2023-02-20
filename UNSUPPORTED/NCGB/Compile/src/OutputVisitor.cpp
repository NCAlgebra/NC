// OutputVisitor.c

#include "OutputVisitor.hpp"

#ifdef USE_VIRT_FIELD
#include "Sink.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"
#include "MyInteger.hpp"
#include "tRational.hpp"

OutputVisitor::~OutputVisitor(){};

void OutputVisitor::s_put(const Zp  & x,Sink & si) {
  x.put(si);
};

void OutputVisitor::s_put(const tRational<INTEGER> & x,Sink & si) {
   if(x.denominator().zero()) {
    si << x.numerator().internal();
  } else {
    Sink sink(si.outputFunction("Divide",2L));
    sink << x.numerator().internal() << x.denominator().internal();
  };    
};

void OutputVisitor::s_put(const tRational<LINTEGER> & x,Sink & si) {
   if(x.denominator().zero()) {
    si << x.numerator().internal();
  } else {
    Sink sink(si.outputFunction("Divide",2L));
    sink << x.numerator().internal() << x.denominator().internal();
  };    
};

#ifdef USE_MyInteger
void OutputVisitor::s_put(const tRational<MyInteger> &,Sink &) {
  DBG();
};
#endif

#endif
