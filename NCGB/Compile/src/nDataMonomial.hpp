// nDataMonomial.h

#ifndef INCLUDED_NMonomialData_H
#define INCLUDED_NMonomialData_H

#include "load_flags.hpp"
#include "Debug1.hpp"
#ifdef PDLOAD

//#define DEBUGDATAMONOMIAL

#ifndef INCLUDED_AUXILARYDATA_H
#include "AuxilaryData.hpp"
#endif
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
class MLex;
class Monomial;
#include "vcpp.hpp"

class nDataMonomial : public AuxilaryData {
  nDataMonomial();
public:
  nDataMonomial(const MLex * const, const Monomial & m); 
  nDataMonomial(const nDataMonomial & d); 
  virtual ~nDataMonomial();
  void operator =(const nDataMonomial& d);

  void tellMonomial(const Monomial & m) const;
  void setOrder(const MLex * mlex);
  virtual void assign(const AuxilaryData &d) ;
  virtual bool equal(const AuxilaryData &d) const;
  bool operator ==(const nDataMonomial & d) const;
  bool operator !=(const nDataMonomial & d) const;
  void updateMonomial(const Monomial & m);
  void clearData();
  virtual void vClearData(int);
  const int length() const { return _length;};
  const vector<int> & counts() const { return _counts;};
  MLex const * theOrder() const { return _mlex;};
#ifdef DEBUGDATAMONOMIAL
  static int s_numberOfDataMonomials;
#endif
private:
  int _length;
  vector<int> _counts; 
  MLex const * _mlex;
};

inline void nDataMonomial::setOrder(MLex const * mlex) { 
  _mlex = mlex;
  clearData();
};

inline nDataMonomial::nDataMonomial(const nDataMonomial & d) :
   _length(d._length), _counts(d._counts), _mlex(d._mlex) {
#ifdef DEBUGDATAMONOMIAL
  ++s_numberOfDataMonomials;
  GBStream << "Copy constructing an nDataMonomial with address " 
           << &d << " to " << this << " " 
           << s_numberOfDataMonomials << '\n';
#endif
};

inline void nDataMonomial::operator =(const nDataMonomial& d) {
  _length = d._length;
  _counts = d._counts;
  _mlex = d._mlex;
#ifdef DEBUGDATAMONOMIAL
  GBStream << "Assigning an nDataMonomial with address " 
           << &d << " to " << this << '\n';
#endif
}

inline bool nDataMonomial::operator ==(const nDataMonomial & d) const {
  return _length==d._length && 
         _counts == d._counts &&
         _mlex == d._mlex;
};

inline bool nDataMonomial::operator !=(const nDataMonomial & d) const {
  return !(_length==d._length && 
         _counts == d._counts &&
         _mlex == d._mlex);
};
#endif
#endif
