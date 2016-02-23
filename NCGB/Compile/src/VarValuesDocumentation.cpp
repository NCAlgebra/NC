// VarValuesDocumentation.c

#include "VarValuesDocumentation.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

extern void TextToTeX(MyOstream &,const char *);

VarValuesDocumentation::~VarValuesDocumentation() {};

VarValuesDocumentation::VarValuesDocumentation(
    char * doc,char * returnType,char * pdv,char * cpv)
   : d_p((TheFunctionSetUp *)0) {
  d_documentation_p = doc;
  d_returnType_p    = returnType;
  d_pdversion_p     = pdv;
  d_cpversion_p     = cpv;
};

#if 1
void VarValuesDocumentation::put(MyOstream &) {
  if(!d_p) DBG();
  DBG();
};
#else
void VarValuesDocumentation::put(MyOstream & os) {
  if(!d_p) DBG();
  os << "\\CommandEntry\n";
  os << "{" << d_p->d_name << "[";
  TextToTeX(os,d_p->d_argpattern);
  os  << "]}\n";
  os << "{None}\n";
  os << "{";
  TextToTeX(os,d_p->d_documentation);
  os << "}\n";
  os << "{" << d_p->d_vars << "}\n";
  os << "{";
  if(d_p->d_pdversion_p) {
    os << "PD version number:" << d_p->d_pdversion_p << ";  ";
  } else {
    os << "Not supported for PD;  ";
  };
  if(d_p->d_cpversion_p) {
    os << "CP version number:" << d_p->d_cpversion_p << "  ";
  } else {
    os << "Not supported for CP;  ";
  };
  os << "}\n";
  os << "\\labelindex{command:" << d_p->d_name << "}\n\n";
  if(d_p->d_why_obsolete) {
     os << "The above function is obsolete.\n";
     if(strlen(d_p->d_why_obsolete)==0) {
       os << "No suggestions for upgrading are givenobsolete.\n";
     } else {
       os << d_p->d_why_obsolete << '\n';
    };
  };
};
#endif

void VarValuesDocumentation::setPtr(void * p) { 
  d_p = (TheFunctionSetUp *)p;
};
