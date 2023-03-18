// subMonomial.h

#ifndef INCLUDED_SUBMONOMIAL_H
#define INCLUDED_SUBMONOMIAL_H

#include "load_flags.hpp"
#ifdef PDLOAD
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#ifndef INCLUDED_MONOMIAL_H
#include "Monomial.hpp"
#endif
#include "GBList.hpp"
#include "ncgbadvance.hpp"

class subMonomial {
  subMonomial(const subMonomial &);
    // not implemented
  void operator=(const subMonomial &);
    // not implemented
  static MonomialIterator s_first_helper;
  static MonomialIterator s_second_helper;
  static void errorh(int);
  static void errorc(int);
public:
  subMonomial(const Monomial &,int st,int len);
  ~subMonomial() {};

  bool operator == (const subMonomial & aMonomial) const;
  bool operator != (const subMonomial & aMonomial) const;

  int start() const;
  int length() const;
  void incrementStart();
  void decrementStart();
  inline void start(int newstart);
  inline void length(int newlength);
  int firstDifferSubMonomial(const subMonomial & aMonomial) const;
  int findVariableForward(int len,const Variable & v);
  int findVariableBackward(int len,const Variable & v);
private:
  subMonomial(); // Don't implement!!
  const Monomial & _mono;
  int _start;
  int _length;
  MonomialIterator start_iterator;

  static const char * startSetTo;
  static const char period;
  static const char space;
  static const char newline;
  static const char * andThere;
  static const char * children;
  static const char * lengthSetTo;
  static const char * Induced;
  static const char * subMonomialString;
  void error1(int) const;
  void error2(int) const;
  void error3(int) const;
  void error4(int) const;
  void error5() const;
  void error6(int) const;
};

inline
subMonomial::subMonomial(const Monomial & theMonomial,int st,int len) :
    _mono(theMonomial), _start(1), _length(0),
    start_iterator(theMonomial.begin()) {
   start(st);
   length(len);
};

inline int subMonomial::start() const { return _start; };

inline int subMonomial::length() const { return _length; };

inline void subMonomial::start(int newstart) {
#ifdef CAREFUL
   if(newstart<=0) {
     error1(newstart);
   } else if (newstart + _length - 1 > _mono.numberOfFactors()) {
     error2(newstart);
   } else 
#endif
   {
     if(newstart>_start) {
        int diff = newstart - _start;
        if(diff==0) {
          /* do nothing */
        } else if(diff==1) {
          ++start_iterator;
        } else {
           if(diff<0) errorh(__LINE__);
           for(int jjjj=1;jjjj<=diff;++jjjj,++start_iterator) {};
#if 0
           ncgbadvance(start_iterator,diff); // just diff, not diff-1
#endif
        }
        _start = newstart;
     } else {
       _start = newstart;
       start_iterator = _mono.begin();
       for(int jjjj=2;jjjj<=newstart;++jjjj,++start_iterator) {};
#if 0
       ncgbadvance(start_iterator,newstart-1);
#endif
     }
  }
};

inline void subMonomial::length(int newlength) {
#ifdef CAREFUL
   if(newlength<0) {
     error3(newlength);
   } else if (_start+newlength-1 > _mono.numberOfFactors()) {
     error4(newlength);
   } else 
#endif
   {
     _length = newlength;
   }
};

inline bool subMonomial::operator == (const subMonomial & aSubMonomial) const {
   return _length == aSubMonomial._length &&
          firstDifferSubMonomial(aSubMonomial)==-1;
};

inline bool subMonomial::operator != (const subMonomial & aSubMonomial) const {
   return !(_length == aSubMonomial._length &&
          firstDifferSubMonomial(aSubMonomial)==-1);
};

inline void subMonomial::incrementStart() {
#ifdef CAREFUL
  if (_start + _length > _mono.numberOfFactors()) {
    error5();
  }
  else 
#endif
  {
    ++start_iterator;++_start;
  }
};

inline void
subMonomial::decrementStart()
{
#ifdef CAREFUL
  if (_start ==1) {
     error6(newstart);
  } else
#endif
  {
    --start_iterator;--_start;
  }
};
#endif
#endif
