// LINTEGER.h

#ifndef INCLUDED_LINTEGER_H
#define INCLUDED_LINTEGER_H

class MyOstream;

#define INTEGER_USES_LONGLONG
#include "Choice.hpp"

class LINTEGER {
public:
#ifdef USE_UNIX
  typedef long long InternalType;
#else
  typedef long InternalType;
#endif

  // Constructors
  inline LINTEGER(){};
  explicit inline LINTEGER(int);
  explicit inline LINTEGER(long);
#ifdef USE_UNIX
  explicit inline LINTEGER(long long);
#endif
  inline LINTEGER(const LINTEGER &);
  ~LINTEGER(){};
  void operator = (const LINTEGER &);

  bool needsParenthesis() const;

  friend MyOstream & operator << (MyOstream & os,const LINTEGER &);

  void setToOne();
  void setToZero();

  bool operator ==(const LINTEGER & s);
  bool operator !=(const LINTEGER & s);

  // Overloaded operators
  void operator += (const LINTEGER &);
  void operator -= (const LINTEGER &);
  void operator *= (const LINTEGER &);
  void operator /= (const LINTEGER &);

  void operator = (const InternalType &);

  LINTEGER operator - () const;
  LINTEGER operator + (const LINTEGER &) const;
  LINTEGER operator - (const LINTEGER &) const;
  LINTEGER operator * (const LINTEGER &) const;
  LINTEGER operator / (const LINTEGER &) const;

  bool zero() const;
  bool one() const;
  bool minusone() const;
  
  int sgn() const;

  LINTEGER compareNumbers(const LINTEGER &) const;
  bool operator == (const LINTEGER &) const;

  int asInt() const { return (int) _Integer;};

  const InternalType & internal() const;
  static void gcds(int yn);
  static int gcds();
private:
  static bool s_gcds;
  InternalType _Integer;
};

inline bool LINTEGER::needsParenthesis() const { 
  return false;
};

inline void LINTEGER::setToOne() { 
  _Integer = 1;
};

inline void LINTEGER::setToZero() { 
  _Integer = 0;
};

inline bool LINTEGER::operator ==(const LINTEGER & s)
{ return _Integer==s._Integer;};

inline bool LINTEGER::operator !=(const LINTEGER & s) { 
  return _Integer!=s._Integer;
};

#ifndef USEGnuGCode
inline  LINTEGER LINTEGER::operator - () const { 
  return LINTEGER(-_Integer); 
};
#endif

inline LINTEGER LINTEGER::compareNumbers(const LINTEGER & Right) const {
  return LINTEGER(_Integer - Right._Integer);
};

inline bool LINTEGER::operator == (const LINTEGER & aLINTEGER) const { 
  return compareNumbers(aLINTEGER)._Integer==0;
};

inline const LINTEGER::InternalType & 
LINTEGER::internal() const { return _Integer;};

inline LINTEGER::LINTEGER(int n) : _Integer((InternalType)n) { };

inline LINTEGER::LINTEGER(long n) : _Integer((InternalType)n) { };

#ifdef USE_UNIX
inline LINTEGER::LINTEGER(long long n) : _Integer((InternalType)n) { };
#endif

inline LINTEGER::LINTEGER(const LINTEGER & aLINTEGER) : _Integer(aLINTEGER._Integer)
{ };

inline void LINTEGER::operator = (const LINTEGER & aLINTEGER) {
  _Integer = aLINTEGER._Integer;
};

inline void LINTEGER::operator = (const LINTEGER::InternalType & aInteger) {
  _Integer = aInteger;
};

inline void LINTEGER::operator += (const LINTEGER & aLINTEGER) {
  _Integer += aLINTEGER._Integer;
};

inline void LINTEGER::operator -= (const LINTEGER & aLINTEGER) {
  _Integer -= aLINTEGER._Integer;
};

inline void LINTEGER::operator *= (const LINTEGER & aLINTEGER) {
  _Integer *= aLINTEGER._Integer;
};

#ifndef USEGnuGCode
inline LINTEGER LINTEGER::operator + (const LINTEGER & aLINTEGER) const {
   return(LINTEGER(_Integer + aLINTEGER._Integer));
};

inline LINTEGER LINTEGER::operator - (const LINTEGER & aLINTEGER) const {
   return(LINTEGER(_Integer - aLINTEGER._Integer));
};

inline LINTEGER LINTEGER::operator * (const LINTEGER & aLINTEGER) const {
   return(LINTEGER(_Integer * aLINTEGER._Integer));
};
#else
inline LINTEGER LINTEGER::operator + (const LINTEGER & aLINTEGER) const
      return result; {
   result = _Integer + aLINTEGER._Integer;
};
 
inline LINTEGER LINTEGER::operator - (const LINTEGER & aLINTEGER) const
      return result; {               
   result = _Integer - aLINTEGER._Integer;
};
 
inline LINTEGER LINTEGER::operator * (const LINTEGER & aLINTEGER) const
      return result; {
   result = _Integer * aLINTEGER._Integer;
};
#endif

inline bool LINTEGER::zero() const {
   return _Integer==0;
};

inline bool LINTEGER::one() const {
   return _Integer==1;
};

inline bool LINTEGER::minusone() const {
   return _Integer==-1;
};

inline int LINTEGER::sgn() const {
  int result = 0;
  if(_Integer>0) {
    result = 1;
  } else if(_Integer!=0) {
    result = -1;
  }
  return result;
};

#ifdef USEGnuGCode
inline LINTEGER 
LINTEGER::operator - () const 
    return result;
{ 
  result = -_Integer; 
};
#endif

inline void LINTEGER::operator/=(const LINTEGER & x) {
  _Integer = internal()/x.internal();
};

inline void LINTEGER::gcds(int yn) {
  s_gcds = yn!=0;
};

inline int LINTEGER::gcds() {
  return s_gcds;
};
#endif 
