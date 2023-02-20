// CreateNumber.h

#ifndef INCLUDED_CREATENUMBER_H
#define INCLUDED_CREATENUMBER_H

#include "Field.hpp"
#ifdef USE_V_FIELD
#include "RCountedPLocked.hpp"
#include "FieldRep.hpp"
class INTEGER;
class LINTEGER;
#include "IntegerChoice.hpp"
#include "FieldChoice.hpp"
#ifdef USE_MyInteger
#include "MyInteger.hpp"
#endif

FieldRep *  CreateNumber(int i,int j);
#ifdef USE_MyInteger
FieldRep * CreateNumber(const MyInteger &);
FieldRep * CreateNumber(const MyInteger &,const MyInteger &);
#endif
FieldRep * CreateNumber(const INTEGER &);
FieldRep * CreateNumber(const INTEGER &,const INTEGER &);
FieldRep * CreateNumber(const LINTEGER &);
FieldRep * CreateNumber(const LINTEGER &,const LINTEGER &);
#endif
#endif
