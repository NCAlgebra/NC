// Mark Stankus 1999 (c)
// MmaDispatches.cpp


#include "tRational.hpp"
#include "Zp.hpp"
#include "MmaSink.hpp"
#include "FieldChoice.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"
#ifdef USE_MyInteger
#include "MyInteger.hpp"
#endif

template<class T>
void MmaSinktRational(MmaSink & sink,const tRational<T> & num) {
  int top = num.numerator().internal();
  if(top==0) {
    sink.put(0);
  } else {
    Alias<ISink> is(sink.outputFunction("Rational",2L));
    MmaSink & sink2 = (MmaSink &) is.access();
    sink2.put(num.numerator().internal());
    sink2.put(num.denominator().internal());
  };
};

#ifdef USE_MyInteger
void MmaSinktRationalMy(MmaSink & sink,const tRational<MyInteger> & num) {
  int top = num.numerator().internal().as_long();
  if(top==0) {
    sink.put(0);
  } else {
    Alias<ISink> is(sink.outputFunction("Rational",2L));
    MmaSink & sink2 = (MmaSink &) is.access();
    sink2.put(num.numerator().internal().as_long());
    sink2.put(num.denominator().internal().as_long());
  };
};
#endif

void MmaSinktRationalINTEGER(MmaSink & sink,const Holder & numberrep) {
  tRational<INTEGER> * number_p;
  castHolder(numberrep,number_p);
  MmaSinktRational(sink,*number_p);
};

void MmaSinktRationalLINTEGER(MmaSink & sink,const Holder & numberrep) {
  tRational<LINTEGER> * number_p;
  castHolder(numberrep,number_p);
  MmaSinktRational(sink,*number_p);
};

#ifdef USE_MyInteger
void MmaSinktRationalMyInteger(MmaSink & sink,const Holder & numberrep) {
  tRational<MyInteger> * number_p;
  castHolder(numberrep,number_p);
  MmaSinktRationalMy(sink,*number_p);
};
#endif

void MmaSinkZp(MmaSink & sink,Holder & numberrep) {
  Zp * number_p;
  castHolder(numberrep,number_p);
  
  Alias<ISink> is(sink.outputFunction("Zp",2L));
  MmaSink & sink2 = (MmaSink &) is.access();
  sink2.put(number_p->value());
  sink2.put(Zp::s_Characteristic());
};
#include "StartEnd.hpp"

struct MmaDispatchSetUp : public AnAction {
  MmaDispatchSetUp() : AnAction("MmaDispatchSetUp") {};
  void action() {
    MmaSink::s_table.add(MmaSink::s_ID,MmaSinktRationalINTEGER);
    MmaSink::s_table.add(MmaSink::s_ID,MmaSinktRationalLINTEGER);
#ifdef USE_MyInteger
    MmaSink::s_table.add(MmaSink::s_ID,MmaSinktRationalMyInteger);
#endif
    MmaSink::s_table.add(MmaSink::s_ID,MmaSinkZp);
  };
};

AddingStart temp1MmaDispatch(new MmaDispatchSetUp);
