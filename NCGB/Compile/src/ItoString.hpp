// IToString.h

#ifndef INCLUDED_ITOSTRING_H
#define INCLUDED_ITOSTRING_H

void ItoString(int i,char *  &);
char * StringThenInt(const char *,int);
char * UniformStringThenInt(const char *,int,int numdigits);
  // The above function deletes a pointer and fills it with a 
  // character string version of the integer. It DOES NOT append.
void AppendItoStringHelper(int i,char * p);

#endif
