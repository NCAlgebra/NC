// WFileSource.c

#include "Choice.hpp"
#ifdef USE_WFILE
#include "WFileSource.hpp"
#include "Variable.hpp"
#include "CommandPlace.hpp"
#include "RecordHere.hpp"
#include "CountSource.hpp"
#include "TellHead.hpp"
#include "Command.hpp"
#include "asStringGB.hpp"
#include "stringGB.hpp"
#include "simpleString.hpp"
#include "symbolGB.hpp"
#include "CountSource.hpp"
#include "GBInputNumbers.hpp"
#include "MyOstream.hpp"

//#define DEBUGINPUT

WFileSource::~WFileSource(){
  if(d_old_function_name_valid) DBG();
};

int WFileSource::fastType() const {
  if(!d_type_valid) {
    WFileSource * alias = const_cast<WFileSource*>(this);
    alias->d_old_function_name_valid = false;
    char c;
    d_so.getCharacter(c);
#ifdef DEBUGINPUT
GBStream << "c:" << c << '\n';
#endif
    if(c=='E') {
      d_so.getCharacter(c); if(c!='O') DBG();
      d_so.getCharacter(c);
      switch(c) {
      case 'F':
        alias->d_type = GBInputNumbers::s_IOEOF;
        break;
      case 'I':
        alias->d_type = GBInputNumbers::s_IOEOI;
        alias->d_eoi = true;
        break;
      default:
        DBG();
      };
    } else {
      alias->d_len = d_so.grabInteger();
      char d;
      d_so.getCharacter(d);
#ifdef DEBUGINPUT
    GBStream << "d:" << d << '\n';
#endif
      switch(c) {
      case 'F' :
         if(d!='N') DBG();
         alias->d_count = d_so.grabInteger();
         d_so.getCharacter(d); if(d!='C') DBG();
         alias->d_type = GBInputNumbers::s_IOFUNCTION;
         break;
      case 'G':
         if(d!='C') DBG();
         alias->d_count = 0;
         alias->d_type = GBInputNumbers::s_IOCOMMAND;
         break;
      case 'I':
         if(d!='N') DBG();
         alias->d_type = GBInputNumbers::s_IOINTEGER;
         break;
      case 'S':
         switch(d) {
           case 'T':
           alias->d_type = GBInputNumbers::s_IOSTRING;
           break;
         case 'Y':
           alias->d_type = GBInputNumbers::s_IOSYMBOL;
           break;
         default:
           GBStream << "c is:" << c << '\n';
           GBStream << "d is:" << d << '\n';
           DBG();
        };
        break;
      default:
        GBStream << "c is:" << c << '\n';
        GBStream << "d is:" << d << '\n';
        DBG();
      };
    };
    alias->d_type_valid=true;
  };
  return d_type;
};

int WFileSource::getType() const {
  if(!d_type_valid) fastType();
  return d_type;
};

void WFileSource::get(int & x) {
  if(fastType()!=GBInputNumbers::s_IOINTEGER) TellHead(*this);
  x = d_so.grabInteger();
  d_type_valid = false;
  fastType();
};

void WFileSource::get(long & x) {
  int n;
  get(n);
  x = n;
};

void WFileSource::get(stringGB & x) {
  if(fastType()!=GBInputNumbers::s_IOSTRING) TellHead(*this);
  x = d_so.getStringWithLength(d_len);
  d_type_valid = false;
  fastType();
};

void WFileSource::get(symbolGB & x) {
  if(fastType()!=GBInputNumbers::s_IOSYMBOL) TellHead(*this);
  x = d_so.getStringWithLength(d_len);
  d_type_valid = false;
  fastType();
};

void WFileSource::get(asStringGB & x) {
  int type = fastType();
  if(type!=GBInputNumbers::s_IOSYMBOL&& type!=GBInputNumbers::s_IOSYMBOL) {
     TellHead(*this);
  };
  x = d_so.getStringWithLength(d_len);
  d_type_valid = false;
  fastType();
};

void WFileSource::passString() {
  int type = fastType();
  if(type!=GBInputNumbers::s_IOSTRING) {
     TellHead(*this);
  };
  d_so.passString();
  d_type_valid = false;
  fastType();
};

Alias<ISource> WFileSource::inputCommand(symbolGB & x) {
  if(fastType()!=GBInputNumbers::s_IOCOMMAND) TellHead(*this);
  x = d_so.getStringWithLength(d_len);
GBStream << "have the command:" << x.value().chars() << '\n';
  CommandPlace::s_setCommandPlace(x.value().chars());
  Alias<ISource> counted(
       new CountSource(*this,CommandPlace::s_CommandPlace->d_numargs,0),
       Adopt::s_dummy);
  d_type_valid = false;
  fastType();
  return counted;
};

Alias<ISource> WFileSource::inputFunction(symbolGB & x) {
  if(fastType()!=GBInputNumbers::s_IOFUNCTION) TellHead(*this);
  if(d_old_function_name_valid) {
     x = d_old_function_name;
     d_old_function_name_valid = false;
  } else {
    x = d_so.getStringWithLength(d_len);
  };
  long n = d_count;
  Alias<ISource> result(new CountSource(*this,n,0),Adopt::s_dummy);
  d_type_valid = false;
  fastType();
  return result;
};

Alias<ISource> WFileSource::inputNamedFunction(const symbolGB & x) {
  symbolGB y;
  Alias<ISource> result(inputFunction(y));
  if(!(x.value()==y.value())) DBG();
  return result;
};

Alias<ISource> WFileSource::inputNamedFunction(const char * x) {
  symbolGB y;
  Alias<ISource> result(inputFunction(y));
  if(!(y.value()==x)) DBG();
  return result;
};

ISource * WFileSource::clone() const {
  WFileSource * p  = new WFileSource(d_so);
  p->d_type = d_type;
  p->d_type_valid = d_type_valid;
  p->d_count = d_count;
  p->d_len = d_len;
  return p;
};

void WFileSource::vShouldBeEnd() {
  if(!d_type_valid) getType();
  if(d_type_valid && d_type==GBInputNumbers::s_IOEOI) {
    d_type_valid = false;
  } else DBG();
};

void WFileSource::get(Holder&) {
  errorc(__LINE__);
};
void WFileSource::get(Variable& x) {
  symbolGB y;
  get(y);
  x.assign(y.value().chars());
};

void WFileSource::vQueryNamedFunction() {
  if(!d_old_function_name_valid) {
    if(getType()!=GBInputNumbers::s_IOFUNCTION) DBG();
    d_old_function_name = d_so.getStringWithLength(d_len);
    d_old_function_name_valid = true;
  };
};
#endif
