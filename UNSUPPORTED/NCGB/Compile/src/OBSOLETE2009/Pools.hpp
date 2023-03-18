// Mark Stankus 1999 (c)
// Pools.hpp

#ifndef INCLUDED_POOLS_H
#define INCLUDED_POOLS_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#include "simpleString.hpp"
#include "MyOstream.hpp"
#include "Debug1.hpp"

using namespace std;

void PrintAllPools();

template<class T>
class Pools {
public:
  static const char * const s_poolname;
  typedef map<simpleString,T*,less<simpleString> > MAP;
  static MAP s_map;
  static T * s_lookup(const simpleString & s) { 
    T * result = (T *) 0;
    MAP::const_iterator w = s_map.find(s);
    if(w!=s_map.end()) result = (*w).second;
    return result;
  };
  static void s_error(MyOstream & os,const simpleString & s) {
    os << "The element of the \"" << s_poolname 
       << "\" with the name \"" << s << "\" cannot be found.\n";
  };
  static T * s_lookup_error(MyOstream & os,const simpleString & s) {
    T * result = s_lookup(s);
    if(!result) s_error(os,s);
    return result;
  };
  static void s_listNames(MyOstream & os,
         const char * sep = "\n",const char * sep2 = "\n") {
    MAP::const_iterator w = s_map.begin(), e = s_map.end();
    if(w!=e)  {
      --e;
      while(w!=e) {
        os << (*w).first << sep; 
        ++w;
      };
      os << (*w).first << sep2;
    };
  };
};

void AddDefaultToPool(const simpleString &,const simpleString &);
void RemoveFromPool(const simpleString &,const simpleString &);
void PrintNames(const simpleString &);

template<class T>
inline void AddDefaultToPool(const simpleString & name,T*) {
   pair<const simpleString,T*> pr(name,new T);
   Pools<T>::s_map.insert(pr);
};

template<class T>
inline void RemoveFromPool(const simpleString & name,T*) {
  map<simpleString,T*,less<simpleString> >::iterator w = 
      Pools<T>::s_map.find(name);
  if(w==Pools<T>::s_map.end()) {
    GBStream << "Could not remove the pool with name \""
             << Pools<T>::s_poolname << "\" and name \""
             << name << "\"\n";
  } else {  
    Pools<T>::s_map.erase(w);
  };  
};
#endif
