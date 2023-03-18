// most stuff deleted so it will be smaller
// Mark Stankus (mstankus@oba.ucsd.edu
//
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

/* 
  String class implementation
 */

#include "MyOstream.hpp"
#include "GBStream.hpp"

#ifdef __GNUG__
#pragma implementation
#endif
#include "STRING.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#ifndef INCLUDED_LIMITS_H
#define INCLUDED_LIMITS_H
#include <limits.h>
#endif

#include "Choice.hpp"
#ifndef OLD_GCC
MXSString::operator const char*() const { 
  return (const char*)chars();
}
#endif

//  globals

MXSStrRep  _MXSnilStrRep = { 0, 1, { 0 } }; // nil strings point here
MXSString _MXSnilString;               // nil SubStrings point here




/*
 the following inline fcts are specially designed to work
 in support of String classes, and are not meant as generic replacements
 for libc "str" functions.

 inline copy fcts -  I like left-to-right from->to arguments.
 all versions assume that `to' argument is non-null

 These are worth doing inline, rather than through calls because,
 via procedural integration, adjacent copy calls can be smushed
 together by the optimizer.
*/

// copy n bytes
inline static void ncopy(const char* from, char* to, int n)
{
  if (from != to) while (--n >= 0) *to++ = *from++;
}

// copy n bytes, null-terminate
inline static void ncopy0(const char* from, char* to, int n)
{
  if (from != to) 
  {
    while (--n >= 0) *to++ = *from++;
    *to = 0;
  }
  else
    to[n] = 0;
}

// copy until null
inline static void scopy(const char* from, char* to)
{
  if (from != 0) while((*to++ = *from++) != 0);
}

// copy right-to-left
inline static void revcopy(const char* from, char* to, short n)
{
  if (from != 0) while (--n >= 0) *to-- = *from--;
}


inline static int slen(const char* t) // inline  strlen
{
  if (t == 0)
    return 0;
  else
  {
    const char* a = t;
    while (*a++ != 0);
    return a - 1 - t;
  }
}

// minimum & maximum representable rep size

#define MAXStrRep_SIZE   ((1 << (sizeof(short) * CHAR_BIT - 1)) - 1)
#define MINStrRep_SIZE   16

#ifndef MALLOC_MIN_OVERHEAD
#define MALLOC_MIN_OVERHEAD  4
#endif

// The basic allocation primitive:
// Always round request to something close to a power of two.
// This ensures a bit of padding, which often means that
// concatenations don't have to realloc. Plus it tends to
// be faster when lots of Strings are created and discarded,
// since just about any version of malloc (op new()) will
// be faster when it can reuse identically-sized chunks

inline static MXSStrRep* Snew(int newsiz)
{
  unsigned int siz = sizeof(MXSStrRep) + newsiz + MALLOC_MIN_OVERHEAD;
  unsigned int allocsiz = MINStrRep_SIZE;
  while (allocsiz < siz) allocsiz <<= 1;
  allocsiz -= MALLOC_MIN_OVERHEAD;
  if (allocsiz >= MAXStrRep_SIZE)
  {
    GBStream << "String:Requested length out of range\n";
    GBStream << "The requested allocation was " << allocsiz << '\n';
    GBStream << "The maximum possible allocation is " 
             << (int) MAXStrRep_SIZE << '\n';
    DBG();
  }
    
  RECORDHERE(MXSStrRep* rep = (MXSStrRep *) new char[allocsiz];)
  rep->sz = allocsiz - sizeof(MXSStrRep);
  return rep;
}

// Do-something-while-allocating routines.

// We live with two ways to signify empty Sreps: either the
// null pointer (0) or a pointer to the nilStrRep.

// We always signify unknown source lengths (usually when fed a char*)
// via len == -1, in which case it is computed.

// allocate, copying src if nonull

MXSStrRep* MXSSalloc(MXSStrRep* old, const char* src, int srclen, int newlen)
{
  if (old == &_MXSnilStrRep) old = 0;
  if (srclen < 0) srclen = slen(src);
  if (newlen < srclen) newlen = srclen;
  MXSStrRep* rep;
  if (old == 0 || newlen > old->sz)
    rep = Snew(newlen);
  else
    rep = old;

  rep->len = newlen;
  ncopy0(src, rep->s, srclen);

  if (old != rep && old != 0) {
    RECORDHERE(delete old;)
  };

  return rep;
}

// reallocate: Given the initial allocation scheme, it will
// generally be faster in the long run to get new space & copy
// than to call realloc

static MXSStrRep*
Sresize(MXSStrRep* old, int newlen)
{
  if (old == &_MXSnilStrRep) old = 0;
  MXSStrRep* rep;
  if (old == 0)
    rep = Snew(newlen);
  else if (newlen > old->sz)
  {
    rep = Snew(newlen);
    ncopy0(old->s, rep->s, old->len);
    RECORDHERE(delete old;)
  }
  else
    rep = old;

  rep->len = newlen;

  return rep;
}

void
MXSString::MXSalloc (int newsize)
{
  unsigned short old_len = rep->len;
  rep = Sresize(rep, newsize);
  rep->len = old_len;
}

// like allocate, but we know that src is a StrRep

MXSStrRep* MXSScopy(MXSStrRep* old, const MXSStrRep* s)
{
  if (old == &_MXSnilStrRep) old = 0;
  if (s == &_MXSnilStrRep) s = 0;
  if (old == s) 
    return (old == 0)? &_MXSnilStrRep : old;
  else if (s == 0)
  {
    old->s[0] = 0;
    old->len = 0;
    return old;
  }
  else 
  {
    MXSStrRep* rep;
    int newlen = s->len;
    if (old == 0 || newlen > old->sz)
    {
      if (old != 0) {RECORDHERE(delete old;)};
      rep = Snew(newlen);
    }
    else
      rep = old;
    rep->len = newlen;
    ncopy0(s->s, rep->s, newlen);
    return rep;
  }
}

// allocate & concatenate

MXSStrRep* MXSScat(MXSStrRep* old, const char* s, int srclen, const char* t, int tlen)
{
  if (old == &_MXSnilStrRep) old = 0;
  if (srclen < 0) srclen = slen(s);
  if (tlen < 0) tlen = slen(t);
  int newlen = srclen + tlen;
  MXSStrRep* rep;

  if (old == 0 || newlen > old->sz || 
      (t >= old->s && t < &(old->s[old->len]))) // beware of aliasing
    rep = Snew(newlen);
  else
    rep = old;

  rep->len = newlen;

  ncopy(s, rep->s, srclen);
  ncopy0(t, &(rep->s[srclen]), tlen);

  if (old != rep && old != 0) { RECORDHERE(delete old;)}

  return rep;
}

// double-concatenate

MXSStrRep* MXSScat(MXSStrRep* old, const char* s, int srclen, const char* t, int tlen,
             const char* u, int ulen)
{
  if (old == &_MXSnilStrRep) old = 0;
  if (srclen < 0) srclen = slen(s);
  if (tlen < 0) tlen = slen(t);
  if (ulen < 0) ulen = slen(u);
  int newlen = srclen + tlen + ulen;
  MXSStrRep* rep;
  if (old == 0 || newlen > old->sz || 
      (t >= old->s && t < &(old->s[old->len])) ||
      (u >= old->s && u < &(old->s[old->len])))
    rep = Snew(newlen);
  else
    rep = old;

  rep->len = newlen;

  ncopy(s, rep->s, srclen);
  ncopy(t, &(rep->s[srclen]), tlen);
  ncopy0(u, &(rep->s[srclen+tlen]), ulen);

  if (old != rep && old != 0) { RECORDHERE(delete old;)}

  return rep;
}

// string compare: first argument is known to be non-null

inline static int scmp(const char* a, const char* b)
{
  if (b == 0)
    return *a != 0;
  else
  {
    signed char diff = 0;
    while ((diff = *a - *b++) == 0 && *a++ != 0);
    return diff;
  }
}


inline static int ncmp(const char* a, int al, const char* b, int bl)
{
  int n = (al <= bl)? al : bl;
  signed char diff;
  while (n-- > 0) if ((diff = *a++ - *b++) != 0) return diff;
  return al - bl;
}

int MXSfcompare(const MXSString& x, const MXSString& y)
{
  const char* a = x.chars();
  const char* b = y.chars();
  int al = x.length();
  int bl = y.length();
  int n = (al <= bl)? al : bl;
  signed char diff = 0;
  while (n-- > 0)
  {
    char ac = *a++;
    char bc = *b++;
    if ((diff = ac - bc) != 0)
    {
      if (ac >= 'a' && ac <= 'z')
        ac = ac - 'a' + 'A';
      if (bc >= 'a' && bc <= 'z')
        bc = bc - 'a' + 'A';
      if ((diff = ac - bc) != 0)
        return diff;
    }
  }
  return al - bl;
}

// these are not inline, but pull in the above inlines, so are 
// pretty fast

int MXScompare(const MXSString& x, const char* b)
{
  return scmp(x.chars(), b);
}

int MXScompare(const MXSString& x, const MXSString& y)
{
  return scmp(x.chars(), y.chars());
}

int MXScompare(const MXSString& x, const MXSSubString& y)
{
  return ncmp(x.chars(), x.length(), y.chars(), y.length());
}

int MXScompare(const MXSSubString& x, const MXSString& y)
{
  return ncmp(x.chars(), x.length(), y.chars(), y.length());
}

int MXScompare(const MXSSubString& x, const MXSSubString& y)
{
  return ncmp(x.chars(), x.length(), y.chars(), y.length());
}

int MXScompare(const MXSSubString& x, const char* b)
{
  if (b == 0)
    return x.length();
  else
  {
    const char* a = x.chars();
    int n = x.length();
    signed char diff;
    while (n-- > 0) if ((diff = *a++ - *b++) != 0) return diff;
    return (*b == 0) ? 0 : -1;
  }
}

/*
 index fcts
*/

#if 0
void MXSSubString::assign(const MXSStrRep* ysrc, const char* ys, int ylen)
{
  if (&S == &_MXSnilString) return;

  if (ylen < 0) ylen = slen(ys);
  MXSStrRep* targ = S.rep;
  int sl = targ->len - len + ylen;

  if (ysrc == targ || sl >= targ->sz)
  {
    MXSStrRep* oldtarg = targ;
    targ = Sresize(0, sl);
    ncopy(oldtarg->s, targ->s, pos);
    ncopy(ys, &(targ->s[pos]), ylen);
    scopy(&(oldtarg->s[pos + len]), &(targ->s[pos + ylen]));
    RECORDHERE(delete oldtarg;)
  }
  else if (len == ylen)
    ncopy(ys, &(targ->s[pos]), len);
  else if (ylen < len)
  {
    ncopy(ys, &(targ->s[pos]), ylen);
    scopy(&(targ->s[pos + len]), &(targ->s[pos + ylen]));
  }
  else
  {
    revcopy(&(targ->s[targ->len]), &(targ->s[sl]), targ->len-pos-len +1);
    ncopy(ys, &(targ->s[pos]), ylen);
  }
  targ->len = sl;
  S.rep = targ;
}
#endif

/*
 * deletion
 */

void MXSString::MXSdel(int pos, int len)
{
  if (pos < 0 || len <= 0 || (pos + len) > length()) return;
  int nlen = length() - len;
  int first = pos + len;
  ncopy0(&(rep->s[first]), &(rep->s[pos]), length() - first);
  rep->len = nlen;
}


/*
 * substring extraction
 */


MXSSubString MXSString::at(int first, int len) const
{
  if (first < 0 || first + len > length() )
    return MXSSubString(_MXSnilString, 0, 0) ;
  else 
    return MXSSubString(*this, first, len);
}

void MXSString::error1(int i) const {
  GBStream << "The integer index is " << i << '\n';
  GBStream << "The length of the string is " << length() << "\n";
  DBG();
};

MyOstream& operator<<(MyOstream& s, const MXSString& x)
{
   s << x.chars(); return s;
}


#ifdef OLD_GCC
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
template class vector<bool>;
#endif
