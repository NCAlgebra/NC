// (c) Mark Stankus 1999
// NCGBBuiltIn.c


#pragma warning(disable:4786)
#include "Source.hpp"
#include "Sink.hpp"
#include "stringGB.hpp"
#include "asStringGB.hpp"
#include "simpleString.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#include <algorithm>
#include "MapsBuiltIn.hpp"

void _SetBuiltInQuantity(Source & source,Sink & sink) {
  asStringGB name;
  Source p = source.inputNamedFunction("Rule");
  p >> name;
  bool done = false;
  if(!done) {
    map<simpleString,int ,less<simpleString>*>::const_iterator w1 = 
       s_string_to_int_pointer_p->find(name.value());
    if(w1!=s_string_to_int_pointer_p->end()) {
      int m;
      p >> m;
      *((*w1).second) = m;
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,bool *,less<simpleString> >::const_iterator w2 = 
       s_string_to_bool_pointer_p->find(name.value());
    if(w2!=s_string_to_bool_pointer_p->end()) {
      bool b;
      p >> b;
      *((*w2).second) = b;
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,pair<void(*)(int),int (*)()>,
        less<simpleString>  >::const_iterator w3 = 
          s_string_to_get_set_int_func_p->find(name.value());
    if(w3!=s_string_to_get_set_int_func_p->end()) {
      int m;
      p >> m;
      (*w3).second.first(m);
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,pair<void(*)(bool),bool (*)()>,less<simpleString> >::const_iterator 
       w4 = s_string_to_get_set_bool_func_p->find(name.value());
    if(w4!=s_string_to_get_set_bool_func_p->end()) {
      bool b;
      p >> b;
      (*w4).second.first(b);
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,bool*,less<simpleString> >::const_iterator 
       w5 = s_string_to_boolint_pointer_p->find(name.value());
    if(w5!=s_string_to_boolint_pointer_p->end()) {
      bool b = true;
      DBG();
      *(*w5).second = b; 
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,pair<void(*)(bool),bool (*)()>,
        less<simpleString>  >::const_iterator 
       w6 = s_string_to_get_set_boolint_func_p->find(name.value());
    if(w6!=s_string_to_get_set_boolint_func_p->end()) {
      bool b = true;
      DBG();
      (*w6).second.first(b); 
      done = true;
    };
  };
  if(!done) DBG(); 
  p.shouldBeEnd();
  source.shouldBeEnd();
  sink.noOutput();
};

void _ObtainBuiltInQuantity(Source & source,Sink & sink) {
  asStringGB name;
  source >> name;
  source.shouldBeEnd();
  bool done = false;
  if(!done) {
    map<simpleString,int *,less<simpleString> >::const_iterator w = 
       s_string_to_int_pointer_p->find(name.value());
    if(w!=s_string_to_int_pointer_p->end()) {
      sink << *(*w).second;
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,bool *,less<simpleString> >::const_iterator w = 
       s_string_to_bool_pointer_p->find(name.value());
    if(w!=s_string_to_bool_pointer_p->end()) {
      sink << *(*w).second;
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,pair<void(*)(int),int (*)()>,less<simpleString> >::const_iterator w3 = 
          s_string_to_get_set_int_func_p->find(name.value());
    if(w3!=s_string_to_get_set_int_func_p->end()) {
      sink << (*w3).second.second();
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,pair<void(*)(bool),bool (*)()>,
      less<simpleString> >::const_iterator 
       w4 = s_string_to_get_set_bool_func_p->find(name.value());
    if(w4!=s_string_to_get_set_bool_func_p->end()) {
      sink << (*w4).second.second();
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,bool*,less<simpleString> >::const_iterator 
       w5 = s_string_to_boolint_pointer_p->find(name.value());
    if(w5!=s_string_to_boolint_pointer_p->end()) {
      sink << *(*w5).second; 
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,pair<void(*)(bool),bool(*)()>,
        less<simpleString> >::const_iterator 
       w6 = s_string_to_get_set_boolint_func_p->find(name.value());
    if(w6!=s_string_to_get_set_boolint_func_p->end()) {
      sink << (*w6).second.second(); 
      done = true;
    };
  };
  if(!done) DBG();
};

void _PrintBuiltInQuantity(simpleString & name,MyOstream & os,bool LongForm = false) {
  bool done = false;
  if(LongForm) {
    os << "The value of the variable " << name.chars() << " is ";
  };
  if(!done) {
    map<simpleString,int *,less<simpleString> >::const_iterator w = 
       s_string_to_int_pointer_p->find(name);
    if(w!=s_string_to_int_pointer_p->end()) {
      os << *(*w).second;
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,bool *,less<simpleString> >::const_iterator w = 
       s_string_to_bool_pointer_p->find(name);
    if(w!=s_string_to_bool_pointer_p->end()) {
      os << *(*w).second;
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,pair<void(*)(int),int (*)()>,
        less<simpleString>  >::const_iterator w3 = 
          s_string_to_get_set_int_func_p->find(name);
    if(w3!=s_string_to_get_set_int_func_p->end()) {
      os << (*w3).second.second();
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,pair<void(*)(bool),bool (*)()>,
        less<simpleString> >::const_iterator 
       w4 = s_string_to_get_set_bool_func_p->find(name);
    if(w4!=s_string_to_get_set_bool_func_p->end()) {
      os << (*w4).second.second();
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,bool*,less<simpleString> >::const_iterator 
       w5 = s_string_to_boolint_pointer_p->find(name);
    if(w5!=s_string_to_boolint_pointer_p->end()) {
      os << *(*w5).second; 
      done = true;
    };
  };
  if(!done) { 
    map<simpleString,pair<void(*)(bool),bool (*)()>,
        less<simpleString>  >::const_iterator 
       w6 = s_string_to_get_set_boolint_func_p->find(name);
    if(w6!=s_string_to_get_set_boolint_func_p->end()) {
      os << (*w6).second.second(); 
      done = true;
    };
  };
  if(!done) DBG();
  if(LongForm) {
    os << ".\n";
  };
};

class PrintBuiltInHelper {
  MyOstream & d_os;
public:
  PrintBuiltInHelper(MyOstream & os) : d_os(os) {};
  void operator()(pair<const simpleString,int *> & x) {
    d_os << "The value of the variable " << x.first.chars() << " is ";
    d_os << *x.second;
    d_os << ".\n";
  };
  void operator()(pair<const simpleString,bool *> & x) {
    d_os << "The value of the variable " << x.first.chars() << " is ";
    d_os << *x.second;
    d_os << ".\n";
  };
  void operator()(pair<const simpleString,pair<void(*)(int),int(*)()> >  & x) {
    d_os << "The value of the variable " << x.first.chars() << " is ";
    d_os << x.second.second();
    d_os << ".\n";
  };
  void operator()(pair<const simpleString,pair<void(*)(bool),bool(*)()> > & x) {
    d_os << "The value of the variable " << x.first.chars() << " is ";
    d_os << x.second.second();
    d_os << ".\n";
  };
};

void _PrintBuiltInQuantity(MyOstream & os) {
  os << "          All built in quantities\n\n";
  PrintBuiltInHelper help(os);
  os << "The integers::\n";
  for_each(s_string_to_int_pointer_p->begin(),
           s_string_to_int_pointer_p->end(),
           help);
  for_each(s_string_to_get_set_int_func_p->begin(),
           s_string_to_get_set_int_func_p->end(),
           help);
  os << "The bools::\n";
  for_each(s_string_to_bool_pointer_p->begin(),
           s_string_to_bool_pointer_p->end(),
           help);
  for_each(s_string_to_get_set_bool_func_p->begin(),
           s_string_to_get_set_bool_func_p->end(),
           help);
  os << "The bools (can be input as boolean or integer ( false iff ==0).\n";
  for_each(s_string_to_boolint_pointer_p->begin(),
           s_string_to_boolint_pointer_p->end(),
           help);
  for_each(s_string_to_get_set_boolint_func_p->begin(),
           s_string_to_get_set_boolint_func_p->end(),
           help);
};
