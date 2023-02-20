// OutputError.h

#ifndef INCLUDED_OUTPUTERROR_H
#define INCLUDED_OUTPUTERROR_H

class MyOstream;

#define ERROR(n) { OutputError::s_doit(GBStream,n,__FILE__,__LINE__);};
#define ERRORVOID(n,v) { OutputError::s_doit_void(v,GBStream,n,__FILE__,__LINE__);};

class OutputError {
  OutputError(const OutputError &);
    // not implemented
  void operator=(const OutputError &);
    // not implemented
public:
  OutputError() {};
  ~OutputError(){};

  static void s_doit(int);
  static void s_doit(int,const char * s,int n);
  static void s_doit(MyOstream &,int);
  static void s_doit(MyOstream &,int,const char * s,int n);
  static void s_doit_void(void *,int);
  static void s_doit_void(void *,int,const char * s,int n);
  static void s_doit_void(void *,MyOstream &,int);
  static void s_doit_void(void *,MyOstream &,int,const char * s,int n);
};
#endif
