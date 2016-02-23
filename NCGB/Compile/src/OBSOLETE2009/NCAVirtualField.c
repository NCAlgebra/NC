// Mark Stankus 1999 (c)
// NCAVirtualField.c


#include "SimpleTable.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "NCASource.hpp"
#include "NCASink.hpp"
#include "Field.hpp"
#include "Holder.hpp"
#include "tRational.hpp"
#include "Zp.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"

template<class T>
void NCASourceRational(NCASource & source,tRational<T> & num) {
  CharacterSource * so = source.so();
  num.setToOne();
  T t;
  t = so->getNumber();
  num = t;
  if(!so->eof()) {
    // there is more input so perhaps there is a division sign coming up
    char c;
    so->peekCharacter(c," \n");
    if(c=='/') {
      so->passCharacter();
      t = so->getNumber();
      num /= t;
    };
  };
  if(NCASource::s_pass_comma) source.passComma(true);
};

template<class T>
void NCASinktRational(NCASink & sink,const tRational<T> & num) {
  int top = num.numerator().internal();
  if(top==0) {
    sink.stream() << " 0";
  } else if(top>0) {
    if(NCASink::s_showPlusWithNumbers) {
      sink.stream() << " + ";
    };
    if(num.denominator().one()) {
      sink.stream() << top;
    } else {
      sink.stream() << "\\frac{" << top << "}{" 
                       << num.denominator().internal() << '}';
    };
  } else {
    sink.stream() << " - ";
    if(num.denominator().one()) {
      sink.stream() << -top;
    } else {
      sink.stream() << "\\frac{" << -top << "}{" 
                       << num.denominator().internal() << '}';
    };
  };
};

void NCASourcetRationalINTEGER(NCASource & source,Holder & numberrep) {
  tRational<INTEGER> * number_p;
  castHolder(numberrep,number_p);
  NCASourceRational(source,*number_p);
};

void NCASinktRationalINTEGER(NCASink & sink,Holder & numberrep) {
  tRational<INTEGER> * number_p;
  castHolder(numberrep,number_p);
  NCASinktRational(sink,*number_p);
};

void NCASourcetRationalLINTEGER(NCASource & source,Holder & numberrep) {
  tRational<LINTEGER> * number_p;
  castHolder(numberrep,number_p);
  NCASourceRational(source,*number_p);
};

void NCASinktRationalLINTEGER(NCASink & sink,Holder & numberrep) {
  tRational<LINTEGER> * number_p;
  castHolder(numberrep,number_p);
  NCASinktRational(sink,*number_p);
};

#if 0
void NCASourcetRationalMyINTEGER(NCASource & source,Holder & numberrep) {
  tRational<MyINTEGER> * number_p;
  castHolder(numberrep,number_p);
  NCASourceRational(source,*number_p);
};

void NCASinktRationalMyINTEGER(NCASink & sink,Holder & numberrep) {
  tRational<MyINTEGER> * number_p;
  castHolder(numberrep,number_p);
  NCASinktRational(sink,*number_p);
};
#endif

void NCASourceZp(NCASource&,Holder &) {
  DBG();
};

void NCASinkZp(NCASink & sink,Holder & numberrep) {
  Zp * number_p;
  castHolder(numberrep,number_p);
  sink.stream() << "(" << number_p->value() << ")_{" 
                << Zp::s_Characteristic() << "}";
};

#include "StartEnd.hpp"

struct NCAFieldSetUp : public AnAction {
  NCAFieldSetUp() : AnAction("NCAFieldSetUp") {};
  void action() {
    NCASource::s_table.add(tRational<INTEGER>::s_ID,
                           NCASourcetRationalINTEGER);
    NCASink::s_table.add(tRational<INTEGER>::s_ID,
                         NCASinktRationalINTEGER);

    NCASource::s_table.add(tRational<LINTEGER>::s_ID,
                           NCASourcetRationalLINTEGER);
    NCASink::s_table.add(tRational<LINTEGER>::s_ID,
                         NCASinktRationalLINTEGER);

    NCASource::s_table.add(Zp::s_ID,NCASourceZp);
    NCASink::s_table.add(Zp::s_ID,NCASinkZp);
  };
};

AddingStart temp1NCAFieldSetUp(new NCAFieldSetUp);
