// (c) Mark Stankus 1999 
// TeXSink.c

#include "TeXSink.hpp"
#include "MyOstream.hpp"
#include "asStringGB.hpp"
#include "stringGB.hpp"
#include "symbolGB.hpp"
#include "Debug1.hpp"
#include "Field.hpp"
#include "Variable.hpp"
#include "Monomial.hpp"
#include "Term.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "MonomialToPowerList.hpp"

TeXSink::~TeXSink() {};

void TeXSink::flush() {
  d_os.flush();
};

void TeXSink::put(bool x) {
  if(x) {
    d_os << "{\\tt true}";
  } else d_os << "{\\tt false}";
};

void TeXSink::put(int x) {
  d_os << x;
};

void TeXSink::put(long x) {
  d_os << x;
};

#ifdef USE_UNIX
void TeXSink::put(long long x) {
  d_os << x;
};
#endif

void TeXSink::put(const char * x) {
  d_os << x;
};

TeXSink & TeXSink::operator<<(int x) {
  d_os << x;
  return * this;
};

TeXSink & TeXSink::operator<<(char x) {
  d_os << x;
  return * this;
};

TeXSink & TeXSink::operator<<(const char * x) {
  d_os << x;
  return * this;
};

TeXSink & TeXSink::operator<<(float x) {
  d_os.getostream() << x;
  return * this;
};

TeXSink & TeXSink::operator<<(double x) {
  d_os.getostream() << x;
  return * this;
};


void TeXSink::put(const stringGB &) {
  errorc(__LINE__);
};

void TeXSink::put(const symbolGB & x) {
  d_os << "\\mbox{$ " << x.value().chars() << "$}\n";
};

void TeXSink::put(const asStringGB &) {
  errorc(__LINE__);
};

Alias<ISink> TeXSink::outputFunction(const symbolGB &,long) {
  errorc(__LINE__);
  return *(Alias<ISink> *) 0;
};

Alias<ISink> TeXSink::outputFunction(const char *,long) {
  errorc(__LINE__);
  return *(Alias<ISink> *) 0;
};

ISink * TeXSink::clone() const {
  errorc(__LINE__);
  return (ISink *) 0;
};

void TeXSink::put(const Field& x) {
  d_os << "\\mbox{$";
#ifdef USE_VIRT_FIELD
  if(s_showPlusWithNumbers) {
    d_os << " + ";
  } else {
    d_os << "  ";
  };
  TeXOutputVisitor v(d_os);
  x.print(v);
#else
  int top = x.numerator().internal();
  if(top==0) {
    d_os << " + 0";
  } else if(top>0) {
    if(s_showPlusWithNumbers) {
      d_os << " + $}\n\\mbox{$";
    };
    if(x.denominator().one()) {
      d_os << top;
    } else {
      d_os << "\\frac{" << top << "}{" << x.denominator().internal() << '}';
    };
  } else {
    d_os << " - $}\n\\mbox{$";
    if(x.denominator().one()) {
      d_os << -top;
    } else {
      d_os << "\\frac{" << -top << "}{" << x.denominator().internal() << '}';
    };
  };
#endif
  d_os << "$}\n";
};

void TeXSink::put(const Variable& x) {
  d_os << "\\mbox{$" << x.texstring() << "$}\n";
};

void TeXSink::put(const Monomial& x) {
  const int sz = x.numberOfFactors();
  if(sz==0) {
      d_os << "\\mbox{$1$}\n";
  } else {
    if(s_CollapsePowers) {
      list<pair<Variable,int> > L;
      typedef list<pair<Variable,int> >::const_iterator LI;
      MonomialToPowerList(x,L);
      LI w = L.begin(), e = L.end();
      while(w!=e) {
        d_os << "\\mbox{$ " << "\\ $}\n";
        if((*w).second==1) {
          put((*w).first);
        } else {
          d_os << "\\mbox{${";
          put((*w).first);
          d_os << "}^{" << (*w).second << "}$}\n";
        };
        ++w;
      };
    } else {
      MonomialIterator w = x.begin();
      for(int i=1;i<=sz;++i,++w) {
        d_os << "\\mbox{$\\ $}\n";
        put(*w);
      };
    };
    d_os << ' ';
  };
};

void TeXSink::put(const Term& x) {
  const Field & f  = x.CoefficientPart();
  bool cone = f.one();
  bool mone = x.MonomialPart().numberOfFactors()==0;
  if(!cone) {
    put(f);
    if(!mone) put(x.MonomialPart());
  } else {
    if(s_showPlusWithNumbers) {
      d_os << " + ";
    } else {
      d_os << "  ";
    };
    put(x.MonomialPart());
  };
};

void TeXSink::put(const Polynomial& x) {
  int sz = x.numberOfTerms();
  PolynomialIterator w = x.begin();
  d_os << ' ';
  if(sz==0) {
     d_os << "\\mbox{$ 0 $}\n";
  } else {
     bool save = s_showPlusWithNumbers;
     s_showPlusWithNumbers = false;
     put(*w);
     ++w;
     for(int i=2;i<=sz;++i,++w) {
       d_os << ' ';
       s_showPlusWithNumbers = true;
       put(*w);
     };
     s_showPlusWithNumbers = save;
  };
  d_os << ' ';
};

void TeXSink::put(const RuleID &) {
  errorc(__LINE__);
};

void TeXSink::put(const GroebnerRule& x) {
  put(x.LHS());
  d_os << "\\mbox{$\\rightarrow$}\n";
  put(x.RHS());
  d_os << ' ';
};

void TeXSink::noOutput() {};

bool TeXSink::s_showPlusWithNumbers = true;
bool TeXSink::s_CollapsePowers = true;

void TeXSink::errorh(int n) { DBGH(n); };

void TeXSink::errorc(int n) { DBGC(n); };
