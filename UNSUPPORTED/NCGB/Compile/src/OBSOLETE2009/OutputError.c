// OutputError.c

#include "OutputError.hpp"
#include "ErrorInformation.hpp"
#include "SetUpErrorInformation.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

void OutputError::s_doit(int e) {
  ErrorInformation & p = s_allErrors_p[e]; 
  p.d_f((void *)0,*p.d_os);
};

void OutputError::s_doit(int e,const char * s,int n) {
  s_doit(e);
  Debug1::s_run_time_error(s,n);
};

void OutputError::s_doit(MyOstream & os,int e) {
  ErrorInformation & p = s_allErrors_p[e]; 
  p.d_f((void *)0,os);
};

void OutputError::s_doit(MyOstream & os,int e,const char * s,int n) {
  s_doit(os,e);
  Debug1::s_run_time_error(s,n);
};

void OutputError::s_doit_void(void * v,int e) {
  ErrorInformation & p = s_allErrors_p[e]; 
  p.d_f(v,*p.d_os);
};

void OutputError::s_doit_void(void * v,int e,const char * s,int n) {
  s_doit_void(v,e);
  Debug1::s_run_time_error(s,n);
};

void OutputError::s_doit_void(void * v,MyOstream & os,int e) {
  ErrorInformation & p = s_allErrors_p[e]; 
  p.d_f(v,os);
};

void OutputError::s_doit_void(void * v,MyOstream & os,int e,const char * s,int n) {
  s_doit_void(v,os,e);
  Debug1::s_run_time_error(s,n);
};
