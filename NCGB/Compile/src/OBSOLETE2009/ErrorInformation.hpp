// ErrorInformation.h

#ifndef INCLUDED_ERRORINFORMATION_H
#define INCLUDED_ERRORINFORMATION_H

class MyOstream;

struct ErrorInformation { 
  char * d_hint;
  void (*d_f)(void *,MyOstream &); 
  MyOstream * d_os;
};
#endif
