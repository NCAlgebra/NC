// (c) Mark Stankus 1999
// MapBuiltIn.h

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#include "simpleString.hpp"
#include "vcpp.hpp"

extern map<simpleString,int *,less<simpleString> > * s_string_to_int_pointer_p;
extern map<simpleString,bool *,less<simpleString> > * s_string_to_bool_pointer_p;
extern map<simpleString,bool *,less<simpleString> > * s_string_to_boolint_pointer_p;
extern map<simpleString,pair<void(*)(int),int (*)()>, less<simpleString> >  *
      s_string_to_get_set_int_func_p;
extern map<simpleString,pair<void(*)(bool),bool (*)()>, less<simpleString> > *
      s_string_to_get_set_bool_func_p;
extern map<simpleString,pair<void(*)(bool),bool (*)()> ,less<simpleString> > *
      s_string_to_get_set_boolint_func_p;
