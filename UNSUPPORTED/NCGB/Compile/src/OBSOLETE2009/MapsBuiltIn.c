// (c) Mark Stankus 1999
// MapBuiltIn.c

#include "MapsBuiltIn.hpp"

map<simpleString,int *> * s_string_to_int_pointer_p = 0;
map<simpleString,bool *> * s_string_to_bool_pointer_p = 0;
map<simpleString,bool *> * s_string_to_boolint_pointer_p = 0;
map<simpleString,pair<void(*)(int),int (*)()> > * 
      s_string_to_get_set_int_func_p = 0;
map<simpleString,pair<void(*)(bool),bool (*)()> > * 
      s_string_to_get_set_bool_func_p = 0;
map<simpleString,pair<void(*)(bool),bool (*)()> > * 
      s_string_to_get_set_boolint_func_p = 0;
