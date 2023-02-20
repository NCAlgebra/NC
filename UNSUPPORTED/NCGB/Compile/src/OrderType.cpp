// OrderType.c

#include "OrderType.hpp"


#ifndef INCLUDED_IDVALUE_H
#include "idValue.hpp"
#endif
int OrderType::s_UseMultiLexOrder = idValue("OrderType::s_UseMultiLexOrder");
int OrderType::s_UseMLex = idValue("OrderType::s_UseMLex");
int OrderType::s_Current = OrderType::s_UseMLex;
