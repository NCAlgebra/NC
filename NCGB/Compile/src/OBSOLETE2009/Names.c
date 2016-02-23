// Mark Stankus (c) 1999
// Names.cpp

#include "Names.hpp"
#include "GBStream.hpp"

Names::~Names(){};

map<const char *,Names *,charsless > * Names::s_poolname_to_prototype_p = 0;
map<const char *,Names *,charsless > Names::s_vars;

void Names::errorh(int n) {
  DBGH(n);
};

void Names::errorc(int n) {
  DBGC(n);
};

void AddPool::errorh(int n) {
  DBGH(n);
};

void AddPool::errorc(int n) {
  DBGC(n);
};

void Names::NoPoolError(const char * pool) {
  GBStream << "There is no pool with the name " << pool << '\n';
  errorc(__LINE__);
};

void Names::VarAlreadyError(const char * var) {
  GBStream << "There is already a variable with the name " << var << '\n';
  errorc(__LINE__);
};

void Names::s_error(MyOstream & os,const char * s,const char * pool) {
  os << "The element of the \"" << pool
     << "\" with the name \"" << s << "\" cannot be found.\n";
};

void Names::s_RemoveWarning(const char * var) {
  GBStream << "Could not remove pool variable name " << var << '\n';
};  

void Names::s_LookupError(const char * var,const char * pool) { 
  GBStream << "There is no variable with the name " << var 
           << " (looking for pool " << pool << ")\n";
  errorc(__LINE__);
};

void Names::s_ListNames(MyOstream & os,const char * first,
       const char * second,const char * sep) {
  os << first << " of type " << second << sep; 
};

void AddPool::s_AddPoolTwiceError(const char * x) {
  GBStream << "Trying to add the pool " << x << " twice.\n";
  errorc(__LINE__);
};
