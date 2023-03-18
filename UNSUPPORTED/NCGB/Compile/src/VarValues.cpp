// VarValues.c

#include "VarValues.hpp"
#include "GBInputNumbers.hpp"
#include "Debug1.hpp"
#include "symbolGB.hpp"
#include "Source.hpp"
#include "Sink.hpp"

VarValues::~VarValues(){};

template<class T,class ID>
AddrVarValues<T,ID>::~AddrVarValues(){};

template<class T,class ID>
void AddrVarValues<T,ID>::set(Source & so) {
  so >> *d_value_p;
};

template<class T,class ID>
void AddrVarValues<T,ID>::get(Sink & si) {
  si << *d_value_p;
};

template<class T,class ID>
FuncVarValues<T,ID>::~FuncVarValues(){};

template<class T,class ID>
void FuncVarValues<T,ID>::set(Source & so) {
  T t;
  so >> t;
  f_set(t);
};

template<class T,class ID>
void FuncVarValues<T,ID>::get(Sink & si) {
  si << f_get();
};

BoolOrIntToInt::~BoolOrIntToInt()  {};

void BoolOrIntToInt::set(Source & so) {
  int t = so.getType();
  if(isSymbol(t)) {
    symbolGB x;
    so >> x;
    if(x=="True") {
      d_x = true;
    } else if(x=="False") {
      d_x = false;
    } else DBG();
  } else if(isInteger(t)) {
    so >> t;
    d_x = t!=0;
  } else DBG();
};

void BoolOrIntToInt::get(Sink & si) {
  int n = d_x ? 1 : 0;
  si << n;
};

#include "idValue.hpp"
const int BoolOrIntToInt::s_ID = idValue("BoolOrIntToInt::s_ID");

template class AddrVarValues<int,int_ID>;
template class AddrVarValues<bool,bool_ID>;
template class FuncVarValues<int,int_ID>;
template class FuncVarValues<bool,bool_ID>;
