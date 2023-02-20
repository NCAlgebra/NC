// Mark Stankus 1999 (c)
// MmaVirtualField.c


#include "SimpleTable.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "MmaSource.hpp"
#include "MmaSink.hpp"
#include "Field.hpp"
#include "FieldChoice.hpp"
#include "Holder.hpp"
#include "tRational.hpp"
#include "Zp.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"
#ifdef USE_MyInteger
#include "MyInteger.hpp"
#endif
#include "mathlink.h"

template<class T>
void MmaSourceRational(MmaSource & source,tRational<T> & x) {
  int type = source.getType();
  if(type==MLTKINT) {
    int i;
    source.get(i);
    T t(i);
    x = t;
  } else if(type==MLTKFUNC) {
    Alias<ISource> is(source.inputNamedFunction("Rational"));
    MmaSource & so2 = (MmaSource &) is.access();
    int i;
    so2.get(i);
    T t(i);
    x = t;
    so2.get(i);
    t = i;
    x /= t;
  } else DBG();
};

template<class T>
void MmaSinktRational(MmaSink & sink,const tRational<T> & num) {
  MLink * mlp = sink.mlink();
  MLPutFunction(mlp,"Rational",2L);
  MLPutInteger(mlp,num.numerator().internal());
  MLPutInteger(mlp,num.denominator().internal());
};

#ifdef USE_MyInteger
void MmaSinktRationalMy(MmaSink & sink,const tRational<MyInteger> & num) {
  MLink * mlp = sink.mlink();
  MLPutFunction(mlp,"Rational",2L);
  MLPutInteger(mlp,num.numerator().internal().as_long());
  MLPutInteger(mlp,num.denominator().internal().as_long());
};
#endif

void MmaSourcetRationalINTEGER(MmaSource & source,Holder & numberrep) {
  tRational<INTEGER> * number_p;
  castHolder(numberrep,number_p);
  MmaSourceRational(source,*number_p);
};

void MmaSinktRationalINTEGER(MmaSink & sink,const Holder & numberrep) {
  tRational<INTEGER> * number_p;
  castHolder(numberrep,number_p);
  MmaSinktRational(sink,*number_p);
};

void MmaSourcetRationalLINTEGER(MmaSource & source,Holder & numberrep) {
  tRational<LINTEGER> * number_p;
  castHolder(numberrep,number_p);
  MmaSourceRational(source,*number_p);
};

void MmaSinktRationalLINTEGER(MmaSink & sink,const Holder & numberrep) {
  tRational<LINTEGER> * number_p;
  castHolder(numberrep,number_p);
  MmaSinktRational(sink,*number_p);
};

#ifdef USE_MyInteger
void MmaSourcetRationalMyINTEGER(MmaSource & source,Holder & numberrep) {
  tRational<MyInteger> * number_p;
  castHolder(numberrep,number_p);
  MmaSourceRational(source,*number_p);
};

void MmaSinktRationalMyINTEGER(MmaSink & sink,Holder & numberrep) {
  tRational<MyInteger> * number_p;
  castHolder(numberrep,number_p);
  MmaSinktRationalMy(sink,*number_p);
};
#endif

void MmaSourceZp(MmaSource& source,Holder & h) {
  Alias<ISource> is(source.inputNamedFunction("Zp"));
  MmaSource & sink2 = (MmaSource &) is.access(); 
  Zp * number_p;
  castHolder(h,number_p);
  int n;
  sink2.get(n);
  *number_p = n;
  sink2.get(n);
  if(n!=Zp::s_Characteristic()) {
    GBStream << "Invalid characteristic mixing\n";
    GBStream << n << " versus " << Zp::s_Characteristic() << '\n';
    DBG();
  };
};

void MmaSinkZp(MmaSink & sink,const Holder & numberrep) {
  MLink * mlp = sink.mlink();
  MLPutFunction(mlp,"Zp",2L);
  Zp * number_p;
  castHolder(numberrep,number_p);
  MLPutInteger(mlp,number_p->value());
  MLPutInteger(mlp,Zp::s_Characteristic());
};

#include "StartEnd.hpp"

struct MmaFieldSetUp : public AnAction {
  MmaFieldSetUp() : AnAction("MmaFieldSetUp") {};
  void action() {
    MmaSource::s_table.add(tRational<INTEGER>::s_ID,
                           MmaSourcetRationalINTEGER);
    MmaSink::s_table.addconst(tRational<INTEGER>::s_ID,
                         MmaSinktRationalINTEGER);

    MmaSource::s_table.add(tRational<LINTEGER>::s_ID,
                           MmaSourcetRationalLINTEGER);
    MmaSink::s_table.addconst(tRational<LINTEGER>::s_ID,
                         MmaSinktRationalLINTEGER);

    MmaSource::s_table.add(Zp::s_ID,MmaSourceZp);
    MmaSink::s_table.addconst(Zp::s_ID,MmaSinkZp);
  };
};

AddingStart temp1MmaFieldSetUp(new MmaFieldSetUp);
