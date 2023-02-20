// NCASource.c

#include "NCASource.hpp"
#pragma warning(disable:4786)
#include "asStringGB.hpp"
#include "GBInputNumbers.hpp"
#include "CharacterSource.hpp"
#include "PrintList.hpp"
#include "CharBracketSource.hpp"
#include "stringGB.hpp"
#include "symbolGB.hpp"
#include "FieldChoice.hpp"
#ifdef USE_VIRT_FIELD
#include "FieldRep.hpp"
#include "Holder.hpp"
#endif
#ifdef USE_GB
#include "Field.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"
#include "Term.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#endif
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#include <cstring>
#else
#include <vector.h>
#include <string.h>
#endif
#include <ctype.h>

using namespace std;

#ifdef USE_GB
NCASource::NCASource(CharacterSource * so)  : IISource(so->eof(),true), 
#else
NCASource::NCASource(CharacterSource * so)  : ISource(so->eof(),true), 
#endif
    d_so(so) {
};

NCASource::~NCASource() {
  delete d_so;
};

void NCASource::get(int & x) {
  x = d_so->getNumber();
  if(s_pass_comma) passComma(true);
};

void NCASource::get(long & x) {
  x = d_so->getNumber();
  if(s_pass_comma) passComma(true);
};

void NCASource::get(bool & x) {
  simpleString y;
  int len = 0;
  y = d_so->getAlphaWord(len);
  if(y=="True") {
    x = true;
  } else if(y=="False") {
    x = false;
  } else errorc(__LINE__);
  if(s_pass_comma) passComma(true);
};

void NCASource::get(stringGB & x) {
  int len = 0;
  simpleString s(d_so->getString(len,false));
  x.assign(s.chars());
  if(s_pass_comma) passComma(true);
};

void NCASource::get(symbolGB & x) {
  int len = 0;
  simpleString s(d_so->getWord(len));
  x.assign(s.chars());
  if(s_pass_comma) passComma(true);
};

void NCASource::passString() {
  d_so->passString();
  if(s_pass_comma) passComma(true);
};

void NCASource::get(asStringGB & x) {
  int len = 0;
  simpleString s(d_so->getString(len,false));
  x.assign(s.chars());
  if(s_pass_comma) passComma(true);
};

Alias<ISource> NCASource::inputCommand(symbolGB & x) {
  int len = 0;
  simpleString s(d_so->getAlphaNumWord(len));
  x.assign(s.chars());
  CharBracketSource * p = new CharBracketSource(*d_so,'[',']');
  Alias<ISource> result(new NCASource(p),Adopt::s_dummy);
  char c;
  d_so->getCharacter(c);
  if(c!=';') errorc(__LINE__);
  d_eoi = true;
  return result;
};

Alias<ISource> NCASource::inputFunction(symbolGB & x) {
  char c;
  d_so->peekCharacter(c);
  CharBracketSource * p;
  if(c=='{') {
    p = new CharBracketSource(*d_so,'{','}');
    x.assign("List");
  } else {
    int len = 0;
    simpleString s(d_so->getAlphaWord(len));
    x.assign(s.chars());
    p = new CharBracketSource(*d_so,'[',']');
  };
  Alias<ISource> result(new NCASource(p),Adopt::s_dummy);
  if(s_pass_comma) passComma(true);
  return result;
};

Alias<ISource> NCASource::inputNamedFunction(const symbolGB & x) {
  symbolGB y;
  Alias<ISource> result(inputFunction(y));
  if(!(y.value()==x.value())) errorc(__LINE__);
  return result;
};

Alias<ISource> NCASource::inputNamedFunction(const char * x) {
  symbolGB y;
  Alias<ISource> result(inputFunction(y));
  if(!(y.value()==x)) errorc(__LINE__);
  return result;
};

#ifdef USE_VIRT_FIELD
void NCASource::get(Holder& h) {
  s_table.execute(*this,h);
};
#else
void NCASource::get(Holder&) {
  errorc(__LINE__);
};
#endif

#ifdef USE_GB
void NCASource::get(Field& x) {
#ifdef USE_VIRT_FIELD
  Holder hold((void*)&x.rep(),x.rep().ID());
  s_table.execute(*this,hold);
#else
  x.assign(d_so->getNumber());
  if(!d_so->eof()) {
    // there is more input so perhaps there is a division sign coming up
    char c;
    d_so->peekCharacter(c," \n");
    if(c=='/') {
      d_so->passCharacter();
      int n = d_so->getNumber();
      x /= n;
    };
  };
  if(s_pass_comma) passComma(true);
#endif
};

void NCASource::get(Variable& x) {
  vector<char> str;
  str.reserve(100);
  char c;
  d_so->peekCharacter(c);
  while('a'<=c && c <= 'z' || 'A'<=c && c <='Z') {
    d_so->passCharacter();
    str.push_back(c);
    if(d_so->eof()) {
      d_eoi = true;
      break;
    };
    if(d_so->eof()) {
      d_eoi = true;
      break; // there is no more, so variable cannot continue
    };
    d_so->peekCharacter(c);
  };
  char * t = 0;
  if(!d_eoi) {
    d_so->peekCharacter(c);
    if(c=='[') {
      t  = d_so->grabBracketed('[',']');
    };
  };
  char * s;
  int sz;
  int sz0 = str.size();
  if(t) {
    sz = sz0+strlen(t)+3;
  } else {
    sz = sz0+1;
  };
  s = new char[sz];
  copy(str.begin(),str.end(),s);
  if(t) {
    s[sz0] = '[';
    s[sz0+1] = '\0';
    strcat(s,t);
    s[sz-2] = ']';
  };
  s[sz-1] = '\0';
  x.assign(s);
  delete [] s;
  if(s_pass_comma) passComma(true);
};

void NCASource::get(Monomial& x) {
  bool save = s_pass_comma;
  s_pass_comma = false;
  x.setToOne();
  Variable v;
  get(v);
  x *= v;
  char c;
  if(d_so->eof()) {
    d_eoi = true;
  } else {
    d_so->peekCharacter(c,"\n ");
    if(c=='^') {
      d_so->passCharacter();
      int i = d_so->getNumber();
      if(i<=0) errorc(__LINE__);
      for(int j=2;j<=i;++j) x *= v;
      if(!d_so->eof()) d_so->peekCharacter(c,"\n ");
    };
    while ((!d_so->eof()) && c=='*') {
      d_so->passCharacter();
      d_so->peekCharacter(c,"\n ");
      if(c!='*') errorc(__LINE__);
      d_so->passCharacter();
      get(v);
      x *= v;
      if(d_so->eof()) {
        d_eoi = true;
        break;
      };
      d_so->peekCharacter(c,"\n ");
      if(c=='^') {
        d_so->passCharacter();
        int i = d_so->getNumber();
        if(i<=0) errorc(__LINE__);
        for(int j=2;j<=i;++j) x *= v;
        if(!d_so->eof()) d_so->peekCharacter(c,"\n ");
      };
    };
  };
  s_pass_comma = save;
  if(s_pass_comma) passComma(true);
};

void NCASource::get(Term& x) {
  bool save = s_pass_comma;
  s_pass_comma = false;
  char c;
  d_so->peekCharacter(c,"\n ");
  bool neg = false;
  if(c=='+') {
    d_so->passCharacter();
    d_so->peekCharacter(c,"\n ");
  } else if(c=='-') {
    d_so->passCharacter();
    neg = true;
    d_so->peekCharacter(c,"\n ");
  }; 
  if('0'<=c && c <= '9') {
    // have a number first
    get(x.Coefficient());
    if(d_so->eof()) {
      // if at eof then the monomial is automatically 1
      x.MonomialPart().setToOne();
    } else {
      // check the next character to see if it leads to a monomial or not.
      d_so->peekCharacter(c);
      if(isalpha(c)) {
        get(x.MonomialPart());
      } else {
        x.MonomialPart().setToOne();
      };
    };
  } else if(isalpha(c)) {
    x.Coefficient().setToOne();
    get(x.MonomialPart());
  } else errorc(__LINE__);
  if(neg) x.Coefficient() *= -1;
  s_pass_comma = save;
  if(s_pass_comma) passComma(true);
};

void NCASource::get(Polynomial& x) {
  bool save = s_pass_comma;
  s_pass_comma = false;
  x.setToZero();
  Term t;
  char c;
  d_so->peekCharacter(c,"\n ");
  bool neg = false;
  if(c=='+') {
    d_so->passCharacter();
    d_so->peekCharacter(c,"\n ");
  } else if(c=='-') {
    d_so->passCharacter();
    neg = true;
    d_so->peekCharacter(c,"\n ");
  }; 
  list<Term> L;
  while(('0'<=c && c <= '9') || isalpha(c)) {
    get(t);
    if(neg) t.Coefficient() *= -1;
    neg = false;
    L.push_back(t);
    if(d_so->eof()) {
      d_eoi = true;
      break;
    };
    d_so->peekCharacter(c,"\n ");
    if(c=='+') {
      d_so->passCharacter();
      d_so->peekCharacter(c,"\n ");
    } else if(c=='-') {
      d_so->passCharacter();
      neg = true;
      d_so->peekCharacter(c,"\n ");
    }; 
  };
  x.setWithList(L); 
  s_pass_comma = save;
  if(s_pass_comma) passComma(true);
};

void NCASource::get(GroebnerRule& x) {
  bool save = s_pass_comma;
  s_pass_comma = false;
  get(x.LHS());
  char c;
  d_so->getCharacter(c,"\n ");
  if(c!='-') errorc(__LINE__);
  d_so->getCharacter(c);
  if(c!='>') errorc(__LINE__);
  get(x.RHS());
  s_pass_comma = save;
  if(s_pass_comma) passComma(true);
};
#endif

int NCASource::getType() const {
  int result  = -1;
  char c;
  d_so->peekCharacter(c," \n");
  if(d_so->eof()) result = GBInputNumbers::s_IOEOF;
  return result;
};


void NCASource::vQueryNamedFunction() {
  errorc(__LINE__);
};

ISource * NCASource::clone() const {
  return new NCASource(d_so);
};

void NCASource::vShouldBeEnd() {
  char c;
  if(!d_so->eof()) d_so->peekCharacter(c,"\n ");
};

bool NCASource::s_pass_comma = true;

#ifdef USE_VIRT_FIELD
#include "Choice.hpp"
#ifdef USE_UNIX
#include "SimpleTable.c"
#else
#include "SimpleTable.cpp"
#endif
template class SimpleTable<NCASource>;
SimpleTable<NCASource> NCASource::s_table;
#endif

void NCASource::errorh(int n) { DBGH(n); };

void NCASource::errorc(int n) { DBGC(n); };
