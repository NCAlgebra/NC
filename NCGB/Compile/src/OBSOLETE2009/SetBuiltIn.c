// (c) Mark Stankus 1999
// SetBuiltIn.c

#include "SetBuiltIn.hpp"

#include "MapsBuiltIn.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#include "vcpp.hpp"

SetBuiltIn::SetBuiltIn(const char * s,int * p) {
  if(!s_string_to_int_pointer_p) {
    s_string_to_int_pointer_p = new map<simpleString,int *,less<simpleString> >;
  };
  s_string_to_int_pointer_p->insert(make_pair(simpleString(s),p));
};

SetBuiltIn::SetBuiltIn(const char * s,bool * p) {
  if(!s_string_to_bool_pointer_p) {
    s_string_to_bool_pointer_p = new map<simpleString,bool*,less<simpleString> >;
  };
  s_string_to_bool_pointer_p->insert(make_pair(simpleString(s),p));
};

SetBuiltIn::SetBuiltIn(const char * s,int (*get)(),void (*set)(int)) {
  if(!s_string_to_get_set_int_func_p) {
    s_string_to_get_set_int_func_p = new 
        map<simpleString,pair<void(*)(int),int (*)()>,less<simpleString> >; 
  };
  s_string_to_get_set_int_func_p->insert(
      make_pair(simpleString(s),make_pair(set,get)));
};

SetBuiltIn::SetBuiltIn(const char * s,bool (*get)(),void (*set)(bool)) {
  if(!s_string_to_get_set_bool_func_p) {
    s_string_to_get_set_bool_func_p = new 
        map<simpleString,pair<void(*)(bool),bool (*)()>,less<simpleString> >; 
  };
  s_string_to_get_set_bool_func_p->insert(
      make_pair(simpleString(s),make_pair(set,get)));
};
