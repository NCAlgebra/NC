// Mark Stankus 1999 (c)
// MmaSource.c

#include "MmaSource.hpp"
#include "AppendItoString.hpp"
#include "TellHead.hpp"
#include "CountSource.hpp"
#include "stringGB.hpp"
#include "symbolGB.hpp"
#include "asStringGB.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"
#include "Term.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "Debug1.hpp"
#include "Choice.hpp"
#include "GBInputNumbers.hpp"
#include "GBStream.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif

//#define DEBUG_MMASOURCE

MmaSource::~MmaSource() {};

void MmaSource::get(bool & x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:bool:" << this << '\n';
#endif
  int type = getType();
  if(type==MLTKINT) {
    int n;
    get(n);
    x = n!=0;
  } else if(type==MLTKSYM) {
    char * s;
    MLGetSymbol(d_mlink,(const char **)&s);
    if(strcmp(s,"True")==0) {
      x = true;
    } else if(strcmp(s,"False")==0) {
      x = false;
    } else {
      GBStream << "Expecting (the symbol) True or False, but received neither\n";
      GBStream << "Recieved " << s << '\n';
      errorc(__LINE__);
    };
  } else {
    GBStream << "Expecting True, False, or an integer but none of them\n";
    TellJustHead(*this); 
    errorc(__LINE__);
  };
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x << '\n';
  checkforerror();
#endif
};

void MmaSource::get(int & x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:int:" << this << '\n';
#endif
  if(!MLGetInteger(d_mlink,&x)) {
    GBStream << "Expecting an integer but received\n";
    TellJustHead(*this);
    errorc(__LINE__);
  };
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x << '\n';
  checkforerror();
#endif
};

void MmaSource::get(long & x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:long:" << this << '\n';
#endif
  if(!MLGetLongInteger(d_mlink,&x)) {
    GBStream << "Expecting an integer but received\n";
    TellJustHead(*this);
    errorc(__LINE__);
  };
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x << '\n';
  checkforerror();
#endif
};

void MmaSource::get(stringGB & x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:string:" << this << '\n';
#endif
  char * s;
  if(!MLGetString(d_mlink,(const char * *)&s)) {
    GBStream << "Expecting a string but received\n";
    TellJustHead(*this);
    errorc(__LINE__);
  };
  x.assign(s);
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x.value().chars() << '\n';
  checkforerror();
#endif
};

void MmaSource::get(asStringGB & x) {
  char * s;
  int type= getType();
  if(type==MLTKSYM) {
#ifdef DEBUG_MMASOURCE
    GBStream << "source:symbol:string:" << this << '\n';
#endif
    MLGetSymbol(d_mlink,(const char **)&s);
  } else if (type==MLTKSTR) {
#ifdef DEBUG_MMASOURCE
    GBStream << "source:string:string:" << this << '\n';
#endif
    MLGetString(d_mlink,(const char **)&s);
  } else {
    GBStream << "Expecting a string or a symbol but received \n";
    TellJustHead(*this);
    errorc(__LINE__);
  };
  x.assign(s);
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x.value().chars() << '\n';
  checkforerror();
#endif
};

void MmaSource::get(symbolGB & x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:symbol:string:" << this << '\n';
#endif
  char * s;
  if(!MLGetSymbol(d_mlink,(const char **)&s)) {
    GBStream << "Expecting a symbol but received \n";
    TellJustHead(*this);
    errorc(__LINE__);
  };
  x.assign(s);
  MLDisownSymbol(d_mlink,s);
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x.value().chars() << '\n';
  checkforerror();
#endif
};

void MmaSource::passString() {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:pass string:" << this << '\n';
#endif
  char * s;
  if(!MLGetString(d_mlink,(const char **)&s)) {
    GBStream << "Expecting a string but received \n";
    TellJustHead(*this);
    errorc(__LINE__);
  };
#ifdef DEBUG_MMASOURCE
  GBStream << "passing:" << s << '\n';
  checkforerror();
#endif
  MLDisownString(d_mlink,s);
};

Alias<ISource> MmaSource::inputCommand(symbolGB &) {
  errorc(__LINE__);
  Alias<ISource> result(0,Adopt::s_dummy);
  return result;
};

Alias<ISource> MmaSource::inputNamedFunction(const char * x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:named function " << x << ' ' << this << '\n';
#endif
  symbolGB y;
  Alias<ISource> result(inputFunction(y));
  if(!(y.value()==x)) {
    GBStream << "Expecting a head of " << x << " but received " << y.value() 
             << '\n';
    errorc(__LINE__);
  };
  return result;
};

Alias<ISource> MmaSource::inputNamedFunction(const symbolGB & x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:named function " << x.value() << ' ' << this << '\n';
#endif
  symbolGB y;
  Alias<ISource> result(inputFunction(y));
  if(y!=x) {
    GBStream << "Expecting a head of " << x.value() << " but received " 
             << y.value() << '\n';
    errorc(__LINE__);
  };
  return result;
};

MmaSource * s_Source_for_New_Packet_p = 0;

void do_the_new_packet() {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:newpacket \n";
#endif
#if 1
  if(!s_Source_for_New_Packet_p) MmaSource::errorc(__LINE__);
  s_Source_for_New_Packet_p->setEOIFlag();
  s_Source_for_New_Packet_p->shouldBeEnd();
  s_Source_for_New_Packet_p = 0;
#else
  if(!MLNewPacket(stdlink)) MmaSource::errorc(__LINE__);
#endif
};

Alias<ISource> MmaSource::inputFunction(symbolGB & x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:named function " << x.value() << ' ' << this << '\n';
#endif
  long L;
  getFunction(x,L);
  const char * s = x.value().chars();
  char * t = new char[strlen(s)+1];
  strcpy(t,s);
  x.assign(t);
  if(d_has_new_packet) {
    Alias<ISource> result(new CountSource(*this,L,do_the_new_packet),
                          Adopt::s_dummy);
    s_Source_for_New_Packet_p = this;
    d_has_new_packet = false;
    return result;
  };
  Alias<ISource> result(new CountSource(*this,L,0),Adopt::s_dummy);
#ifdef DEBUG_MMASOURCE
  checkforerror();
#endif
  return result;
};

#ifdef USE_VIRT_FIELD
void MmaSource::get(Holder& h) {
  s_table.execute(*this,h);
#else
void MmaSource::get(Holder&) {
  errorc(__LINE__);
#endif
};

void MmaSource::get(Field& x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:number" << this << '\n';
#endif
  int type = getType();
  if(type==MLTKINT) {
    int i; 
    get(i);
    x = i;
  } else if(type==MLTKFUNC) {
    queryFunction();
    if(!(d_old_function_name=="Rational")) errorc(__LINE__);
    if(d_length!=2L) errorc(__LINE__);
    passFunction();
    int i;
    get(i);
    x = i;
    get(i);
    x /= i;
  } else {
    GBStream << "Was expecting an integer of a rational number, but received";
    TellJustHead(*this);
    errorc(__LINE__);
  };
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x << '\n';
  checkforerror();
#endif
};

void variableHelper1(vector<char*> &,MmaSource & ,long &,bool);

void bracketsAndArgs(vector<char *> & strs,MmaSource & so,long L,long & len) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:bracketsAndArgs\n";
#endif
  char * lbrack = new char[2];
  lbrack[0] = '[';
  lbrack[1] = '\0';
  strs.push_back(lbrack);
  ++len;
  if(L!=0) {
    variableHelper1(strs,so,len,true);
    --L;
  };
  while(L!=0L) {
    char * comma = new char[2];
    comma[0] = ',';
    comma[1] = '\0';
    strs.push_back(comma);
    ++len;
    variableHelper1(strs,so,len,true);
    --L;
  };
  char * rbrack = new char[2];
  rbrack[0] = ']';
  rbrack[1] = '\0';
  strs.push_back(rbrack);
  ++len;
};

void variableHelper1(vector<char*> & strs,MmaSource & so,long & len,bool intok) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:variableHelper1 \n";
#endif
  int type = so.getType();
  symbolGB str;
  if(type==MLTKSYM) {
    so.get(str); 
    int len2 = strlen(str.value().chars());
    char * t = new char[len2+1];
    strcpy(t,str.value().chars());
    strs.push_back(t); 
    len += len2;
  } else if(type==MLTKFUNC) {
    long L;
    so.getFunction(str,L);
    int len2 = strlen(str.value().chars());
    char * t = new char[len2+1];
    strcpy(t,str.value().chars());
    strs.push_back(t); 
    bracketsAndArgs(strs,so,L,len);
    len += len2;
  } else if(type==MLTKINT) {
    if(!intok) {
      GBStream << "A variable cannot start with a number\n";
      MmaSource::errorc(__LINE__);
    };
    int n;
    so.get(n);
    char * s = 0;
    ItoString(n,s);
    strs.push_back(s);
    len += strlen(s);
  } else {
    GBStream << "Trouble understanding variable name\n";
    MmaSource::errorc(__LINE__); 
  };
#ifdef DEBUG_MMASOURCE
  GBStream << "variableHelper1.\n";
  GBStream << "The vector is as follows:\n";
  typedef vector<char *>::const_iterator VI;
  VI w = strs.begin(), e = strs.end();
  while(w!=e) {
    GBStream << *w <<'|';
    ++w;
  };
  GBStream << "Length:" << len << '\n';
#endif
};

char * CreateStringFromVectorCharStar(vector<char *> & str,long len) { 
  char * s = new char[len+1];
  *s = '\0';
  typedef vector<char *>::iterator VI;
  VI w = str.begin(), e = str.end();
  while(w!=e) {
    char * & p = *w;
    strcat(s,p);
    delete [] p;
    p = 0;
    ++w;
  };
  s[len] = '\0';
#ifdef DEBUG_MMASOURCE
  GBStream << "String:" << s << " of length " << len << '\n';
#endif
  return s;
};

void MmaSource::get(Variable& x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:variable " << this << '\n';
#endif
  vector<char *> str;
  long len = 0L;
  variableHelper1(str,*this,len,false);
  char * s = CreateStringFromVectorCharStar(str,len);
  x.assign(s);
  delete [] s;
#ifdef DEBUG_MMASOURCE
  GBStream << "variable result:" << x.cstring() << '\n';
  checkforerror();
#endif
};

void MmaSource::get(Monomial& x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:monomial " << this << '\n';
#endif
  x.setToOne();
  Variable v;
  int type = getType();
  if(type==MLTKINT) {
    int i;
    get(i);
    if(i!=1) errorc(__LINE__);
  } else if(type==MLTKFUNC) {
    Variable v;
    queryFunction();
    if(d_old_function_name=="NonCommutativeMultiply") {
      passFunction();
      // have a monomial of degree >=2
      int len = d_length;
      for(long i=1L;i<=len;++i) {
        get(v);
        x *= v;
      };
    } else {
      // have a monomial of degree = 1
      get(v);
      x *= v;
    }; 
  } else {
    // have a monomial of degree = 1 with noncomplicated name
    get(v);
    x *= v;
  };
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x << '\n';
  checkforerror();
#endif
};

void MmaSource::get(Term& x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:term " << this << '\n';
#endif
  int type = getType();
  if(type==MLTKFUNC) {
    queryFunction();
    if(d_old_function_name.value()=="Times") {
      passFunction();
      get(x.Coefficient());
      get(x.MonomialPart());
    } else if((d_old_function_name.value()=="Rational") ||
              (d_old_function_name.value()=="Integer")  || 
              (d_old_function_name.value()=="RATIONAL")) {
      get(x.Coefficient());
      x.MonomialPart().setToOne();
    } else {
      x.Coefficient().setToOne();
      get(x.MonomialPart());
    };
  } else if(type==MLTKSYM) {
    x.Coefficient().setToOne();
    Variable v;
    get(v);
    x.MonomialPart().setToOne();
    x.MonomialPart() *= v;
  } else if(type==MLTKINT) {
    int i;
    get(i);
    x.Coefficient().assign(i);
    x.MonomialPart().setToOne();
  } else {
    GBStream << "Trouble getting a term\n";
    TellJustHead(*this);
    errorc(__LINE__);
  };
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x << '\n';
  checkforerror();
#endif
};

void MmaSource::get(Polynomial& x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:polynomial " << this << '\n';
#endif
  Polynomial temp;
  x.setToZero();
  int type = getType();
  if(type==MLTKINT) {
    int i;
    get(i);
    Field f(i);
    Term t(f);
    temp = t;
    x += temp;
  } else if(type==MLTKSYM) {
    Variable v;
    get(v);
    Monomial m;
    m *= v;
    Term t(m);
    temp = t;
    x += temp;
  } else if(type==MLTKFUNC) {
    Term t;
    queryFunction();
    if(d_old_function_name.value()=="Plus") {
      passFunction();
      int len = d_length;
      for(int i=1L;i<=len;++i) {
        get(t);
        temp = t;
        x += temp;
      };
    } else {
      get(t);
      temp=t;
      x += temp;
    };
  } else errorc(__LINE__);
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x << '\n';
  checkforerror();
#endif
};

void MmaSource::get(GroebnerRule& x) {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:rule " << this << '\n';
#endif
  queryFunction();
  if(!(d_old_function_name.value()=="Rule")) errorc(__LINE__);
  if(d_length!=2L) errorc(__LINE__);
  passFunction();
  get(x.LHS());
  get(x.RHS());
#ifdef DEBUG_MMASOURCE
  GBStream << "result:" << x << '\n';
  checkforerror();
#endif
};

void MmaSource::vQueryNamedFunction() {
  queryFunction();
};

void MmaSource::vShouldBeEnd() {
#ifdef DEBUG_MMASOURCE
  GBStream << "Another vShouldBeEnd\n";
#endif
  if(!MLNewPacket(d_mlink)) errorc(__LINE__);
#ifdef DEBUG_MMASOURCE
  checkforerror();
#endif
};

ISource * MmaSource::clone() const {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:clone " << this << '\n';
#endif
  MmaSource * p = new MmaSource(d_mlink);
  p->d_length = this->d_length;
  errorc(__LINE__);
  return p;
};

int MmaSource::getType() const {
#ifdef DEBUG_MMASOURCE
  GBStream << "source:getType " << this << '\n';
#endif
  int result;
  if(d_old_function_name_valid) {
    result = GBInputNumbers::s_IOFUNCTION;
  } else {
    result = MLGetType(d_mlink); 
  };
#ifdef DEBUG_MMASOURCE
  checkforerror();
#endif
  return result;
};

bool MmaSource::verror() const {
  bool result = MLError(d_mlink)!=MLEOK;
  if(result) {
    GBStream << "MATHLINK ERROR MESSAGE: " << MLErrorMessage(d_mlink) << '\n';
  };
  return result;
};

void MmaSource::checkforerror() const {
  bool result = MLError(d_mlink)!=MLEOK;
  if(result) {
    GBStream << "MATHINK ERROR MESSAGE: " << MLErrorMessage(d_mlink) << '\n';
  };
  if(result) errorc(__LINE__);
};

void MmaSource::errorh(int n) { DBGH(n); };

void MmaSource::errorc(int n) { DBGC(n); };

#include "idValue.hpp"
const int MmaSource::s_ID = idValue("MmaSource::s_ID");

#ifdef USE_VIRT_FIELD
#include "Choice.hpp"
#ifdef USE_UNIX
#include "SimpleTable.c"
#else
#include "SimpleTable.cpp"
#endif
#ifdef OLD_GCC
template class vector<pair<int,void(*)(MmaSource &,Holder &)> >;
template class vector<pair<int,void(*)(MmaSource &,const Holder &)> >;
#endif
template class SimpleTable<MmaSource>;
SimpleTable<MmaSource> MmaSource::s_table;
#endif
