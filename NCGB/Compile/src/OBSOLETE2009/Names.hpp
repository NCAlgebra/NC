// Mark Stankus 1999 (c)
// Names.hpp

#ifndef INCLUDED_NAMES_H
#define INCLUDED_NAMES_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#include "charsless.hpp"
#include "MyOstream.hpp"
#include "Source.hpp"

using namespace std;

class Names {
  static void s_RemoveWarning(const char * var);
  static void s_LookupError(const char * var,const char * pool); 
  static void s_ListNames(MyOstream & os,const char * first,
       const char * second,const char * sep);
  static void NoPoolError(const char *);
  static void VarAlreadyError(const char *);
  friend class AddPool;
  static map<const char *,Names *,charsless > * s_poolname_to_prototype_p;
  static map<const char *,Names *,charsless > s_vars;
  typedef map<const char *,Names *,charsless >::iterator MI;
  typedef map<const char *,Names *,charsless >::const_iterator MCI;
protected:
   Names() {};
public:
  virtual ~Names() = 0;
  virtual const char * poolname() const = 0;
  virtual Names * prototype() const  = 0;
  virtual Names * create(Source &) const  = 0;
  static void errorh(int);
  static void errorc(int);
  struct PoolVoid {
    PoolVoid() : d_ptr(0) {};
    bool null() const { return !d_ptr;};
    void * ptr() const {
      if(!this) errorh(__LINE__);
      return d_ptr;
    };
    void ptr(void * ptr) { d_ptr = ptr;};
  private:
    void * d_ptr;
  };
  virtual PoolVoid getPointer() = 0;
  static void s_add(const char * var,const char * pool) {
    char * s = new char[strlen(var)+1];
    strcpy(s,var);
    MI w = s_poolname_to_prototype_p->find(pool);
    if(w==s_poolname_to_prototype_p->end()){
      NoPoolError(pool);
    };
    if(s_vars.find(var)!=s_vars.end()) {
      VarAlreadyError(var);
    };
    Names * p = (*w).second;
    p = p->prototype();
    pair<const char *,Names *> pr(s,p);
    s_vars.insert(pr);
  };
  static void a_add_source(const char * var,const char * pool,Source & so) {
    char * s = new char[strlen(var)+1];
    strcpy(s,var);
    MI w = s_poolname_to_prototype_p->find(pool);
    if(w==s_poolname_to_prototype_p->end()) {
      NoPoolError(pool);
    };
    if(s_vars.find(var)!=s_vars.end()) {
      VarAlreadyError(var);
    }
    Names * p = (*w).second->create(so);
    pair<const char *,Names *> pr(s,p);
    s_vars.insert(pr);
  };
  static void s_add(const char * var,Names * name) {
    char * s = new char[strlen(var)+1];
    strcpy(s,var);
    if(s_vars.find(var)!=s_vars.end()) {
      VarAlreadyError(var);
    }
    pair<const char *,Names *> pr(s,name);
    s_vars.insert(pr);
  };
  static void s_remove(const char * var) {
    MI w  = s_vars.find(var);
    if(w==s_vars.end()) {
      s_RemoveWarning(var);
    } else {
      delete [] (*w).first;
      delete (*w).second;
      s_vars.erase(w);
    };  
  };  
  static PoolVoid s_lookup(const char * var,const char * pool) { 
    MI f = s_vars.find(var); 
    if(f==s_vars.end()) {
      s_LookupError(var,pool); 
     };
    return (*f).second->getPointer();
  };
  static void s_error(MyOstream & os,const char * s,const char * pool);
  static PoolVoid s_lookup_error(MyOstream & os,
                                 const char * s,const char * pool) {
    PoolVoid result = s_lookup(s,pool);
    if(result.null()) s_error(os,s,pool);
    return result;
  };
  static void s_listNames(MyOstream & os,
         const char * sep = "\n",const char * sep2 = "\n") {
    MI w =  s_vars.begin(), e = s_vars.end();
    if(w!=e)  {
      --e;
      while(w!=e) {
        s_ListNames(os,(*w).first,(*w).second->poolname(),sep);
        ++w;
      };
      s_ListNames(os,(*w).first,(*w).second->poolname(),sep2);
    };
  };
  static void s_listPool(MyOstream & os,const char * poolname,
         const char * sep = "\n") {
    bool first = true;
    MI w =  s_vars.begin(), e = s_vars.end();
    while(w!=e)  {
      const pair<const char *,Names *> & pr = *w;
      if(strcmp(pr.second->poolname(),poolname)==0) {
        if(!first) os << sep; 
        os << (*w).first << sep; 
        first = false;
      }; 
      ++w;
    };
  };
  static void s_listPools(MyOstream & os,
         const char * sep = "\n",const char * sep2 = "\n") {
    MI w =  s_poolname_to_prototype_p->begin(), e=s_poolname_to_prototype_p->end();
    if(w!=e)  {
      --e;
      while(w!=e) {
        os << (*w).second->poolname() << sep; 
        ++w;
      };
      os << (*w).second->poolname() << sep2; 
    };
  };
};

struct AddPool {
  static void s_AddPoolTwiceError(const char * x);
  static void errorh(int);
  static void errorc(int);
  AddPool(const char * x,Names * name) {
    if(!Names::s_poolname_to_prototype_p) {
      Names::s_poolname_to_prototype_p = new map<const char *,Names *,charsless>;
    };
    char * s = new char[strlen(x)+1];
    strcpy(s,x);
    typedef map<const char *,Names *,charsless >::iterator MI;
    MI f = Names::s_poolname_to_prototype_p->find(x);
    MI e = Names::s_poolname_to_prototype_p->end();
    if(f!=e) {
       s_AddPoolTwiceError(x);
    };
    pair<const char * ,Names *> pr(s,name);
    Names::s_poolname_to_prototype_p->insert(pr);
  };
  ~AddPool() {};
};
#endif
