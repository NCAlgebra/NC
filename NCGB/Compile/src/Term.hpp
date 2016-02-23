// Term.h

#ifndef INCLUDED_TERM_H
#define INCLUDED_TERM_H

#ifndef INCLUDED_MONOMIAL_H
#include "Monomial.hpp"
#endif
#ifndef INCLUDED_FIELD_H
#include "Field.hpp"
#endif
#include "AltInteger.hpp"
#include "Copy.hpp"

class Term {
public:
  typedef Field COEFFICIENT;
  typedef Monomial MONOMIAL;

  Term();
  ~Term(){};
  explicit inline Term(const COEFFICIENT & aCOEFFICIENT);
  explicit inline Term(const MONOMIAL & aMONOMIAL);
  explicit inline Term(const COEFFICIENT & aCOEFFICIENT, const MONOMIAL & aMONOMIAL);
  inline Term(const Term & aTerm);

  inline void assign(const COEFFICIENT & x);
  inline void assign(const MONOMIAL & aMONOMIAL);
  inline void assign(const COEFFICIENT & aCOEFFICIENT, const MONOMIAL & aMONOMIAL);
  inline void assign(const Term & aTerm);

  const Term & operator = (const Term & RightSide);
  inline bool operator !=(const Term & aTerm) const;
  inline bool operator ==(const Term & aTerm) const;

  void setToOne();
  bool one() const;
  COEFFICIENT & Coefficient() { return d_number;};
  inline const COEFFICIENT & CoefficientPart() const;
  inline void CoefficientPart(const COEFFICIENT & aCOEFFICIENT);
  inline MONOMIAL & MonomialPart() { return d_monomial.access();};
  inline const MONOMIAL & MonomialPart() const;
  inline const Copy<MONOMIAL> & CopyMonomial() { return d_monomial;};
  inline void MonomialPart(const MONOMIAL & aMONOMIAL);

  // basic math   
  Term operator - () const;
  Term operator * (const Term & anotherTerm) const;
  Term operator * (const Monomial &) const;
  Term operator * (const Field &) const;
  void  operator /= (const COEFFICIENT & aCOEFFICIENT);
  void  operator *= (const Term & bTerm);
  void  premultiply(const Term &);
  void  postmultiply(const Term & x) { operator*=(x);};
  void  operator *= (const Monomial &);
  void  premultiply(const Monomial &);
  void  postmultiply(const Monomial & x) { operator*=(x);}
  void  operator *= (const Field&);
  static const Term s_TERM_ONE;
  static const INTEGER s_ONE;
  static const Monomial s_MONOMIAL_ONE;
private:
  Copy<MONOMIAL> d_monomial;
  COEFFICIENT d_number;
};

inline bool Term::one() const {
  return d_monomial().one() && d_number.one();
};

MyOstream & operator <<(MyOstream & os,const Term & aTerm);
   
inline void Term::setToOne() {
  d_number = 1;
  d_monomial.access().setToOne();
};

inline const Term & Term::operator = (const Term & RightSide) {
  d_monomial = RightSide.d_monomial;
  d_number = RightSide.d_number;
  return * this;
};

inline const Term::COEFFICIENT & Term::CoefficientPart() const {
   return d_number; 
};

inline const Term::MONOMIAL & Term::MonomialPart() const {
   return d_monomial();
};

inline void Term::MonomialPart(const MONOMIAL & x) {
   d_monomial = x;
};

inline void Term::CoefficientPart(const COEFFICIENT & x) {
  d_number = x;
};

#ifndef  USEGnuGCode
inline Term Term::operator - () const { 
  return Term(-d_number, d_monomial()); 
}
#else
inline Term Term::operator - () const
   return result; { 
  result.CoefficientPart(-d_number);
  result.MonomialPart(d_monomial);
}
#endif

inline bool Term::operator !=(const Term & x) const { 
  return !(d_monomial==x.d_monomial && d_number==x.d_number);
};

inline bool Term::operator ==(const Term & x) const { 
  return d_monomial==x.d_monomial && d_number==x.d_number;
};

inline Term::Term()  : d_monomial(s_MONOMIAL_ONE), d_number(1) {
};

inline Term::Term(const COEFFICIENT & aCOEFFICIENT) :
    d_monomial(s_MONOMIAL_ONE), d_number(aCOEFFICIENT) {};

inline void Term::assign(const COEFFICIENT & aCOEFFICIENT) {
  d_monomial.access().setToOne();
  d_number = aCOEFFICIENT;
};

inline Term::Term(const MONOMIAL & x)  : d_monomial(x), d_number(1) {};

inline void Term::assign(const MONOMIAL & x)  {
  d_monomial = x;
  d_number.setToOne();
};

inline Term::Term(const COEFFICIENT & aCOEFFICIENT,const MONOMIAL & aMono) :
    d_monomial(aMono), d_number(aCOEFFICIENT) {};

inline void Term::assign(const COEFFICIENT & aCOEFFICIENT,const MONOMIAL & aMono) {
 d_monomial=aMono;
 d_number=aCOEFFICIENT;
};

inline Term::Term(const Term & x)  : d_monomial(x.d_monomial), d_number(x.d_number){};

inline void Term::assign(const Term & x)  {
  d_monomial=x.d_monomial;
  d_number=x.d_number;
};
#endif 
