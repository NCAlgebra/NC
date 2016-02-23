// GBString.c
//

#include "GBString.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "MyOstream.hpp"

/*
I took the function ncmp and slen from the String.cc file.
Here is the copyright notice from String.cc 

Mark Stankus
mstankus@oba.ucsd.edu
*/

/* 
Copyright (C) 1988 Free Software Foundation
    written by Doug Lea (dl@rocky.oswego.edu)

This file is part of the GNU C++ Library.  This library is
free
software; you can redistribute it and/or modify it under the
terms of
the GNU Library General Public License as published by the
Free
Software Foundation; either version 2 of the License, or (at
your
option) any later version.  This library is distributed in the
hope
that it will be useful, but WITHOUT ANY WARRANTY; without even
the
implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR
PURPOSE.  See the GNU Library General Public License for more
details.
You should have received a copy of the GNU Library General
Public
License along with this library; if not, write to the Free
Software
Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
*/

#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif

int GBString::ncmp(const char* a, int al, const char* b, int bl) const {
  int n = (al <= bl)? al : bl;
  signed char diff;
  while (n-- > 0) if ((diff = *a++ - *b++) != 0) return diff;
  return al - bl;
};

// borrowed from GNU string class
int GBString::slen(const char* t) const {
  if (t == 0)
    return 0;
  else {
    const char* a = t;
    while (*a++ != 0);
    return a - 1 - t;
  }
};

bool GBString::operator == (const GBString & b) const {
  return strcmp(_string.chars(), b._string.chars())==0;
};
 
bool GBString::operator != (const GBString & b) const {
  return strcmp(_string.chars(), b._string.chars())!=0;
};

bool GBString::operator == (const char * s) const {
  return strcmp(_string.chars(), s)==0;
};

bool GBString::operator != (const char * s) const {
  return strcmp(_string.chars(), s)!=0;
};

const MXSString GBString::s_EMPTY = MXSString("");

MyOstream & operator <<(MyOstream & os, const GBStringconst_iterator & iter) { 
  os << iter.place() << ' ' << iter.string() << '\n'; 
  return os; 
}

MyOstream & operator << (MyOstream & os, const GBString & a) {
  os << a.chars();
  return os;
};

MyOstream & GBString::InstanceToOStream(MyOstream & os) const {
  os << chars();
  return os;
};

char GBString::elem(int pos) const {
  if(pos<0) DBG();
  return _string.elem(pos);
};

void GBString::del(int pos,int len) {
  if(pos<0) DBG();
  if(len<0) DBG();
  _string.MXSdel(pos,len);
};

GBString GBString::at(int pos,int len) const {
  if(pos<0) DBG();
  if(len<0) DBG();
  MXSString temp(_string.at(pos,len));
  return GBString(temp);
};

