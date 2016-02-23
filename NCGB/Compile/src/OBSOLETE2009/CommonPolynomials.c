// Mark Stankus (c) 1999
// CommonPolynomials.hpp

#include "CommonPolynomials.hpp"
#include "AdmissibleOrder.hpp"
#include "Polynomial.hpp"
#include "PolynomialData.hpp"
#include "GroebnerRule.hpp"

CommonPolynomials::~CommonPolynomials() {
  delete d_rule_p;
};

bool CommonPolynomials::getNext(Polynomial & p,Tag *,Tag & limit) {
  bool result = false;
  typedef list<RuleID>::iterator PLI;
  typedef list<Status>::iterator SLI;
  PLI w = d_polys.begin(), e = d_polys.end();
  SLI ww = d_status.begin();
  while(w!=e) {
    const Status & S = *ww;
    if(S.status()==Status::s_UNREDUCED) {
      p = (*w).poly(); 
      result = true;
      d_polys.erase(w);
      d_status.erase(ww);
      break;
    };
    ++w;++ww;
  };
  return result; 
};

void CommonPolynomials::insert(const RuleID & x) {
  AdmissibleOrder & ord = AdmissibleOrder::s_getCurrent();
  const Monomial & m = x.poly().tipMonomial();
  typedef list<RuleID>::iterator PLI;
  typedef list<Status>::iterator SLI;
  PLI w = d_polys.begin(), e = d_polys.end();
  SLI ww = d_status.begin();
  while(w!=e && ord.monomialLess((*w).poly().tipMonomial(),m)) {
    ++w;++ww;
  }; 
  if(w!=e && (*w).poly().tipMonomial()==m) {
    Polynomial q(x.poly());
    q -= (*w).poly();
    RuleID y(q,x.number());  // dangerous!!!
    insert(y);
  } else {
    d_polys.insert(w,x);
    Status stat;
    d_status.insert(ww,stat);
  };
};

void CommonPolynomials::insert(const PolynomialData & x) {
  AdmissibleOrder & ord = AdmissibleOrder::s_getCurrent();
  const Monomial & m = x.d_p.tipMonomial();
  typedef list<RuleID>::iterator PLI;
  typedef list<Status>::iterator SLI;
  PLI w = d_polys.begin(), e = d_polys.end();
  SLI ww = d_status.begin();
  while(w!=e && ord.monomialLess((*w).poly().tipMonomial(),m)) {
    ++w;++ww;
  }; 
  if(w!=e && (*w).poly().tipMonomial()==m) {
    Polynomial q(x.d_p);
    q -= (*w).poly();
    RuleID y(q,x.d_number);  // dangerous!!!
    insert(y);
  } else {
    RuleID y(x.d_p,x.d_number);
    d_polys.insert(w,y);
    Status stat;
    d_status.insert(ww,stat);
  };
};

void CommonPolynomials::remove(const RuleID & x) {
  int num = x.number();
  typedef list<RuleID>::iterator PLI;
  typedef list<Status>::iterator SLI;
  PLI w = d_polys.begin(), e = d_polys.end();
  SLI ww = d_status.begin();
  while(w!=e && (*w).number()!=num) { ++w;++ww; };
  if(w==e) {
    GBStream << "Error: cannout remove RuleID with id number" << num << '\n';
  } else {
    d_polys.erase(w);
    d_status.erase(ww);
  };
};


void CommonPolynomials::print(MyOstream & os) const { 
  typedef list<RuleID>::const_iterator PLI;
  typedef list<Status>::const_iterator SLI;
  PLI w = d_polys.begin(), e = d_polys.end();
  SLI ww = d_status.begin();
  while(w!=e) { 
    const RuleID & x =  (*w);
    int num = (*ww).status();
    os << "rule(" << x.number() << "): " << x.poly() << '\n';
    os << "status: ";
    if(num==Status::s_UNREDUCED) {
      os << "Unreduced"; 
    } else if(num==Status::s_REDUCED) {
      os << "Reduced"; 
    } else if(num==Status::s_CIRCLEREDUCED) {
      os << "CircleReduced"; 
    } else DBG();
    os << '\n';
    ++w;++ww; 
  };
};

void CommonPolynomials::fillForUnknownReason() {};
void CommonPolynomials::setPerm(int n) {};
void CommonPolynomials::setNotPerm(int) {};

#if 0
bool CommonPolynomials::reduce(list<RuleID>::const_iterator & x) {
  bool result = false;
  const Polynomial & front_poly = (*x).poly();
  const Term       & front_term = front_poly.tip();
  const Monomial   & front_mono = front_term.MonomialPart();
  Polynomial * p = 0;
  Monomial const * m = 0;
  typedef list<RuleID>::const_iterator LCI;
  LCI w = d_polys.begin(), e = d_polys.end();
  while(w!=x && w !=e) {
    if(divides((*w).poly().tip().MonomialPart(),front_mono) {
      p = new Polynomial;
      // fill *p appropriately 
      m = & (*p).poly().tip().MonomialPart(); 
      break;
    } else {
      ++w;
    };
  };
  if(w==e && !result) DBG();
  if(result && p->zero()) {
    x = d_polys.end();
  } else if(result) {
    bool todo = true;
    while(todo) { 
      todo = false;
      w = d_polys.begin();
      while(w!=e &&   
          AdmissibleOrder::s_getCurrent().monomialLess(*w.tipMonomial(),*m)) {
        if(divides((*w).tip().MonomialPart(),*m) {
          // modify *p appropriately 
          if(p->zero()) {
            todo = false;
            break;
          } else {
            m = & (*p).tip().MonomialPart(); 
            todo = true;
          };
        } else {
          ++w;
        }; // if
      }; // while w!=e && ... 
    }; // while todo
    if(p->zero()) {
      x = d_polys.end();
    } else {
      w = d_polys.begin();
      while(w!=e && 
        AdmissibleOrder::s_getCurrent().monomialLess(*w.tipMonomial(),*m)) {};
      d_polys.insert(w,*p);
      m = 0; delete p;
      x = w;
    }; //if p->zero()
  }; //if result
  return result;
};
#endif

const GroebnerRule & CommonPolynomials::fact(int n) const {
  typedef list<RuleID>::const_iterator PLI;
  PLI w = d_polys.begin(), e = d_polys.end();
  while(w!=e) {
    if((*w).number()==n) {
      d_rule_p->convertAssign((*w).poly());
      break;
    };
    ++w;
  };
  return *d_rule_p;
};

int CommonPolynomials::findInt(const Polynomial & x) {
  DBG();
  return 0;
};

const int CommonPolynomials::Status::s_UNREDUCED = 0;
const int CommonPolynomials::Status::s_REDUCED = 1;
const int CommonPolynomials::Status::s_CIRCLEREDUCED = 2;
#include "idValue.hpp"
const int CommonPolynomials::s_ID = idValue("CommonPolynomials::s_ID"); 
