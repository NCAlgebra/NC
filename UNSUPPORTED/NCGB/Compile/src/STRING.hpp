// This may look like C code, but it is really -*- C++ -*-

// modified by Mark Stankus. Removed a bunch of functionality.
// mstankus@oba.ucsd.edu
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
PURPOSE.  See the GNU Library General Public License for more details.
You should have received a copy of the GNU Library General Public
License along with this library; if not, write to the Free Software
Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
*/


#ifndef INCLUDED_STRING_H

//#pragma warning(disable:4786)
#include "Choice.hpp"
#include "RecordHere.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <iostream>
#else
#include <iostream.h>
#endif
class MyOstream;

using namespace std;

struct MXSStrRep                     // internal String representations
{
  unsigned short    len;         // string length 
  unsigned short    sz;          // allocated space
  char              s[1];        // the string starts here 
                                 // (at least 1 char for trailing null)
                                 // allocated & expanded via non-public fcts
};

// primitive ops on StrReps -- nearly all String fns go through these.

MXSStrRep*     MXSSalloc(MXSStrRep*, const char*, int, int);
MXSStrRep*     MXSScopy(MXSStrRep*, const MXSStrRep*);
MXSStrRep*     MXSScat(MXSStrRep*, const char*, int, const char*, int);
MXSStrRep*     MXSScat(MXSStrRep*, const char*, int,const char*,int, const char*,int);

// These classes need to be defined in the order given

class MXSString;
class MXSSubString;

class MXSSubString
{
  friend class      MXSString;
protected:

  const MXSString&           S;        // The String I'm a substring of
  unsigned short    pos;      // starting position in S's rep
  unsigned short    len;      // length of substring

  // MAURICIO BEGIN
  public:
  inline                    MXSSubString(const MXSString& x, int p, int l);
  inline                    MXSSubString(const MXSSubString& x);
  
  //public:
  // MAURICIO END
  
  // Note there are no public constructors. SubStrings are always
  // created via String operations

                   ~MXSSubString();

  inline MXSSubString&        operator =  (const MXSString&     y);
  inline MXSSubString&        operator =  (const MXSSubString&  y);
  inline MXSSubString&        operator =  (const char* t);
  inline MXSSubString&        operator =  (char        c);

// IO 
  friend MyOstream&   operator<<(MyOstream& s, const MXSSubString& x);

// status
  inline int      length() const;
  inline int               empty() const;
  inline const char*       chars() const;

};

class MXSString
{
  friend class      MXSSubString;

protected:
  MXSStrRep*           rep;   // Strings are pointers to their representations

public:
    void error1(int) const;

// constructors & assignment

inline                    MXSString();
inline                    MXSString(const MXSString& x);
inline                    explicit MXSString(const MXSSubString&  x);
inline                    explicit MXSString(const char* t);
inline                    MXSString(const char* t, int len);
                    explicit MXSString(char c);
inline ~MXSString();

  inline MXSString&           operator =  (const MXSString&     y);
  inline MXSString&           operator =  (const char* y);
  inline MXSString&           operator =  (char        c);
  inline MXSString&           operator =  (const MXSSubString&  y);

// concatenation

  inline MXSString&           operator += (const MXSString&     y); 
  inline MXSString&           operator += (const MXSSubString&  y);
  inline MXSString&           operator += (const char* t);
  inline MXSString&           operator += (char        c);

// procedural versions:
// concatenate first 2 args, store result in last arg

  friend inline void     cat(const MXSString&, const MXSString&, MXSString&);
  friend inline void     cat(const MXSString&, const char*, MXSString&);
  friend inline void     cat(const MXSString&, char, MXSString&);

// Note that you can't take a substring of a const String, since
// this leaves open the possiblility of indirectly modifying the
// String through the SubString

  MXSSubString         at(int         pos, int len) const;

// delete len chars starting at pos
  void              MXSdel(int         pos, int len);

// element extraction

  inline char&             operator [] (int i);
  inline const char&       operator [] (int i) const;
  inline char              elem(int i) const;

// conversion
   inline                 operator const char*() const;
  inline const char*       chars() const;

// IO

  friend MyOstream&   operator<<(MyOstream& s, const MXSString& x);
  friend MyOstream&   operator<<(MyOstream& s, const MXSSubString& x);
  friend istream&   operator>>(istream& s, MXSString& x);

  friend int        readline(istream& s, MXSString& x, 
                             char terminator = '\n',
                             int discard_terminator = 1);

// status

  inline int      length() const;
  inline int               empty() const;

// preallocate some space for MXSString
  void              MXSalloc(int newsize);

// report current allocation (not length!)
  inline int               allocation() const;
};

// other externs

int        MXScompare(const MXSString&    x, const MXSString&     y);
int        MXScompare(const MXSString&    x, const char* y);

extern MXSStrRep  _MXSnilStrRep;
extern MXSString _MXSnilString;

// status reports, needed before defining other things

inline int MXSString::length() const {  int n = rep->len;  return n;}
inline int         MXSString::empty() const { return rep->len == 0; }
inline const char* MXSString::chars() const { return &(rep->s[0]); }
inline int         MXSString::allocation() const { return rep->sz; }

inline int MXSSubString::length() const { int n = len; return n;}
inline int         MXSSubString::empty() const { return len == 0; }
inline const char* MXSSubString::chars() const { return &(S.rep->s[pos]); }


// constructors

inline MXSString::MXSString() 
  : rep(&_MXSnilStrRep) {}
inline MXSString::MXSString(const MXSString& x) 
  : rep(MXSScopy(0, x.rep)) {}
inline MXSString::MXSString(const char* t) 
  : rep(MXSSalloc(0, t, -1, -1)) {}
inline MXSString::MXSString(const char* t, int tlen)
  : rep(MXSSalloc(0, t, tlen, tlen)) {}
inline MXSString::MXSString(const MXSSubString& y)
  : rep(MXSSalloc(0, y.chars(), y.length(), y.length())) {}
inline MXSString::MXSString(char c) 
  : rep(MXSSalloc(0, &c, 1, 1)) {}

inline MXSString::~MXSString() { 
  if (rep != &_MXSnilStrRep) {
    RECORDHERE(delete rep; )
  }
};

inline MXSSubString::MXSSubString(const MXSSubString& x)
  :S(x.S), pos(x.pos), len(x.len) {}
inline MXSSubString::MXSSubString(const MXSString& x, int first, int l)
  :S(x), pos(first), len(l) {}

inline MXSSubString::~MXSSubString() {}

// assignment

inline MXSString& MXSString::operator =  (const MXSString& y)
{ 
  rep = MXSScopy(rep, y.rep);
  return *this;
}

inline MXSString& MXSString::operator=(const char* t)
{
  rep = MXSSalloc(rep, t, -1, -1);
  return *this;
}

inline MXSString& MXSString::operator=(const MXSSubString&  y)
{
  rep = MXSSalloc(rep, y.chars(), y.length(), y.length());
  return *this;
}

inline MXSString& MXSString::operator=(char c)
{
  rep = MXSSalloc(rep, &c, 1, 1);
  return *this;
}

// Zillions of cats...

inline void cat(const MXSString& x, const MXSString& y, MXSString& r)
{
  r.rep = MXSScat(r.rep, x.chars(), x.length(), y.chars(), y.length());
}

inline void cat(const MXSString& x, const char* y, MXSString& r)
{
  r.rep = MXSScat(r.rep, x.chars(), x.length(), y, -1);
}

inline void cat(const MXSString& x, char y, MXSString& r)
{
  r.rep = MXSScat(r.rep, x.chars(), x.length(), &y, 1);
}

// operator versions

inline MXSString& MXSString::operator +=(const MXSString& y)
{
  cat(*this, y, *this);
  return *this;
}

inline MXSString& MXSString::operator += (const char* y)
{
  cat(*this, y, *this);
  return *this;
}

inline MXSString& MXSString:: operator +=(char y)
{
  cat(*this, y, *this);
  return *this;
}

// constructive concatenation

#if defined(__GNUG__) && !defined(_G_NO_NRV)

inline MXSString operator + (const MXSString& x, const MXSString& y)
{
  MXSString r;
  cat(x, y, r);
  return r;
}

inline MXSString operator + (const MXSString& x, const char* y)
{
  MXSString r;
  cat(x, y, r);
  return r;
}

inline MXSString operator + (const MXSString& x, char y)
{
  MXSString r;
  cat(x, y, r);
  return r;
}

#else /* NO_NRV */

inline MXSString operator + (const MXSString& x, const MXSString& y)
{
  MXSString r;  cat(x, y, r);  return r;
}

inline MXSString operator + (const MXSString& x, const char* y) 
{
  MXSString r; cat(x, y, r); return r;
}

inline MXSString operator + (const MXSString& x, char y) 
{
  MXSString r; cat(x, y, r); return r;
}

#endif

// element extraction

inline char&  MXSString::operator [] (int i) 
{ 
  if (i >= length()) 
  {
    error1(i);
  }
  return rep->s[i];
}

inline const char&  MXSString::operator [] (int i) const
{ 
  if (i >= length()) 
  {
    error1(i);
  }
  return rep->s[i];
}

inline char  MXSString::elem (int i) const
{ 
  if (i >= length()) 
  {
    error1(i);
  }
  return rep->s[i];
}

// a zillion comparison operators

inline int operator==(const MXSString& x, const MXSString& y) 
{
  return MXScompare(x, y) == 0; 
}

inline int operator!=(const MXSString& x, const MXSString& y)
{
  return MXScompare(x, y) != 0; 
}

inline int operator==(const MXSString& x, const char* t) 
{
  return MXScompare(x, t) == 0; 
}

inline int operator!=(const MXSString& x, const char* t) 
{
  return MXScompare(x, t) != 0; 
}
#endif
