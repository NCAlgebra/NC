// CreateNumber.h

#ifndef INCLUDED_CREATENUMBER_H
#define INCLUDED_CREATENUMBER_H

#include "Field.hpp"
#ifdef USE_VIRT_FIELD
#include "FieldRep.hpp"
class INTEGER;
class LINTEGER;
#include "IntegerChoice.hpp"

FieldRep * CreateNumber(int i,int j);
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
