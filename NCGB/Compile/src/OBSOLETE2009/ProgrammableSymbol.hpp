// (c) Mark Stankus 1999
// ProgrammableSymbol.h

#ifndef INCLUDED_PROGRAMMABLESYMBOL_H
#define INCLUDED_PROGRAMMABLESYMBOL_H

#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <map>
#else
#include <map.h>
#endif
#include "vcpp.hpp"
#include "simpleString.hpp"
#include "AuxilaryProgrammableSymbolData.hpp"

typedef map<simpleString,AuxilaryProgrammableSymbolData> TYPEINFO;
extern TYPEINFO d_type_info;
typedef map<simpleString,simpleString> NAME2TYPE;
extern NAME2TYPE d_name_to_type;

#endif
