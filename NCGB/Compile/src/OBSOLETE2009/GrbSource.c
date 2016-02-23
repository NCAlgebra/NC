// GrbSource.c

#include "GrbSource.hpp"
#include "stringGB.hpp"
#include "asStringGB.hpp"
#include "symbolGB.hpp"
#include "Field.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"
#include "Term.hpp"
#include "Polynomial.hpp"

GrbSource::~GrbSource() {};

void GrbSource::get(bool &) {
  errorc(__LINE__);
};

void GrbSource::get(int & x) {
  x = d_so.getNumber();
  d_eoi = d_so.eof();
};

void GrbSource::get(long & x) {
  x = d_so.getNumber();
  d_eoi = d_so.eof();
};

void GrbSource::get(stringGB &) {
  errorc(__LINE__);
  d_eoi = d_so.eof();
};

void GrbSource::get(asStringGB &) {
  errorc(__LINE__);
  d_eoi = d_so.eof();
};

void GrbSource::get(symbolGB &) {
  errorc(__LINE__);
  d_eoi = d_so.eof();
};

void GrbSource::passString() {
  errorc(__LINE__);
  d_eoi = d_so.eof();
};

Alias<ISource> GrbSource::inputCommand(symbolGB &) {
  errorc(__LINE__);
  d_eoi = d_so.eof();
  return *(Alias<ISource> *) 0;
};

Alias<ISource> GrbSource::inputFunction(symbolGB &) {
  errorc(__LINE__);
  d_eoi = d_so.eof();
  return *(Alias<ISource> *) 0;
};

Alias<ISource> GrbSource::inputNamedFunction(const symbolGB &) {
  errorc(__LINE__);
  d_eoi = d_so.eof();
  return *(Alias<ISource> *) 0;
};

Alias<ISource> GrbSource::inputNamedFunction(const char *) {
  errorc(__LINE__);
  d_eoi = d_so.eof();
  return *(Alias<ISource> *) 0;
};


void GrbSource::get(Holder&) {
  errorc(__LINE__);
};
void GrbSource::get(Field& x) {
  int n = d_so.getNumber();
  x.assign(n);
  d_eoi = d_so.eof();
};

void GrbSource::get(Variable& x) {
  char s[2];
  s[1]='\0';
  d_so.getCharacter(s[0]);
  x.assign(s);
  d_eoi = d_so.eof();
};

void GrbSource::get(Monomial& x) {
  x.setToOne();
  Variable v;
  char s[2];
  s[1]='\0';
  d_so.getCharacter(s[0],"\n *");
  while(('a'<=*s && *s<='z') || ('A'<=*s&& *s<='Z')) {
    v.assign(s);
    x *= v;
    d_so.getCharacter(s[0]);
  };
  d_so.unGetCharacter(s[0]);
  d_eoi = d_so.eof();
};

void GrbSource::get(Term& x) {
  char c;
  d_so.peekCharacter(c,"\n *");
  if(c=='+') { 
    d_so.passCharacter();
    d_so.peekCharacter(c,"\n *");
  };
  if(c=='-' || ('0'<=c && c <= '9')) {
    // have a number first
    get(x.Coefficient());
    get(x.MonomialPart());
  } else if('a'<=c && c <= 'z') {
    x.Coefficient().setToOne();
    get(x.MonomialPart());
  } else if('A'<=c && c <= 'Z') {
    x.Coefficient().setToOne();
    get(x.MonomialPart());
  } else if(c=='(') {
    d_so.getCharacter(c,"\n *");
    if(c!='1') errorc(__LINE__);
    d_so.getCharacter(c,"\n *");
    if(c!=')') errorc(__LINE__);
    x.Coefficient().setToOne();
    x.MonomialPart().setToOne();
  } else errorc(__LINE__);
  d_eoi = d_so.eof();
};

void GrbSource::get(Polynomial& x) {
  x.setToZero();
  Term t;
  char c;
  d_so.peekCharacter(c,"\n *");
  list<Term> L;
  while(c!=';') {
    get(t);
    L.push_back(t);
    d_so.peekCharacter(c,"\n *");
  };
  x.setWithList(L);
  d_so.passCharacter();
  if(x.zero()) d_eoi = true;
};

void GrbSource::vQueryNamedFunction() {
  errorc(__LINE__);
  d_eoi = d_so.eof();
};

void GrbSource::vShouldBeEnd() {
  errorc(__LINE__);
  d_eoi = d_so.eof();
};

ISource * GrbSource::clone() const {
  errorc(__LINE__);
  return new GrbSource(d_so);
};

int GrbSource::getType() const {
  errorc(__LINE__);
  return -1;
};

void GrbSource::errorh(int n) { DBGH(n); };

void GrbSource::errorc(int n) { DBGC(n); };
