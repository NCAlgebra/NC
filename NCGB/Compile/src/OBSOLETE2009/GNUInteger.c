//  GNUInteger.c

#include "GNUInteger.hpp"
#include <stdlib.h>
#if 0
extern "C" {
//#include <stdio.h>
//#include <stdlib.h>
/* Convert a string to an integer.  */
extern int atoi __P ((__const char *__nptr));
/* Convert a string to a long integer.  */
extern long int atol __P ((__const char *__nptr));

#ifndef __CONSTVALUE
#ifdef  __GNUC__
/* The `const' keyword tells GCC that a function's return value
is
   based solely on its arguments, and there are no side-effects.
*/
#define __CONSTVALUE    __const
#else
#define __CONSTVALUE
#endif /* GCC.  */
#endif /* __CONSTVALUE not defined.  */
 
/* Return the absolute value of X.  */
extern __CONSTVALUE int abs __P ((int __x));
extern __CONSTVALUE long int labs __P ((long int __x));
};
#endif

//#include "GBList.hpp"
//#include "GBString.hpp"

/*
 * Class Integer function definitions
 *
 */
#if 0
void 
Integer::toStringAux(GBList<GBString> & aList) const
{
  GBString s;

  if (num == 0)
  { 
    s = "0";
  }
  else 
  {
    s= "";
    AppendItoString(num,s);
  }
  aList.addElement(s);
};
#endif


#ifdef fast 
Integer * Integer::nfree = 0;

void * Integer::operator new(size_t)
{
  register Integer *p = nfree;
  if (p)
  {
    nfree = p->next;
  }
  else
  {
    Integer * q = (Integer *)new char[NALL*sizeof(Integer) ];
    nfree=&q[NALL-1];
    p=nfree;
    for(;q<p;p--) 
    {
      p->next = p-1;
    }
    (p+1)->next = 0;
  }
  return p;
};

void Integer::operator delete(void * p,size_t)
{
  ((Integer*)p)->next = nfree;
  nfree = (Integer*) p;
};
#endif

#ifdef USEoks
BOOL
Integer::OK() const
{
  return TRUE;
};
#endif

