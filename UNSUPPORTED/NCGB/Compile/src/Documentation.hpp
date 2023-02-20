// Documentation.h

#ifndef INCLUDED_DOCUMENTATION_H
#define INCLUDED_DOCUMENTATION_H

class MyOstream;

class Documentation {
public:
  Documentation() :  d_documentation_p((char * const)0),
     d_returnType_p((char * const) 0), d_pdversion_p((char * const) 0),
     d_cpversion_p((char * const) 0) {};
  virtual ~Documentation();
  virtual void put(MyOstream & os);
  virtual void setPtr(void * p);
protected:
  char * d_documentation_p;
  char * d_returnType_p;
  char * d_pdversion_p;
  char * d_cpversion_p;
};
#endif
