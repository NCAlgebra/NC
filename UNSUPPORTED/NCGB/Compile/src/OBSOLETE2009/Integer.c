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
Foundation, 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
*/


/*
  Some of the following algorithms are very loosely based on those from 
  MIT C-Scheme bignum.c, which is
      Copyright (c) 1987 Massachusetts Institute of Technology

  with other guidance from Knuth, vol. 2

  Thanks to the creators of the algorithms.
*/

#ifdef __GNUG__
#pragma implementation
#endif
#include <Integer.h>
#include <ctype.h>
#include <limits.h>
#include <Obstack.h>
#include <AllocRing.h>
#ifdef HAS_INCLUDE_NO_DOTS
#include <new>
#else
#include <new.h>
#endif
#include <builtin.h>
#include "Integer.hP"

#undef OK


void myHandleError(const char * x,const char * y) {
  cerr << "The error is " << x << " and then "  << y << '\n';
};

two_arg_error_handler_t lib_error_handler = myHandleError;

IntRep _ZeroRep = {1, 0, 1, {0}};
IntRep _OneRep = {1, 0, 1, {1}};
IntRep _MinusOneRep = {1, 0, 0, {1}};


// utilities to extract and transfer bits 

// get low bits

inline static unsigned short extract(unsigned long x)
{
  return x & (uint32_t)I_MAXNUM;
}

// transfer high bits to low

inline static unsigned long down(unsigned long x)
{
  return (x >> I_SHIFT) & (uint32_t)I_MAXNUM;
}

// transfer low bits to high

inline static unsigned long up(unsigned long x)
{
  return x << I_SHIFT;
}

// compare two equal-length reps

inline static int32_t docmp(const unsigned short* x, const unsigned short* y, size_t l)
{
  int32_t diff = 0;
  const unsigned short* xs = &(x[l]);
  const unsigned short* ys = &(y[l]);
  while (l-- > 0 && (diff = ((int32_t)(*--xs)) - ((int32_t)(*--ys))) == 0);
  return diff;
}

// figure out max length of result of +, -, etc.

inline static int32_t calc_len(int32_t len1, int32_t len2, int32_t pad)
{
  return (len1 >= len2)? len1 + pad : len2 + pad;
}

// ensure len & sgn are correct

inline static void Icheck(IntRep* rep)
{
  size_t l = rep->len;
  const unsigned short* p = &(rep->s[l]);
  while (l > 0 && *--p == 0) --l;
  if ((rep->len = l) == 0) rep->sgn = I_POSITIVE;
}


// zero out the end of a rep

inline static void Iclear_from(IntRep* rep, size_t p)
{
  unsigned short* cp = &(rep->s[p]);
  const unsigned short* cf = &(rep->s[rep->len]);
  while(cp < cf) *cp++ = 0;
}

// copy parts of a rep

static inline void scpy(const unsigned short* src, unsigned short* dest,
			int nb)
{
  while (--nb >= 0) *dest++ = *src++;
}

// make sure an argument is valid

static inline void nonnil(const IntRep* rep)
{
  if (rep == 0) 
    (*lib_error_handler)("Integer", "operation on uninitialized Integer");
}

// allocate a new Irep. Pad to something close to a power of two.

inline static IntRep* Inew(size_t newlen)
{
   size_t siz = sizeof(IntRep) + newlen * sizeof(short) + 
    MALLOC_MIN_OVERHEAD;
   size_t allocsiz = MINIntRep_SIZE;
  while (allocsiz < siz) allocsiz <<= 1;  // find a power of 2
  allocsiz -= MALLOC_MIN_OVERHEAD;
  if (allocsiz >= MAXIntRep_SIZE * sizeof(short))
    (*lib_error_handler)("Integer", "Requested length out of range");
    
  IntRep* rep = new (operator new (allocsiz)) IntRep;
  rep->sz = (allocsiz - sizeof(IntRep) + sizeof(short)) / sizeof(short);
  return rep;
}

// allocate: use the bits in src if non-null, clear the rest

IntRep* Ialloc(IntRep* old, const unsigned short* src, size_t srclen,
	       int newsgn, size_t newlen)
{
  IntRep* rep;
  if (old == 0 || newlen > old->sz)
    rep = Inew(newlen);
  else
    rep = old;

  rep->len = newlen;
  rep->sgn = newsgn;

  scpy(src, rep->s, srclen);
  Iclear_from(rep, srclen);

  if (old != rep && old != 0 && !STATIC_IntRep(old)) delete old;
  return rep;
}

// allocate and clear

IntRep* Icalloc(IntRep* old, size_t newlen)
{
  IntRep* rep;
  if (old == 0 || newlen > old->sz)
  {
    if (old != 0 && !STATIC_IntRep(old)) delete old;
    rep = Inew(newlen);
  }
  else
    rep = old;

  rep->len = newlen;
  rep->sgn = I_POSITIVE;
  Iclear_from(rep, 0);

  return rep;
}

// reallocate

IntRep* Iresize(IntRep* old, size_t newlen)
{
  IntRep* rep;
  unsigned short oldlen;
  if (old == 0)
  {
    oldlen = 0;
    rep = Inew(newlen);
    rep->sgn = I_POSITIVE;
  }
  else 
  {
    oldlen = old->len;
    if (newlen > old->sz)
    {
      rep = Inew(newlen);
      scpy(old->s, rep->s, oldlen);
      rep->sgn = old->sgn;
      if (!STATIC_IntRep(old)) delete old;
    }
    else
      rep = old;
  }

  rep->len = newlen;
  Iclear_from(rep, oldlen);

  return rep;
}


// same, for straight copy

IntRep* Icopy(IntRep* old, const IntRep* src)
{
  if (old == src) return old; 
  IntRep* rep;
  if (src == 0)
  {
    if (old == 0)
      rep = Inew(0);
    else
    {
      rep = old;
      Iclear_from(rep, 0);
    }
    rep->len = 0;
    rep->sgn = I_POSITIVE;
  }
  else 
  {
    size_t newlen = src->len;
    if (old == 0 || newlen > old->sz)
    {
      if (old != 0 && !STATIC_IntRep(old)) delete old;
      rep = Inew(newlen);
    }
    else
      rep = old;

    rep->len = newlen;
    rep->sgn = src->sgn;

    scpy(src->s, rep->s, newlen);
  }

  return rep;
}

// allocate & copy space for a long

IntRep* Icopy_long(IntRep* old, long x)
{
  int newsgn = (x >= 0);
  IntRep* rep = Icopy_ulong(old, newsgn ? x : -x);
  rep->sgn = newsgn;
  return rep;
}

IntRep* Icopy_ulong(IntRep* old, unsigned long x)
{
  unsigned short src[SHORT_PER_LONG];
  
  unsigned short srclen = 0;
  while (x != 0)
  {
    src[srclen++] = extract(x);
    x = down(x);
  }

  IntRep* rep;
  if (old == 0 || srclen > old->sz)
  {
    if (old != 0 && !STATIC_IntRep(old)) delete old;
    rep = Inew(srclen);
  }
  else
    rep = old;

  rep->len = srclen;
  rep->sgn = I_POSITIVE;

  scpy(src, rep->s, srclen);

  return rep;
}

// special case for zero -- it's worth it!

IntRep* Icopy_zero(IntRep* old)
{
  if (old == 0 || STATIC_IntRep(old))
    return &_ZeroRep;

  old->len = 0;
  old->sgn = I_POSITIVE;

  return old;
}

// special case for 1 or -1

IntRep* Icopy_one(IntRep* old, int newsgn)
{
  if (old == 0 || 1 > old->sz)
  {
    if (old != 0 && !STATIC_IntRep(old)) delete old;
    return newsgn==I_NEGATIVE ? &_MinusOneRep : &_OneRep;
  }

  old->sgn = newsgn;
  old->len = 1;
  old->s[0] = 1;

  return old;
}

// convert to a legal two's complement long if possible
// if too big, return most negative/positive value

long Itolong(const IntRep* rep)
{ 
  if ((unsigned)(rep->len) > (unsigned)(SHORT_PER_LONG))
    return (rep->sgn == I_POSITIVE) ? LONG_MAX : LONG_MIN;
  else if (rep->len == 0)
    return 0;
  else if ((unsigned)(rep->len) < (unsigned)(SHORT_PER_LONG))
  {
    unsigned long a = rep->s[rep->len-1];
    if (SHORT_PER_LONG > 2) // normally optimized out
    {
      for (int i = rep->len - 2; i >= 0; --i)
        a = up(a) | rep->s[i];
    }
    return (rep->sgn == I_POSITIVE)? a : -((long)a);
  }
  else 
  {
    unsigned long a = rep->s[SHORT_PER_LONG - 1];
    if (a >= I_MINNUM)
      return (rep->sgn == I_POSITIVE) ? LONG_MAX : LONG_MIN;
    else
    {
      a = up(a) | rep->s[SHORT_PER_LONG - 2];
      if (SHORT_PER_LONG > 2)
      {
        for (int i = SHORT_PER_LONG - 3; i >= 0; --i)
          a = up(a) | rep->s[i];
      }
      return (rep->sgn == I_POSITIVE)? a : -((long)a);
    }
  }
}

// test whether op long() will work.
// careful about asymmetry between LONG_MIN & LONG_MAX

int Iislong(const IntRep* rep)
{
  size_t l = rep->len;
  if (l < SHORT_PER_LONG)
    return 1;
  else if (l > SHORT_PER_LONG)
    return 0;
  else if ((unsigned)(rep->s[SHORT_PER_LONG - 1]) < (unsigned)(I_MINNUM))
    return 1;
  else if (rep->sgn == I_NEGATIVE && rep->s[SHORT_PER_LONG - 1] == I_MINNUM)
  {
    for (unsigned int i = 0; i < SHORT_PER_LONG - 1; ++i)
      if (rep->s[i] != 0)
        return 0;
    return 1;
  }
  else
    return 0;
}

// comparison functions
  
int32_t compare(const IntRep* x, const IntRep* y)
{
  int32_t diff  = (int32_t)x->sgn - (int32_t)y->sgn;
  if (diff == 0)
  {
    diff = (int32_t)x->len - (int32_t)y->len;
    if (diff == 0)
      diff = docmp(x->s, y->s, x->len);
    if (x->sgn == I_NEGATIVE)
      diff = -diff;
  }
  return diff;
}

int32_t ucompare(const IntRep* x, const IntRep* y)
{
  int32_t diff = (int32_t)x->len - (int32_t)y->len;
  if (diff == 0)
  {
    size_t l = x->len;
    const unsigned short* xs = &(x->s[l]);
    const unsigned short* ys = &(y->s[l]);
    while (l-- > 0 && (diff = (int32_t)(*--xs) - (int32_t)(*--ys)) == 0);
  }
  return diff;
}

int32_t compare(const IntRep* x, long  y)
{
  size_t xl = x->len;
  int xsgn = x->sgn;
  if (y == 0)
  {
    if (xl == 0)
      return 0;
    else if (xsgn == I_NEGATIVE)
      return -1;
    else
      return 1;
  }
  else
  {
    int ysgn = y >= 0;
    unsigned long uy = (ysgn)? y : -y;
    int32_t diff = xsgn - ysgn;
    if (diff == 0)
    {
      diff = xl - SHORT_PER_LONG;
      if (diff <= 0)
      {
        unsigned short tmp[SHORT_PER_LONG];
        int yl = 0;
        while (uy != 0)
        {
          tmp[yl++] = extract(uy);
          uy = down(uy);
        }
        diff = xl - yl;
        if (diff == 0)
          diff = docmp(x->s, tmp, xl);
      }
      if (xsgn == I_NEGATIVE)
	diff = -diff;
    }
    return diff;
  }
}

int32_t ucompare(const IntRep* x, long  y)
{
  size_t xl = x->len;
  if (y == 0)
    return xl;
  else
  {
    unsigned long uy = (y >= 0)? y : -y;
    int32_t diff = xl - SHORT_PER_LONG;
    if (diff <= 0)
    {
      unsigned short tmp[SHORT_PER_LONG];
      size_t yl = 0;
      while (uy != 0)
      {
        tmp[yl++] = extract(uy);
        uy = down(uy);
      }
      diff = (int32_t)xl - (int32_t)yl;
      if (diff == 0)
        diff = docmp(x->s, tmp, xl);
    }
    return diff;
  }
}



// arithmetic functions

IntRep* add(const IntRep* x, int negatex, 
            const IntRep* y, int negatey, IntRep* r)
{
  nonnil(x);
  nonnil(y);

  int xl = x->len;
  int yl = y->len;

  int xsgn = (negatex && xl != 0) ? !x->sgn : x->sgn;
  int ysgn = (negatey && yl != 0) ? !y->sgn : y->sgn;

  int xrsame = x == r;
  int yrsame = y == r;

  if (yl == 0)
    r = Ialloc(r, x->s, xl, xsgn, xl);
  else if (xl == 0)
    r = Ialloc(r, y->s, yl, ysgn, yl);
  else if (xsgn == ysgn)
  {
    if (xrsame || yrsame)
      r = Iresize(r, calc_len(xl, yl, 1));
    else
      r = Icalloc(r, calc_len(xl, yl, 1));
    r->sgn = xsgn;
    unsigned short* rs = r->s;
    const unsigned short* as;
    const unsigned short* bs;
    const unsigned short* topa;
    const unsigned short* topb;
    if (xl >= yl)
    {
      as =  (xrsame)? r->s : x->s;
      topa = &(as[xl]);
      bs =  (yrsame)? r->s : y->s;
      topb = &(bs[yl]);
    }
    else
    {
      bs =  (xrsame)? r->s : x->s;
      topb = &(bs[xl]);
      as =  (yrsame)? r->s : y->s;
      topa = &(as[yl]);
    }
    unsigned long sum = 0;
    while (bs < topb)
    {
      sum += (unsigned long)(*as++) + (unsigned long)(*bs++);
      *rs++ = extract(sum);
      sum = down(sum);
    }
    while (sum != 0 && as < topa)
    {
      sum += (unsigned long)(*as++);
      *rs++ = extract(sum);
      sum = down(sum);
    }
    if (sum != 0)
      *rs = extract(sum);
    else if (rs != as)
      while (as < topa)
        *rs++ = *as++;
  }
  else
  {
    int32_t comp = ucompare(x, y);
    if (comp == 0)
      r = Icopy_zero(r);
    else
    {
      if (xrsame || yrsame)
        r = Iresize(r, calc_len(xl, yl, 0));
      else
        r = Icalloc(r, calc_len(xl, yl, 0));
      unsigned short* rs = r->s;
      const unsigned short* as;
      const unsigned short* bs;
      const unsigned short* topa;
      const unsigned short* topb;
      if (comp > 0)
      {
        as =  (xrsame)? r->s : x->s;
        topa = &(as[xl]);
        bs =  (yrsame)? r->s : y->s;
        topb = &(bs[yl]);
        r->sgn = xsgn;
      }
      else
      {
        bs =  (xrsame)? r->s : x->s;
        topb = &(bs[xl]);
        as =  (yrsame)? r->s : y->s;
        topa = &(as[yl]);
        r->sgn = ysgn;
      }
      unsigned long hi = 1;
      while (bs < topb)
      {
        hi += (unsigned long)(*as++) + I_MAXNUM - (unsigned long)(*bs++);
        *rs++ = extract(hi);
        hi = down(hi);
      }
      while (hi == 0 && as < topa)
      {
        hi = (unsigned long)(*as++) + I_MAXNUM;
        *rs++ = extract(hi);
        hi = down(hi);
      }
      if (rs != as)
        while (as < topa)
          *rs++ = *as++;
    }
  }
  Icheck(r);
  return r;
}


IntRep* add(const IntRep* x, int negatex, long y, IntRep* r)
{
  nonnil(x);
  int xl = x->len;
  int xsgn = (negatex && xl != 0) ? !x->sgn : x->sgn;
  int xrsame = x == r;

  int ysgn = (y >= 0);
  unsigned long uy = (ysgn)? y : -y;

  if (y == 0)
    r = Ialloc(r, x->s, xl, xsgn, xl);
  else if (xl == 0)
    r = Icopy_long(r, y);
  else if (xsgn == ysgn)
  {
    if (xrsame)
      r = Iresize(r, calc_len(xl, SHORT_PER_LONG, 1));
    else
      r = Icalloc(r, calc_len(xl, SHORT_PER_LONG, 1));
    r->sgn = xsgn;
    unsigned short* rs = r->s;
    const unsigned short* as =  (xrsame)? r->s : x->s;
    const unsigned short* topa = &(as[xl]);
    unsigned long sum = 0;
    while (as < topa && uy != 0)
    {
      unsigned long u = extract(uy);
      uy = down(uy);
      sum += (unsigned long)(*as++) + u;
      *rs++ = extract(sum);
      sum = down(sum);
    }
    while (sum != 0 && as < topa)
    {
      sum += (unsigned long)(*as++);
      *rs++ = extract(sum);
      sum = down(sum);
    }
    if (sum != 0)
      *rs = extract(sum);
    else if (rs != as)
      while (as < topa)
        *rs++ = *as++;
  }
  else
  {
    unsigned short tmp[SHORT_PER_LONG];
    int yl = 0;
    while (uy != 0)
    {
      tmp[yl++] = extract(uy);
      uy = down(uy);
    }
    int32_t comp = xl - yl;
    if (comp == 0)
      comp = docmp(x->s, tmp, yl);
    if (comp == 0)
      r = Icopy_zero(r);
    else
    {
      if (xrsame)
        r = Iresize(r, calc_len(xl, yl, 0));
      else
        r = Icalloc(r, calc_len(xl, yl, 0));
      unsigned short* rs = r->s;
      const unsigned short* as;
      const unsigned short* bs;
      const unsigned short* topa;
      const unsigned short* topb;
      if (comp > 0)
      {
        as =  (xrsame)? r->s : x->s;
        topa = &(as[xl]);
        bs =  tmp;
        topb = &(bs[yl]);
        r->sgn = xsgn;
      }
      else
      {
        bs =  (xrsame)? r->s : x->s;
        topb = &(bs[xl]);
        as =  tmp;
        topa = &(as[yl]);
        r->sgn = ysgn;
      }
      unsigned long hi = 1;
      while (bs < topb)
      {
        hi += (unsigned long)(*as++) + I_MAXNUM - (unsigned long)(*bs++);
        *rs++ = extract(hi);
        hi = down(hi);
      }
      while (hi == 0 && as < topa)
      {
        hi = (unsigned long)(*as++) + I_MAXNUM;
        *rs++ = extract(hi);
        hi = down(hi);
      }
      if (rs != as)
        while (as < topa)
          *rs++ = *as++;
    }
  }
  Icheck(r);
  return r;
}


IntRep* multiply(const IntRep* x, const IntRep* y, IntRep* r)
{
  nonnil(x);
  nonnil(y);
  int xl = x->len;
  int yl = y->len;
  int rl = xl + yl;
  int rsgn = x->sgn == y->sgn;
  int xrsame = x == r;
  int yrsame = y == r;
  int xysame = x == y;
  
  if (xl == 0 || yl == 0)
    r = Icopy_zero(r);
  else if (xl == 1 && x->s[0] == 1)
    r = Icopy(r, y);
  else if (yl == 1 && y->s[0] == 1)
    r = Icopy(r, x);
  else if (!(xysame && xrsame))
  {
    if (xrsame || yrsame)
      r = Iresize(r, rl);
    else
      r = Icalloc(r, rl);
    unsigned short* rs = r->s;
    unsigned short* topr = &(rs[rl]);

    // use best inner/outer loop params given constraints
    unsigned short* currentr;
    const unsigned short* bota;
    const unsigned short* as;
    const unsigned short* botb;
    const unsigned short* topb;
    if (xrsame)                 
    { 
      currentr = &(rs[xl-1]);
      bota = rs;
      as = currentr;
      botb = y->s;
      topb = &(botb[yl]);
    }
    else if (yrsame)
    {
      currentr = &(rs[yl-1]);
      bota = rs;
      as = currentr;
      botb = x->s;
      topb = &(botb[xl]);
    }
    else if (xl <= yl)
    {
      currentr = &(rs[xl-1]);
      bota = x->s;
      as = &(bota[xl-1]);
      botb = y->s;
      topb = &(botb[yl]);
    }
    else
    {
      currentr = &(rs[yl-1]);
      bota = y->s;
      as = &(bota[yl-1]);
      botb = x->s;
      topb = &(botb[xl]);
    }

    while (as >= bota)
    {
      unsigned long ai = (unsigned long)(*as--);
      unsigned short* rs = currentr--;
      *rs = 0;
      if (ai != 0)
      {
        unsigned long sum = 0;
        const unsigned short* bs = botb;
        while (bs < topb)
        {
          sum += ai * (unsigned long)(*bs++) + (unsigned long)(*rs);
          *rs++ = extract(sum);
          sum = down(sum);
        }
        while (sum != 0 && rs < topr)
        {
          sum += (unsigned long)(*rs);
          *rs++ = extract(sum);
          sum = down(sum);
        }
      }
    }
  }
  else                          // x, y, and r same; compute over diagonals
  {
    r = Iresize(r, rl);
    unsigned short* botr = r->s;
    unsigned short* topr = &(botr[rl]);
    unsigned short* rs =   &(botr[rl - 2]);

    const unsigned short* bota = (xrsame)? botr : x->s;
    const unsigned short* loa =  &(bota[xl - 1]);
    const unsigned short* hia =  loa;

    for (; rs >= botr; --rs)
    {
      const unsigned short* h = hia;
      const unsigned short* l = loa;
      unsigned long prod = (unsigned long)(*h) * (unsigned long)(*l);
      *rs = 0;

      for(;;)
      {
        unsigned short* rt = rs;
        unsigned long sum = prod + (unsigned long)(*rt);
        *rt++ = extract(sum);
        sum = down(sum);
        while (sum != 0 && rt < topr)
        {
          sum += (unsigned long)(*rt);
          *rt++ = extract(sum);
          sum = down(sum);
        }
        if (h > l)
        {
          rt = rs;
          sum = prod + (unsigned long)(*rt);
          *rt++ = extract(sum);
          sum = down(sum);
          while (sum != 0 && rt < topr)
          {
            sum += (unsigned long)(*rt);
            *rt++ = extract(sum);
            sum = down(sum);
          }
          if (--h >= ++l)
            prod = (unsigned long)(*h) * (unsigned long)(*l);
          else
            break;
        }
        else
          break;
      }
      if (loa > bota)
        --loa;
      else
        --hia;
    }
  }
  r->sgn = rsgn;
  Icheck(r);
  return r;
}


IntRep* multiply(const IntRep* x, long y, IntRep* r)
{
  nonnil(x);
  int xl = x->len;
    
  if (xl == 0 || y == 0)
    r = Icopy_zero(r);
  else if (y == 1)
    r = Icopy(r, x);
  else
  {
    int ysgn = y >= 0;
    int rsgn = x->sgn == ysgn;
    unsigned long uy = (ysgn)? y : -y;
    unsigned short tmp[SHORT_PER_LONG];
    int yl = 0;
    while (uy != 0)
    {
      tmp[yl++] = extract(uy);
      uy = down(uy);
    }

    int rl = xl + yl;
    int xrsame = x == r;
    if (xrsame)
      r = Iresize(r, rl);
    else
      r = Icalloc(r, rl);

    unsigned short* rs = r->s;
    unsigned short* topr = &(rs[rl]);
    unsigned short* currentr;
    const unsigned short* bota;
    const unsigned short* as;
    const unsigned short* botb;
    const unsigned short* topb;

    if (xrsame)
    { 
      currentr = &(rs[xl-1]);
      bota = rs;
      as = currentr;
      botb = tmp;
      topb = &(botb[yl]);
    }
    else if (xl <= yl)
    {
      currentr = &(rs[xl-1]);
      bota = x->s;
      as = &(bota[xl-1]);
      botb = tmp;
      topb = &(botb[yl]);
    }
    else
    {
      currentr = &(rs[yl-1]);
      bota = tmp;
      as = &(bota[yl-1]);
      botb = x->s;
      topb = &(botb[xl]);
    }

    while (as >= bota)
    {
      unsigned long ai = (unsigned long)(*as--);
      unsigned short* rs = currentr--;
      *rs = 0;
      if (ai != 0)
      {
        unsigned long sum = 0;
        const unsigned short* bs = botb;
        while (bs < topb)
        {
          sum += ai * (unsigned long)(*bs++) + (unsigned long)(*rs);
          *rs++ = extract(sum);
          sum = down(sum);
        }
        while (sum != 0 && rs < topr)
        {
          sum += (unsigned long)(*rs);
          *rs++ = extract(sum);
          sum = down(sum);
        }
      }
    }
    r->sgn = rsgn;
  }
  Icheck(r);
  return r;
}


// main division routine

static void do_divide(unsigned short* rs,
                      const unsigned short* ys, int yl,
                      unsigned short* qs, int ql)
{
  const unsigned short* topy = &(ys[yl]);
  unsigned short d1 = ys[yl - 1];
  unsigned short d2 = ys[yl - 2];
 
  int l = ql - 1;
  int i = l + yl;
  
  for (; l >= 0; --l, --i)
  {
    unsigned short qhat;       // guess q
    if (d1 == rs[i])
      qhat = I_MAXNUM;
    else
    {
      unsigned long lr = up((unsigned long)rs[i]) | (unsigned long)rs[i-1];
      qhat = lr / d1;
    }

    for(;;)     // adjust q, use docmp to avoid overflow problems
    {
      unsigned short ts[3];
      unsigned long prod = (unsigned long)d2 * (unsigned long)qhat;
      ts[0] = extract(prod);
      prod = down(prod) + (unsigned long)d1 * (unsigned long)qhat;
      ts[1] = extract(prod);
      ts[2] = extract(down(prod));
      if (docmp(ts, &(rs[i-2]), 3) > 0)
        --qhat;
      else
        break;
    };
    
    // multiply & subtract
    
    const unsigned short* yt = ys;
    unsigned short* rt = &(rs[l]);
    unsigned long prod = 0;
    unsigned long hi = 1;
    while (yt < topy)
    {
      prod = (unsigned long)qhat * (unsigned long)(*yt++) + down(prod);
      hi += (unsigned long)(*rt) + I_MAXNUM - (unsigned long)(extract(prod));
      *rt++ = extract(hi);
      hi = down(hi);
    }
    hi += (unsigned long)(*rt) + I_MAXNUM - (unsigned long)(down(prod));
    *rt = extract(hi);
    hi = down(hi);
    
    // off-by-one, add back
    
    if (hi == 0)
    {
      --qhat;
      yt = ys;
      rt = &(rs[l]);
      hi = 0;
      while (yt < topy)
      {
        hi = (unsigned long)(*rt) + (unsigned long)(*yt++) + down(hi);
        *rt++ = extract(hi);
      }
      *rt = 0;
    }
    if (qs != 0)
      qs[l] = qhat;
  }
}

// divide by single digit, return remainder
// if q != 0, then keep the result in q, else just compute rem

static int unscale(const unsigned short* x, int xl, unsigned short y,
                   unsigned short* q)
{
  if (xl == 0 || y == 1)
    return 0;
  else if (q != 0)
  {
    unsigned short* botq = q;
    unsigned short* qs = &(botq[xl - 1]);
    const unsigned short* xs = &(x[xl - 1]);
    unsigned long rem = 0;
    while (qs >= botq)
    {
      rem = up(rem) | *xs--;
      unsigned long u = rem / y;
      *qs-- = extract(u);
      rem -= u * y;
    }
    int r = extract(rem);
    return r;
  }
  else                          // same loop, a bit faster if just need rem
  {
    const unsigned short* botx = x;
    const unsigned short* xs = &(botx[xl - 1]);
    unsigned long rem = 0;
    while (xs >= botx)
    {
      rem = up(rem) | *xs--;
      unsigned long u = rem / y;
      rem -= u * y;
    }
    int r = extract(rem);
    return r;
  }
}


IntRep* div(const IntRep* x, const IntRep* y, IntRep* q)
{
  nonnil(x);
  nonnil(y);
  int xl = x->len;
  int yl = y->len;
  if (yl == 0) (*lib_error_handler)("Integer", "attempted division by zero");

  int comp = ucompare(x, y);
  int xsgn = x->sgn;
  int ysgn = y->sgn;

  int samesign = xsgn == ysgn;

  if (comp < 0)
    q = Icopy_zero(q);
  else if (comp == 0)
    q = Icopy_one(q, samesign);
  else if (yl == 1)
  {
    q = Icopy(q, x);
    unscale(q->s, q->len, y->s[0], q->s);
  }
  else
  {
    IntRep* yy = 0;
    IntRep* r  = 0;
    unsigned short prescale = (I_RADIX / (1 + (int32_t)y->s[yl - 1]));
    if (prescale != 1 || y == q)
    {
      yy = multiply(y, ((long)prescale & I_MAXNUM), yy);
      r = multiply(x, ((long)prescale & I_MAXNUM), r);
    }
    else
    {
      yy = (IntRep*)y;
      r = Icalloc(r, xl + 1);
      scpy(x->s, r->s, xl);
    }

    int ql = xl - yl + 1;
      
    q = Icalloc(q, ql);
    do_divide(r->s, yy->s, yl, q->s, ql);

    if (yy != y && !STATIC_IntRep(yy)) delete yy;
    if (!STATIC_IntRep(r)) delete r;
  }
  q->sgn = samesign;
  Icheck(q);
  return q;
}

IntRep* div(const IntRep* x, long y, IntRep* q)
{
  nonnil(x);
  int xl = x->len;
  if (y == 0) (*lib_error_handler)("Integer", "attempted division by zero");

  unsigned short ys[SHORT_PER_LONG];
  unsigned long u;
  int ysgn = y >= 0;
  if (ysgn)
    u = y;
  else
    u = -y;
  int yl = 0;
  while (u != 0)
  {
    ys[yl++] = extract(u);
    u = down(u);
  }

  int comp = (int32_t)xl - yl;
  if (comp == 0) comp = docmp(x->s, ys, xl);

  int xsgn = x->sgn;
  int samesign = xsgn == ysgn;

  if (comp < 0)
    q = Icopy_zero(q);
  else if (comp == 0)
  {
    q = Icopy_one(q, samesign);
  }
  else if (yl == 1)
  {
    q = Icopy(q, x);
    unscale(q->s, q->len, ys[0], q->s);
  }
  else
  {
    IntRep* r  = 0;
    unsigned short prescale = (I_RADIX / (1 + (int32_t)ys[yl - 1]));
    if (prescale != 1)
    {
      unsigned long prod = (unsigned long)prescale * (unsigned long)ys[0];
      ys[0] = extract(prod);
      prod = down(prod) + (unsigned long)prescale * (unsigned long)ys[1];
      ys[1] = extract(prod);
      r = multiply(x, ((long)prescale & I_MAXNUM), r);
    }
    else
    {
      r = Icalloc(r, xl + 1);
      scpy(x->s, r->s, xl);
    }

    int ql = xl - yl + 1;
      
    q = Icalloc(q, ql);
    do_divide(r->s, ys, yl, q->s, ql);

    if (!STATIC_IntRep(r)) delete r;
  }
  q->sgn = samesign;
  Icheck(q);
  return q;
}


void divide(const Integer& Ix, long y, Integer& Iq, long& rem)
{
  const IntRep* x = Ix.rep;
  nonnil(x);
  IntRep* q = Iq.rep;
  int xl = x->len;
  if (y == 0) (*lib_error_handler)("Integer", "attempted division by zero");

  unsigned short ys[SHORT_PER_LONG];
  unsigned long u;
  int ysgn = y >= 0;
  if (ysgn)
    u = y;
  else
    u = -y;
  int yl = 0;
  while (u != 0)
  {
    ys[yl++] = extract(u);
    u = down(u);
  }

  int comp = (int32_t)xl - yl;
  if (comp == 0) comp = docmp(x->s, ys, xl);

  int xsgn = x->sgn;
  int samesign = xsgn == ysgn;

  if (comp < 0)
  {
    rem = Itolong(x);
    q = Icopy_zero(q);
  }
  else if (comp == 0)
  {
    q = Icopy_one(q, samesign);
    rem = 0;
  }
  else if (yl == 1)
  {
    q = Icopy(q, x);
    rem = unscale(q->s, q->len, ys[0], q->s);
  }
  else
  {
    IntRep* r  = 0;
    unsigned short prescale = (I_RADIX / (1 + (int32_t)ys[yl - 1]));
    if (prescale != 1)
    {
      unsigned long prod = (unsigned long)prescale * (unsigned long)ys[0];
      ys[0] = extract(prod);
      prod = down(prod) + (unsigned long)prescale * (unsigned long)ys[1];
      ys[1] = extract(prod);
      r = multiply(x, ((long)prescale & I_MAXNUM), r);
    }
    else
    {
      r = Icalloc(r, xl + 1);
      scpy(x->s, r->s, xl);
    }

    int ql = xl - yl + 1;
      
    q = Icalloc(q, ql);
    
    do_divide(r->s, ys, yl, q->s, ql);

    if (prescale != 1)
    {
      Icheck(r);
      unscale(r->s, r->len, prescale, r->s);
    }
    Icheck(r);
    rem = Itolong(r);
    if (!STATIC_IntRep(r)) delete r;
  }
  if(rem<0) rem = -rem;
  if (xsgn == I_NEGATIVE) rem = -rem;
  q->sgn = samesign;
  Icheck(q);
  Iq.rep = q;
}


void divide(const Integer& Ix, const Integer& Iy, Integer& Iq, Integer& Ir)
{
  const IntRep* x = Ix.rep;
  nonnil(x);
  const IntRep* y = Iy.rep;
  nonnil(y);
  IntRep* q = Iq.rep;
  IntRep* r = Ir.rep;

  int xl = x->len;
  int yl = y->len;
  if (yl == 0)
    (*lib_error_handler)("Integer", "attempted division by zero");

  int comp = ucompare(x, y);
  int xsgn = x->sgn;
  int ysgn = y->sgn;

  int samesign = xsgn == ysgn;

  if (comp < 0)
  {
    q = Icopy_zero(q);
    r = Icopy(r, x);
  }
  else if (comp == 0)
  {
    q = Icopy_one(q, samesign);
    r = Icopy_zero(r);
  }
  else if (yl == 1)
  {
    q = Icopy(q, x);
    int rem =  unscale(q->s, q->len, y->s[0], q->s);
    r = Icopy_long(r, rem);
    if (rem != 0)
      r->sgn = xsgn;
  }
  else
  {
    IntRep* yy = 0;
    unsigned short prescale = (((long)I_RADIX) / (1 + (int32_t)y->s[yl - 1]));
    if (prescale != 1 || y == q || y == r)
    {
      yy = multiply(y, ((long)prescale & I_MAXNUM), yy);
      r = multiply(x, ((long)prescale & I_MAXNUM), r);
    }
    else
    {
      yy = (IntRep*)y;
      r = Icalloc(r, xl + 1);
      scpy(x->s, r->s, xl);
    }

    int ql = xl - yl + 1;
      
    q = Icalloc(q, ql);
    do_divide(r->s, yy->s, yl, q->s, ql);

    if (yy != y && !STATIC_IntRep(yy)) delete yy;
    if (prescale != 1)
    {
      Icheck(r);
      unscale(r->s, r->len, prescale, r->s);
    }
  }
  q->sgn = samesign;
  Icheck(q);
  Iq.rep = q;
  Icheck(r);
  Ir.rep = r;
}

IntRep* mod(const IntRep* x, const IntRep* y, IntRep* r)
{
  nonnil(x);
  nonnil(y);
  int xl = x->len;
  int yl = y->len;
  if (yl == 0) (*lib_error_handler)("Integer", "attempted division by zero");

  int32_t comp = ucompare(x, y);
  int xsgn = x->sgn;

  if (comp < 0)
    r = Icopy(r, x);
  else if (comp == 0)
    r = Icopy_zero(r);
  else if (yl == 1)
  {
    int32_t rem = unscale(x->s, xl, y->s[0], 0);
    r = Icopy_long(r, rem);
    if (rem != 0)
      r->sgn = xsgn;
  }
  else
  {
    IntRep* yy = 0;
    unsigned short prescale = (I_RADIX / (1 + (int32_t)y->s[yl - 1]));
    if (prescale != 1 || y == r)
    {
      yy = multiply(y, ((long)prescale & I_MAXNUM), yy);
      r = multiply(x, ((long)prescale & I_MAXNUM), r);
    }
    else
    {
      yy = (IntRep*)y;
      r = Icalloc(r, xl + 1);
      scpy(x->s, r->s, xl);
    }
      
    do_divide(r->s, yy->s, yl, 0, xl - yl + 1);

    if (yy != y && !STATIC_IntRep(yy)) delete yy;

    if (prescale != 1)
    {
      Icheck(r);
      unscale(r->s, r->len, prescale, r->s);
    }
  }
  Icheck(r);
  return r;
}

IntRep* mod(const IntRep* x, long y, IntRep* r)
{
  nonnil(x);
  int xl = x->len;
  if (y == 0) (*lib_error_handler)("Integer", "attempted division by zero");

  unsigned short ys[SHORT_PER_LONG];
  unsigned long u;
  int ysgn = y >= 0;
  if (ysgn)
    u = y;
  else
    u = -y;
  int yl = 0;
  while (u != 0)
  {
    ys[yl++] = extract(u);
    u = down(u);
  }

  int32_t comp = (int32_t)xl - (int32_t)yl;
  if (comp == 0) 
     comp = docmp(x->s, ys, xl);

  int xsgn = x->sgn;

  if (comp < 0)
    r = Icopy(r, x);
  else if (comp == 0)
    r = Icopy_zero(r);
  else if (yl == 1)
  {
    int32_t rem = unscale(x->s, xl, ys[0], 0);
    r = Icopy_long(r, rem);
    if (rem != 0)
      r->sgn = xsgn;
  }
  else
  {
    unsigned short prescale = (I_RADIX / (1 + (int32_t)ys[yl - 1]));
    if (prescale != 1)
    {
      unsigned long prod = (unsigned long)prescale * (unsigned long)ys[0];
      ys[0] = extract(prod);
      prod = down(prod) + (unsigned long)prescale * (unsigned long)ys[1];
      ys[1] = extract(prod);
      r = multiply(x, ((long)prescale & I_MAXNUM), r);
    }
    else
    {
      r = Icalloc(r, xl + 1);
      scpy(x->s, r->s, xl);
    }
      
    do_divide(r->s, ys, yl, 0, xl - yl + 1);

    if (prescale != 1)
    {
      Icheck(r);
      unscale(r->s, r->len, prescale, r->s);
    }
  }
  Icheck(r);
  return r;
}

IntRep* lshift(const IntRep* x, long y, IntRep* r)
{
  nonnil(x);
  int xl = x->len;
  if (xl == 0 || y == 0)
  {
    r = Icopy(r, x);
    return r;
  }

  int xrsame = x == r;
  int rsgn = x->sgn;

  long ay = (y < 0)? -y : y;
  int bw = ay / I_SHIFT;
  int sw = ay % I_SHIFT;

  if (y > 0)
  {
    int rl = bw + xl + 1;
    if (xrsame)
      r = Iresize(r, rl);
    else
      r = Icalloc(r, rl);

    unsigned short* botr = r->s;
    unsigned short* rs = &(botr[rl - 1]);
    const unsigned short* botx = (xrsame)? botr : x->s;
    const unsigned short* xs = &(botx[xl - 1]);
    unsigned long a = 0;
    while (xs >= botx)
    {
      a = up(a) | ((unsigned long)(*xs--) << sw);
      *rs-- = extract(down(a));
    }
    *rs-- = extract(a);
    while (rs >= botr)
      *rs-- = 0;
  }
  else
  {
    int rl = (int32_t)xl - bw;
    if (rl < 0)
      r = Icopy_zero(r);
    else
    {
      if (xrsame)
        r = Iresize(r, rl);
      else
        r = Icalloc(r, rl);
      int rw = I_SHIFT - sw;
      unsigned short* rs = r->s;
      unsigned short* topr = &(rs[rl]);
      const unsigned short* botx = (xrsame)? rs : x->s;
      const unsigned short* xs =  &(botx[bw]);
      const unsigned short* topx = &(botx[xl]);
      unsigned long a = (unsigned long)(*xs++) >> sw;
      while (xs < topx)
      {
        a |= (unsigned long)(*xs++) << rw;
        *rs++ = extract(a);
        a = down(a);
      }
      *rs++ = extract(a);
      if (xrsame) topr = (unsigned short*)topx;
      while (rs < topr)
        *rs++ = 0;
    }
  }
  r->sgn = rsgn;
  Icheck(r);
  return r;
}

IntRep* lshift(const IntRep* x, const IntRep* yy, int negatey, IntRep* r)
{
  long y = Itolong(yy);
  if (negatey)
    y = -y;

  return lshift(x, y, r);
}

IntRep* bitop(const IntRep* x, const IntRep* y, IntRep* r, char op)
{
  nonnil(x);
  nonnil(y);
  int xl = x->len;
  int yl = y->len;
  int xsgn = x->sgn;
  int xrsame = x == r;
  int yrsame = y == r;
  if (xrsame || yrsame)
    r = Iresize(r, calc_len(xl, yl, 0));
  else
    r = Icalloc(r, calc_len(xl, yl, 0));
  r->sgn = xsgn;
  unsigned short* rs = r->s;
  unsigned short* topr = &(rs[r->len]);
  const unsigned short* as;
  const unsigned short* bs;
  const unsigned short* topb;
  if (xl >= yl)
  {
    as = (xrsame)? rs : x->s;
    bs = (yrsame)? rs : y->s;
    topb = &(bs[yl]);
  }
  else
  {
    bs = (xrsame)? rs : x->s;
    topb = &(bs[xl]);
    as = (yrsame)? rs : y->s;
  }

  switch (op)
  {
  case '&':
    while (bs < topb) *rs++ = *as++ & *bs++;
    while (rs < topr) *rs++ = 0;
    break;
  case '|':
    while (bs < topb) *rs++ = *as++ | *bs++;
    while (rs < topr) *rs++ = *as++;
    break;
  case '^':
    while (bs < topb) *rs++ = *as++ ^ *bs++;
    while (rs < topr) *rs++ = *as++;
    break;
  }
  Icheck(r);
  return r;
}

IntRep* bitop(const IntRep* x, long y, IntRep* r, char op)
{
  nonnil(x);
  unsigned short tmp[SHORT_PER_LONG];
  unsigned long u;
  int newsgn = (y >= 0);

  if (newsgn)
    u = y;
  else
    u = -y;
  
  int l = 0;
  while (u != 0)
  {
    tmp[l++] = extract(u);
    u = down(u);
  }

  size_t xl = x->len;
  size_t yl = l;
  int xsgn = x->sgn;
  int xrsame = x == r;
  if (xrsame)
    r = Iresize(r, calc_len(xl, yl, 0));
  else
    r = Icalloc(r, calc_len(xl, yl, 0));
  r->sgn = xsgn;
  unsigned short* rs = r->s;
  unsigned short* topr = &(rs[r->len]);
  const unsigned short* as;
  const unsigned short* bs;
  const unsigned short* topb;
  if (xl >= yl)
  {
    as = (xrsame)? rs : x->s;
    bs = tmp;
    topb = &(bs[yl]);
  }
  else
  {
    bs = (xrsame)? rs : x->s;
    topb = &(bs[xl]);
    as = tmp;
  }

  switch (op)
  {
  case '&':
    while (bs < topb) *rs++ = *as++ & *bs++;
    while (rs < topr) *rs++ = 0;
    break;
  case '|':
    while (bs < topb) *rs++ = *as++ | *bs++;
    while (rs < topr) *rs++ = *as++;
    break;
  case '^':
    while (bs < topb) *rs++ = *as++ ^ *bs++;
    while (rs < topr) *rs++ = *as++;
    break;
  }
  Icheck(r);
  return r;
}

void (setbit)(Integer& x, long b)
{
  if (b >= 0)
  {
    unsigned long bw = (unsigned long)b / I_SHIFT;
    unsigned long sw = (unsigned long)b % I_SHIFT;
    size_t xl = x.rep ? x.rep->len : 0;
    if (xl <= bw)
      x.rep = Iresize(x.rep, calc_len(xl, bw+1, 0));
    x.rep->s[bw] |= (1 << sw);
    Icheck(x.rep);
  }
}

void clearbit(Integer& x, long b)
{
  if (b >= 0)
    {
      if (x.rep == 0)
	x.rep = &_ZeroRep;
      else
	{
	  long bw = (unsigned long)b / I_SHIFT;
	  long sw = (unsigned long)b % I_SHIFT;
	  if (x.rep->len > bw)
	    x.rep->s[bw] &= ~(1 << sw);
	}
    Icheck(x.rep);
  }
}

int testbit(const Integer& x, long b)
{
  if (x.rep != 0 && b >= 0)
  {
    long bw = (unsigned long)b / I_SHIFT;
    long sw = (unsigned long)b % I_SHIFT;
    return (bw < x.rep->len && (x.rep->s[bw] & (1 << sw)) != 0);
  }
  else
    return 0;
}

// A  version of knuth's algorithm B / ex. 4.5.3.34
// A better version that doesn't bother shifting all of `t' forthcoming

IntRep* gcd(const IntRep* x, const IntRep* y)
{
  nonnil(x);
  nonnil(y);
  int ul = x->len;
  int vl = y->len;
  
  if (vl == 0)
    return Ialloc(0, x->s, ul, I_POSITIVE, ul);
  else if (ul == 0)
    return Ialloc(0, y->s, vl, I_POSITIVE, vl);

  IntRep* u = Ialloc(0, x->s, ul, I_POSITIVE, ul);
  IntRep* v = Ialloc(0, y->s, vl, I_POSITIVE, vl);

// find shift so that both not even

  long k = 0;
  int l = (ul <= vl)? ul : vl;
  int cont = 1;
  for (int i = 0;  i < l && cont; ++i)
  {
    unsigned long a =  (i < ul)? u->s[i] : 0;
    unsigned long b =  (i < vl)? v->s[i] : 0;
    for (unsigned int j = 0; j < I_SHIFT; ++j)
    {
      if ((a | b) & 1)
      {
        cont = 0;
        break;
      }
      else
      {
        ++k;
        a >>= 1;
        b >>= 1;
      }
    }
  }

  if (k != 0)
  {
    u = lshift(u, -k, u);
    v = lshift(v, -k, v);
  }

  IntRep* t;
  if (u->s[0] & 01)
    t = Ialloc(0, v->s, v->len, !v->sgn, v->len);
  else
    t = Ialloc(0, u->s, u->len, u->sgn, u->len);

  while (t->len != 0)
  {
    long s = 0;                 // shift t until odd
    cont = 1;
    int tl = t->len;
    for (int i = 0; i < tl && cont; ++i)
    {
      unsigned long a = t->s[i];
      for (unsigned int j = 0; j < I_SHIFT; ++j)
      {
        if (a & 1)
        {
          cont = 0;
          break;
        }
        else
        {
          ++s;
          a >>= 1;
        }
      }
    }

    if (s != 0) t = lshift(t, -s, t);

    if (t->sgn == I_POSITIVE)
    {
      u = Icopy(u, t);
      t = add(t, 0, v, 1, t);
    }
    else
    {
      v = Ialloc(v, t->s, t->len, !t->sgn, t->len);
      t = add(t, 0, u, 0, t);
    }
  }
  if (!STATIC_IntRep(t)) delete t;
  if (!STATIC_IntRep(v)) delete v;
  if (k != 0) u = lshift(u, k, u);
  return u;
}



long lg(const IntRep* x)
{
  nonnil(x);
  size_t xl = x->len;
  if (xl == 0)
    return 0;

  long l = (xl - 1) * I_SHIFT - 1;
  unsigned short a = x->s[xl-1];

  while (a != 0)
  {
    a = a >> 1;
    ++l;
  }
  return l;
}
  
IntRep* power(const IntRep* x, long y, IntRep* r)
{
  nonnil(x);
  int sgn;
  if (x->sgn == I_POSITIVE || (!(y & 1)))
    sgn = I_POSITIVE;
  else
    sgn = I_NEGATIVE;

  int xl = x->len;

  if (y == 0 || (xl == 1 && x->s[0] == 1))
    r = Icopy_one(r, sgn);
  else if (xl == 0 || y < 0)
    r = Icopy_zero(r);
  else if (y == 1 || y == -1)
    r = Icopy(r, x);
  else
  {
    int maxsize = ((lg(x) + 1) * y) / I_SHIFT + 2;     // pre-allocate space
    IntRep* b = Ialloc(0, x->s, xl, I_POSITIVE, maxsize);
    b->len = xl;
    r = Icalloc(r, maxsize);
    r = Icopy_one(r, I_POSITIVE);
    for(;;)
    {
      if (y & 1)
        r = multiply(r, b, r);
      if ((y >>= 1) == 0)
        break;
      else
        b = multiply(b, b, b);
    }
    if (!STATIC_IntRep(b)) delete b;
  }
  r->sgn = sgn;
  Icheck(r);
  return r;
}

IntRep* abs(const IntRep* src, IntRep* dest)
{
  nonnil(src);
  if (src != dest)
    dest = Icopy(dest, src);
  dest->sgn = I_POSITIVE;
  return dest;
}

IntRep* _negate(const IntRep* src, IntRep* dest)
{
  nonnil(src);
  if (src != dest)
    dest = Icopy(dest, src);
  if (dest->len != 0) 
    dest->sgn = !dest->sgn;
  return dest;
}

#if defined(PRE_GCC_296) && defined(__GNUG__) && !defined(_G_NO_NRV)

Integer sqrt(const Integer& x) return r(x)
{
  int s = sign(x);
  if (s < 0) x.error("Attempted square root of negative Integer");
  if (s != 0)
  {
    r >>= (lg(x) / 2); // get close
    Integer q;
    div(x, r, q);
    while (q < r)
    {
      r += q;
      r >>= 1;
      div(x, r, q);
    }
  }
  return;
}

Integer lcm(const Integer& x, const Integer& y) return r
{
  if (!x.initialized() || !y.initialized())
    x.error("operation on uninitialized Integer");
  Integer g;
  if (sign(x) == 0 || sign(y) == 0)
    g = 1;
  else 
    g = gcd(x, y);
  div(x, g, r);
  mul(r, y, r);
}

#else 
Integer sqrt(const Integer& x) 
{
  Integer r(x);
  int s = sign(x);
  if (s < 0) x.error("Attempted square root of negative Integer");
  if (s != 0)
  {
    r >>= (lg(x) / 2); // get close
    Integer q;
    div(x, r, q);
    while (q < r)
    {
      r += q;
      r >>= 1;
      div(x, r, q);
    }
  }
  return r;
}

Integer lcm(const Integer& x, const Integer& y) 
{
  Integer r;
  if (!x.initialized() || !y.initialized())
    x.error("operation on uninitialized Integer");
  Integer g;
  if (sign(x) == 0 || sign(y) == 0)
    g = 1;
  else 
    g = gcd(x, y);
  div(x, g, r);
  mul(r, y, r);
  return r;
}

#endif



IntRep* atoIntRep(const char* s, int base)
{
  int sl = strlen(s);
  IntRep* r = Icalloc(0, sl * (lg(base) + 1) / I_SHIFT + 1);
  if (s != 0)
  {
    char sgn;
    while (isspace(*s)) ++s;
    if (*s == '-')
    {
      sgn = I_NEGATIVE;
      s++;
    }
    else if (*s == '+')
    {
      sgn = I_POSITIVE;
      s++;
    }
    else
      sgn = I_POSITIVE;
    for (;;)
    {
      long digit;
      if (*s >= '0' && *s <= '9') digit = *s - '0';
      else if (*s >= 'a' && *s <= 'z') digit = *s - 'a' + 10;
      else if (*s >= 'A' && *s <= 'Z') digit = *s - 'A' + 10;
      else break;
      if (digit >= base) break;
      r = multiply(r, base, r);
      r = add(r, 0, digit, r);
      ++s;
    }
    r->sgn = sgn;
  }
  return r;
}



extern AllocRing _libgxx_fmtq;

char* Itoa(const IntRep* x, int base, int width)
{
  int fmtlen = (x->len + 1) * I_SHIFT / lg(base) + 4 + width;
  char* fmtbase = (char *) _libgxx_fmtq.alloc(fmtlen);
  char* f = cvtItoa(x, fmtbase, fmtlen, base, 0, width, 0, ' ', 'X', 0);
  return f;
}

ostream& operator << (ostream& s, const Integer& y)
{
#ifdef _OLD_STREAMS
  return s << Itoa(y.rep);
#else
  // if (s.opfx())
  if (s)
    {
      int base = (s.flags() & ios::oct) ? 8 : (s.flags() & ios::hex) ? 16 : 10;
      int width = s.width();
      y.printon(s, base, width);
    }
  return s;
#endif
}

void Integer::printon(ostream& s, int base /* =10 */, int width /* =0 */) const
{
  int align_right = !(s.flags() & ios::left);
  int showpos = s.flags() & ios::showpos;
  int showbase = s.flags() & ios::showbase;
  char fillchar = s.fill();
  char Xcase = (s.flags() & ios::uppercase)? 'X' : 'x';
  const IntRep* x = rep;
  int fmtlen = (x->len + 1) * I_SHIFT / lg(base) + 4 + width;
  char* fmtbase = new char[fmtlen];
  char* f = cvtItoa(x, fmtbase, fmtlen, base, showbase, width, align_right,
		    fillchar, Xcase, showpos);
  s.write(f, fmtlen);
  delete [] fmtbase;
}

char*  cvtItoa(const IntRep* x, char* fmt, int& fmtlen, int base, int showbase,
              int width, int align_right, char fillchar, char Xcase, 
              int showpos)
{
  char* e = fmt + fmtlen - 1;
  char* s = e;
  *--s = 0;

  if (x->len == 0)
    *--s = '0';
  else
  {
    IntRep* z = Icopy(0, x);

    // split division by base into two parts: 
    // first divide by biggest power of base that fits in an unsigned short,
    // then use straight signed div/mods from there. 

    // find power
    int bpower = 1;
    unsigned short b = base;
    unsigned short maxb = I_MAXNUM / base;
    while (b < maxb)
    {
      b *= base;
      ++bpower;
    }
    for(;;)
    {
      int rem = unscale(z->s, z->len, b, z->s);
      Icheck(z);
      if (z->len == 0)
      {
        while (rem != 0)
        {
          char ch = rem % base;
          rem /= base;
          if (ch >= 10)
            ch += 'a' - 10;
          else
            ch += '0';
          *--s = ch;
        }
	if (!STATIC_IntRep(z)) delete z;
        break;
      }
      else
      {
        for (int i = 0; i < bpower; ++i)
        {
          char ch = rem % base;
          rem /= base;
          if (ch >= 10)
            ch += 'a' - 10;
          else
            ch += '0';
          *--s = ch;
        }
      }
    }
  }

  if (base == 8 && showbase) 
    *--s = '0';
  else if (base == 16 && showbase) 
  { 
    *--s = Xcase; 
    *--s = '0'; 
  }
  if (x->sgn == I_NEGATIVE) *--s = '-';
  else if (showpos) *--s = '+';
  int w = e - s - 1;
  if (!align_right || w >= width)
  {
    while (w++ < width)
      *--s = fillchar;
    fmtlen = e - s - 1;
    return s;
  }
  else
  {
    char* p = fmt;
    for (char* t = s; *t != 0; ++t, ++p) *p = *t;
    while (w++ < width) *p++ = fillchar;
    *p = 0;
    fmtlen = p - fmt;
    return fmt;
  }
}

char* dec(const Integer& x, int width)
{
  return Itoa(x, 10, width);
}

char* oct(const Integer& x, int width)
{
  return Itoa(x, 8, width);
}

char* hex(const Integer& x, int width)
{
  return Itoa(x, 16, width);
}

istream& operator >> (istream& stream, Integer& val)
{
  // if (!stream.ipfx0())
  if (!stream)
    return stream;
  int sign = ' ';
  register streambuf* sb = stream.rdbuf();
  int base = 10;
  int ndigits = 0;
  register int ch = sb->sbumpc();
  while (ch != EOF && isspace(ch))
    ch = sb->sbumpc();
  if (ch == '+' || ch == '-')
    {
      sign = ch;
      ch = sb->sbumpc();
      while (ch != EOF && isspace(ch))
	ch = sb->sbumpc();
    }
  if (ch == EOF) goto eof_fail;
  if (!(stream.flags() & ios::basefield))
    {
      if (ch == '0')
	{
	  ch = sb->sbumpc();
	  if (ch == EOF) { }
	  else if (ch == 'x' || ch == 'X')
	    {
	      base = 16;
	      ch = sb->sbumpc();
	      if (ch == EOF) goto eof_fail;
	    }
	  else
	    {
	      sb->sputbackc(ch);
	      base = 8;
	      ch = '0';
	    }
	}
    }
  else if ((stream.flags() & ios::basefield) == ios::hex)
    base = 16;
  else if ((stream.flags() & ios::basefield) == ios::oct)
    base = 8;

  val.rep = Icopy_zero(val.rep);

  for (;;)
    {
      if (ch == EOF)
	break;
      int digit;
      if (ch >= '0' && ch <= '9')
	digit = ch - '0';
      else if (ch >= 'A' && ch <= 'F')
	digit = ch - 'A' + 10;
      else if (ch >= 'a' && ch <= 'f')
	digit = ch - 'a' + 10;
      else
	digit = 999;
      if (digit >= base)
	{
	  sb->sputbackc(ch);
	  if (ndigits == 0)
	    goto fail;
	  else
	    goto done;
	}
      ndigits++;
      switch (base)
	{
	case 8:
	  val <<= 3;
	  break;
	case 16:
	  val <<= 4;
	  break;
	default:
	  val *= base;
	  break;
	}
      val += digit;
      ch = sb->sbumpc();
    }
 fail:
  stream.setstate(ios::failbit);
 done:
  if (sign == '-')
    val.negate();
  return stream;
 eof_fail:
  stream.setstate(ios::failbit|ios::eofbit);
  return stream;
}

int Integer::OK() const
{
  if (rep != 0)
    {
      int l = rep->len;
      int s = rep->sgn;
      int v = l <= rep->sz || STATIC_IntRep(rep);    // length within bounds
      v &= s == 0 || s == 1;        // legal sign
      Icheck(rep);                  // and correctly adjusted
      v &= rep->len == l;
      v &= rep->sgn == s;
      if (v)
	  return v;
    }
  error("invariant failure");
  return 0;
}

void Integer::error(const char* msg) const
{
  (*lib_error_handler)("Integer", msg);
}

