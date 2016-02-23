// GBString.h

#ifndef INCLUDED_GBSTRING_H
#define INCLUDED_GBSTRING_H

/* 

I took the function ncmp and slen from the String.cc file.
Here is the copyright notice from String.cc 

Mark Stankus
mstankus@oba.ucsd.edu
*/

/* 
Copyright (C) 1988 Free Software Foundation
    written by Doug Lea (dl@rocky.oswego.edu)

This file is part of the GNU C++ Library.  This library is free
software; you can redistribute it and/or modify it under the terms of
the GNU Library General Public License as published by the Free
Software Foundation; either version 2 of the License, or (at your
option) any later version.  This library is distributed in the hope
that it will be useful, but WITHOUT ANY WARRANTY; without even the
implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
PURPOSE.  See the GNU Library General Public License for more
details.
You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the Free Software
Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
*/


// This code wraps the String class to make porting easier

#ifndef INCLUDED_STRING_H
#include "STRING.hpp"
#endif

class GBStringconst_iterator {
  void operator =(const GBStringconst_iterator &);
    // not implemented
private: 
  int _n;
  /* volatile */ const MXSString & _string;
public:
  GBStringconst_iterator(const MXSString & aString,int ZeroBasedIndex);
  GBStringconst_iterator(const GBStringconst_iterator & iter);
  ~GBStringconst_iterator(){};
  void operator ++();
  void operator --();
  void advance(int n);
  char operator *() const;
  bool operator ==(const GBStringconst_iterator & iter) const;
  bool operator !=(const GBStringconst_iterator & iter) const;
  friend MyOstream & operator <<(MyOstream & os,
                             const GBStringconst_iterator & iter);
  int place() const;
  const MXSString & string() const;
  static const char * const s_space;
  static const char * const s_newline;
};

class GBString {
public:
  GBString();
  explicit GBString(const MXSString & aString);
  GBString(const GBString & aString);
  explicit GBString(const char * aCharString);
  GBString(const char * aCharString, int n);
  ~GBString(){};
  void operator = (const GBString & aCharString);
  void operator = (const char * aCharString);
  void operator = (char);

  void operator += (const char * const);
  void operator += (const char c);
public:

  bool operator < (const GBString & b) const {
    return MXScompare(_string,b._string)<0;
  };
  bool operator == (const GBString & b) const;
  bool operator != (const GBString & b) const;

  bool operator == (const char * s) const;
  bool operator != (const char * s) const;

  unsigned int length() const;
  
  int empty() const;

  const char * const chars() const;

  char elem(int pos) const;

  void del(int pos,int len);

// This is really inefficient!!! 
  GBString at(int pos,int len) const;
 
  MyOstream & InstanceToOStream(MyOstream & os) const;

  friend MyOstream & operator << (MyOstream & os, const GBString & a);

  typedef GBStringconst_iterator const_iterator;
  const_iterator begin() const;
  bool compareToCharString(const char * aCharString,int len) const;
  bool compareToCharString(
      const GBStringconst_iterator & iter,
      const char * aCharString,int len) const;
  void alloc(int);
private:
  MXSString _string;
// borrowed from GNU string class
  int ncmp(const char* a, int al, const char* b, int bl) const;
// borrowed from GNU string class
  int slen(const char* t) const;
  static const MXSString s_EMPTY;
};

inline
GBStringconst_iterator::GBStringconst_iterator(const MXSString & aString,
      int ZeroBasedIndex) : _n(ZeroBasedIndex), _string(aString) 
{};

inline GBStringconst_iterator::GBStringconst_iterator(
   const GBStringconst_iterator & iter) : _n(iter._n), _string(iter._string) {}

inline void GBStringconst_iterator::operator ++() { ++ _n;}

inline void GBStringconst_iterator::operator --() { -- _n;}

inline void GBStringconst_iterator::advance(int n) {_n += n;};

inline bool GBStringconst_iterator::operator ==(
    const GBStringconst_iterator & iter) const { 
  return _n== iter._n && _string==iter._string;
};

inline bool GBStringconst_iterator::operator !=(
       const GBStringconst_iterator & iter) const { 
  return !(_n== iter._n && _string==iter._string);
};

inline int GBStringconst_iterator::place() const {
  return _n;
};

inline const MXSString & GBStringconst_iterator::string() const { 
  return _string;
};

inline GBString::GBString() : _string(s_EMPTY) { }

inline GBString::GBString(const MXSString & aString) : _string(aString) { }

inline GBString::GBString(const GBString & aString) : 
    _string(aString._string) { }

inline GBString::GBString(const char * aCharString) : 
   _string(MXSString(aCharString)) { }

inline GBString::GBString(const char * aCharString, int n) :
    _string(MXSString(aCharString, n)) { }

inline void GBString::operator += (const char * const s) { 
  _string += s;
};

inline void GBString::operator += (const char c) { 
  _string += c;
};

inline void GBString::operator = (const GBString & aCharString) {
  _string = aCharString._string;
}

inline void GBString::operator = (const char * aCharString) {
  _string = aCharString;
}

inline unsigned int GBString::length() const { 
  return _string.length(); 
};

inline int  GBString::empty() const { 
  return _string.empty();
};

inline const char * const GBString::chars() const { 
  return _string.chars();
};

inline GBString::const_iterator GBString::begin() const { 
  return const_iterator(_string,0);
};

inline bool GBString::compareToCharString(const char * aCharString,int len) const { 
  return ncmp(_string.chars(),len,
              aCharString,slen(aCharString))==0;
};

inline bool GBString::compareToCharString( const GBStringconst_iterator & iter,
      const char * aCharString,int len) const { 
  return ncmp(_string.chars()+iter.place(),
              len,aCharString,slen(aCharString))==0;
};

inline void GBString::alloc(int n) { _string.MXSalloc(n);};

inline char GBStringconst_iterator::operator *() const { 
  return _string.elem(_n);
};
#endif
