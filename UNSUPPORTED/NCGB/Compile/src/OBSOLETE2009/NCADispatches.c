// Mark Stankus 1999 (c)
// NCADispatches.cpp


#include "Holder.hpp"
#include "tRational.hpp"
#include "Zp.hpp"
#include "NCASink.hpp"
#include "Sink.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"

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

void NCASinktRationalINTEGER(Holder & sink,Holder & numberrep) {
  NCASink * sink_p;
  tRational<INTEGER> * number_p;
  castHolder(sink,sink_p);
  castHolder(numberrep,number_p);
  NCASinktRational(* sink_p,*number_p);
};

void NCASinktRationalLINTEGER(Holder & sink,Holder & numberrep) {
  NCASink * sink_p;
  tRational<LINTEGER> * number_p;
  castHolder(sink,sink_p);
  castHolder(numberrep,number_p);
  NCASinktRational(* sink_p,*number_p);
};

#if 0
void NCASinktRationalMyINTEGER(Holder & sink,Holder & numberrep) {
  NCASink * sink_p;
  tRational<MyINTEGER> * number_p;
  castHolder(sink,sink_p);
  castHolder(numberrep,number_p);
  NCASinktRational(* sink_p,*number_p);
};
#endif

void NCASinkZp(Holder & sink,Holder & numberrep) {
  NCASink * sink_p;
  Zp * number_p;
  castHolder(sink,sink_p);
  castHolder(numberrep,number_p);
  sink_p->stream() << "(" << number_p->value() << ")_{" 
                   << Zp::s_Characteristic() << "}";
};

#include "StartEnd.hpp"

struct NCADispatchSetUp : public AnAction {
  NCADispatchSetUp() : AnAction("NCADispatchSetUp") {};
  void action() {
    pair<int,int> pr(NCASink::s_ID,tRational<INTEGER>::s_ID);
    NCASink::s_doubledispatch.assign(pr,NCASinktRationalINTEGER);
    pr.second = tRational<LINTEGER>::s_ID;
    NCASink::s_doubledispatch.assign(pr,NCASinktRationalLINTEGER);
    pr.second = Zp::s_ID;
    NCASink::s_doubledispatch.assign(pr,NCASinkZp);
  };
};

AddingStart temp1NCADispatch(new NCADispatchSetUp);
