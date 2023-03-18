// INTEGER.h

#ifndef INCLUDED_INTEGER_H
#define INCLUDED_INTEGER_H

class MyOstream;

#define INTEGER_USES_LONG
//#define INTEGER_USES_LONGLONG

class INTEGER {
public:
  typedef long int InternalType;

  // Constructors
  inline INTEGER(){};
  explicit inline INTEGER(int);
  explicit inline INTEGER(long);
  explicit inline INTEGER(long long);
  inline INTEGER(const INTEGER &);
  ~INTEGER(){};
  void operator = (const INTEGER &);
  void operator = (const InternalType &);

  bool needsParenthesis() const;


  void setToOne();
  void setToZero();

  bool operator ==(const INTEGER & s);
  bool operator !=(const INTEGER & s);

  // Overloaded operators
  void operator += (const INTEGER & aINTEGER);
  void operator -= (const INTEGER & aINTEGER);
  void operator *= (const INTEGER & aINTEGER);
  void operator *= (int n);
  void operator /= (const INTEGER & aINTEGER);


  INTEGER operator - () const;
  INTEGER operator + (const INTEGER & aINTEGER) const;
  INTEGER operator - (const INTEGER & aINTEGER) const;
  INTEGER operator * (const INTEGER & aINTEGER) const;
  INTEGER operator / (const INTEGER & aINTEGER) const;

  bool zero() const;
  bool one() const;
  bool minusone() const;
  
  int sgn() const;

  INTEGER compareNumbers(const INTEGER & aINTEGER) const;
  bool operator == (const INTEGER & aINTEGER) const;

  int asInt() const { return (int) _Integer;};

  const InternalType & internal() const;
  static void gcds(int yn);
  static int gcds();
private:
  static bool s_gcds;
  InternalType _Integer;
};

MyOstream & operator << (MyOstream & os,const INTEGER &);

inline bool INTEGER::needsParenthesis() const { 
  return false;
};

inline void INTEGER::setToOne() { 
  _Integer = 1;
};

inline void INTEGER::setToZero() { 
  _Integer = 0;
};

inline bool INTEGER::operator ==(const INTEGER & s)
{ return _Integer==s._Integer;};

inline bool INTEGER::operator !=(const INTEGER & s) { 
  return _Integer!=s._Integer;
};

#ifndef USEGnuGCode
inline  INTEGER INTEGER::operator - () const { 
  return INTEGER(-_Integer); 
};
#endif

inline INTEGER INTEGER::compareNumbers(const INTEGER & Right) const {
  return INTEGER(_Integer - Right._Integer);
};

inline bool INTEGER::operator == (const INTEGER & aINTEGER) const { 
  return compareNumbers(aINTEGER)._Integer==0;
};

inline const INTEGER::InternalType & 
INTEGER::internal() const { return _Integer;};

inline INTEGER::INTEGER(int n) : _Integer((InternalType)n) { };

inline INTEGER::INTEGER(long n) : _Integer((InternalType)n) { };

inline INTEGER::INTEGER(long long n) : _Integer((InternalType)n) { };

inline INTEGER::INTEGER(const INTEGER & aINTEGER) : _Integer(aINTEGER._Integer)
{ };

inline void INTEGER::operator = (const INTEGER & aINTEGER) {
  _Integer = aINTEGER._Integer;
};

inline void INTEGER::operator = (const INTEGER::InternalType & x) {
  _Integer = x;
};

inline void INTEGER::operator += (const INTEGER & aINTEGER) {
  _Integer += aINTEGER._Integer;
};

inline void INTEGER::operator -= (const INTEGER & aINTEGER) {
  _Integer -= aINTEGER._Integer;
};

inline void INTEGER::operator *= (const INTEGER & aINTEGER) {
  _Integer *= aINTEGER._Integer;
};

inline void INTEGER::operator *= (int n) {
  _Integer *= n;
};

#ifndef USEGnuGCode
inline INTEGER INTEGER::operator + (const INTEGER & aINTEGER) const {
   return(INTEGER(_Integer + aINTEGER._Integer));
};

inline INTEGER INTEGER::operator - (const INTEGER & aINTEGER) const {
   return(INTEGER(_Integer - aINTEGER._Integer));
};

inline INTEGER INTEGER::operator * (const INTEGER & aINTEGER) const {
   return(INTEGER(_Integer * aINTEGER._Integer));
};
#else
inline INTEGER INTEGER::operator + (const INTEGER & aINTEGER) const
      return result; {
   result = _Integer + aINTEGER._Integer;
};
 
inline INTEGER INTEGER::operator - (const INTEGER & aINTEGER) const
      return result; {               
   result = _Integer - aINTEGER._Integer;
};
 
inline INTEGER INTEGER::operator * (const INTEGER & aINTEGER) const
      return result; {
   result = _Integer * aINTEGER._Integer;
};
#endif

inline bool INTEGER::zero() const {
   return _Integer==0;
};

inline bool INTEGER::one() const {
   return _Integer==1;
};

inline bool INTEGER::minusone() const {
   return _Integer==-1;
};

inline int INTEGER::sgn() const {
  int result = 0;
  if(_Integer>0) {
    result = 1;
  } else if(_Integer!=0) {
    result = -1;
  }
  return result;
};

#ifdef USEGnuGCode
inline INTEGER 
INTEGER::operator - () const 
    return result;
{ 
  result = -_Integer; 
};
#endif

inline void INTEGER::operator/=(const INTEGER & x) {
  _Integer = internal()/x.internal();
};

inline void INTEGER::gcds(int yn) {
  s_gcds = yn==0 ? false : true;
};

inline int INTEGER::gcds() {
  return s_gcds;
};
#endif /*  INTEGER_h  */
