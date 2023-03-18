// idValue.h

#ifndef INCLUDED_IDVALUE_H
#define INCLUDED_IDVALUE_H

class simpleString;

void idValuePrepareFor(int);
int idValue(simpleString * &);
int idValue(const char *);
const char * idString(int);
int numberOfIdStrings();
#endif
