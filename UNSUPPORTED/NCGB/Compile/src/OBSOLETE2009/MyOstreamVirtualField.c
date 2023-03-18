// Mark Stankus 1999 (c)
// MyOstreamVirtualField.c


#include "SimpleTable.hpp"
#include "Field.hpp"
#include "Holder.hpp"
#include "tRational.hpp"
#include "Zp.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"
#include "MyOstream.hpp"

template<class T>
void MyOstreamtRational(MyOstream & os,tRational<T> & num) {
  int top = num.numerator().internal();
  if(top==0) {
    os << " 0";
  } else if(top>0) {
    if(NCASink::s_showPlusWithNumbers) {
      os << " + ";
    };
    if(num.denominator().one()) {
      os << top;
    } else {
      os << "\\frac{" << top << "}{" 
         << num.denominator().internal() << '}';
    };
  } else {
    os << " - ";
    if(num.denominator().one()) {
      os  << -top;
    } else {
      os << "\\frac{" << -top << "}{" 
         << num.denominator().internal() << '}';
    };
  };
};

void MyOstreamtRationalINTEGER(MyOstream & os,Holder & numberrep) {
  tRational<INTEGER> * number_p;
  castHolder(numberrep,number_p);
  MyOstreamtRational(os,*number_p);
};

void MyOstreamtRationalLINTEGER(MyOstream & os,Holder & numberrep) {
  tRational<LINTEGER> * number_p;
  castHolder(numberrep,number_p);
  MyOstreamtRational(os,*number_p);
};

#if 0
void MyOstreamtRationalLINTEGER(MyOstream & os,Holder & numberrep) {
  tRational<MyINTEGER> * number_p;
  castHolder(numberrep,number_p);
  MyOstreamtRational(os,*number_p);
};
#endif

void MyOstreamZp(MyOstream & os,Holder & numberrep) {
  Zp * number_p;
  castHolder(numberrep,number_p);
  os << "Zp[" << number_p->value() << ',' << Zp::s_Characteristic() << ']';
};

#include "StartEnd.hpp"

struct MyOstreamFieldSetUp : public AnAction {
  NCAFieldSetUp() : AnAction("NCAFieldSetUp") {};
  void action() {
    MyOstream::s_table.add(tRational<INTEGER>::s_ID,
                           MyOstreamtRationalINTEGER);
    MyOstream::s_table.add(tRational<LINTEGER>::s_ID,
                           MyOstreamtRationalLINTEGER);
    MyOstream::s_table.add(Zp::s_ID,MyOstreamZp);
  };
};

AddingStart temp1MyOstreamFieldSetUp(new MyOstreamFieldSetUp);
