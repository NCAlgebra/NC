// (c) Mark Stankus 1999
// MyOstream.c

#include "MyOstream.hpp"
#include "Debug1.hpp"
#include "ItoString.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#else
#include <fstream.h>
#endif

#if 0
void MyOstream::slowprint(const char * x) {
  const char * y = x;
  while(y!='\0') {
    slowprint(y); 
    ++y;
  };
};

void MyOstream::slowprint(char x[]) {
  const char * y = x;
  while(y!='\0') {
    slowprint(y); 
    ++y;
  };
};
#endif

void MyOstream::swapfiles(const char * extension,const char * base,int i) {
  char * thefilename = UniformStringThenInt(base,i,3);
  ofstream * ofs_p = new ofstream(thefilename);
  delete [] thefilename;
  if(&getostream()!=&cerr)  {
    char * prevfilename = UniformStringThenInt(extension,i-2,3);
    char * nextfilename = UniformStringThenInt(extension,i,3);
    if(i!=1) {
      (*this) << "\n<br><hr>\n<a href=\"" << prevfilename << "\">";
      (*this) << "previous\n";
      (*this) << "</a>";
    };
    (*this) << "\n<br>\n<a href=\"" << nextfilename << "\">";
    (*this) << "next\n";
    (*this) << "</a>";
    (*this)  << "</body></html>\n";
    ((ofstream &)getostream()).close();
    delete (& getostream());
    delete [] prevfilename;
    delete [] nextfilename;
  };
  swap(*ofs_p);
  (*this) << "<html><body>\n";
};

void MyOstream::errorh(int line) {
  DBGH(line);
};

void MyOstream::errorc(int line) {
  DBGC(line);
};

#include "idValue.hpp"
const int MyOstream::s_ID = idValue("MyOstream::s_ID");

#include "Choice.hpp"
#include "SimpleTable.cpp"
template class SimpleTable<MyOstream>;
SimpleTable<MyOstream> MyOstream::s_table;
#ifdef OLD_GCC
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
template class vector<pair<int,void(*)(MyOstream&,Holder&)> >;
template class vector<pair<int,void(*)(MyOstream&,const Holder&)> >;
#endif
