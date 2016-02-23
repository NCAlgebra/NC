// backspacer.c

#include "backspacer.hpp"
#include "load_flags.hpp"
#ifdef PDLOAD
#include "MyOstream.hpp"
#include "Choice.hpp"
#ifndef INCLUDED_CSTRING_H
#define INCLUDED_CSTRING_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif
#endif

int floorlog10(int n);
int mypower(int n);

void backspacer::updateBspace() {
  if(_n==0) {
    _nbackspace = 1;
    if(_direction>0) {
      _nextupdate = 10;
    } else {
      _nextupdate = -1;
    }
  } else {
    // number of backspaces for the digits
//       _nbackspace = (int) log10(fabs(_n))+1;
    _nbackspace = floorlog10(_n>0?_n:-_n)+1;
    if(_n < 0) { 
      if(_direction<0) {
//           _nextupdate = -1*( (int)pow(10.0,_nbackspace));
         _nextupdate = -1* mypower(_nbackspace);
      } else if(_n>-10) {
        _nextupdate = -1; 
      } else {
//           _nextupdate = -1*((int) pow(10.0,_nbackspace-1))+1;
         _nextupdate = -1* mypower(_nbackspace-1) + 1;
      }
      ++_nbackspace;  // extra backspace for the minus sign
    } else {
//         _nextupdate = (int) pow(10.0,_nbackspace);
      _nextupdate = mypower(_nbackspace);
    }
  }
};

void backspacer::show() {
  for(int i=1;i<=_obackspace;++i) _os << "\b \b";
  _os << _n;
  cout.flush();
  _obackspace = _nbackspace;
  _n += _direction; 
  if(_direction>0) {
     if(_n >= _nextupdate) {
        updateBspace();
     }
  } else if(_direction < 0) {
    if(_n <= _nextupdate) {
      updateBspace();
    }
  }
};

void backspacer::clear() {
  for(int i=1;i<=_obackspace;++i) _os << "\b \b";
};

void backspacer::status(MyOstream & OS) {
  OS << "_n:" << _n;
  OS << "\n_direction:" << _direction;
  OS << "\n_nextupdate:" << _nextupdate;
  OS << "\n_nbackspace:" << _nbackspace;
  OS << "\n_obackspace:" << _obackspace;
};

int floorlog10(int n) {
  int m = n;
  int ans = 0;
  while(m>9) {
    m = m /10;
    ++ans;
  };
  return ans;
};

int mypower(int n) {
  int result = 1;
  for(int i=1;i<=n;++i) result *= 10;
  return result;
};

backspacer::backspacer(MyOstream & os,const char * const  s) : _os(os) {
  _os << s;
  _nbackspace = strlen(s);
};
#endif
