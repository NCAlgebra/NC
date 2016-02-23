// CreateNumber.c

#include "CreateNumber.hpp"
#include "RecordHere.hpp"
#include "Field.hpp"
#ifdef USE_V_FIELD
#include "tRational.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"
#include "MyInteger.hpp"

FieldRep * CreateNumber(int x,int y){
  FieldRep * p = (FieldRep *) 0;
  if(*Field::s_currentFieldNumber_p==tRational<INTEGER>::s_ID) {
    INTEGER X(x);
    INTEGER Y(y);
    RECORDHERE(p = new tRational<INTEGER>(X,Y);)
  } else if(*Field::s_currentFieldNumber_p==tRational<LINTEGER>::s_ID) {
    LINTEGER X(x);
    LINTEGER Y(y);
    RECORDHERE(p = new tRational<LINTEGER>(X,Y);)
#ifdef USE_MyInteger
  } else if(*Field::s_currentFieldNumber_p==tRational<MyInteger>::s_ID) {
    RECORDHERE(p = new tRational<MyInteger>(x);)
    (*p).divide(y);
#endif
  } else DBG();
  return p;
};

#ifdef USE_MyInteger
FieldRep * CreateNumber(const MyInteger & x) {
  FieldRep * p = (FieldRep *) 0;
  if(*Field::s_currentFieldNumber_p==tRational<INTEGER>::s_ID) {
    DBG();
    int temp = 0;
    RECORDHERE(p = new tRational<INTEGER>(temp);)
  } else if(*Field::s_currentFieldNumber_p==tRational<LINTEGER>::s_ID) {
    DBG();
    int temp = 0;
    RECORDHERE(p = new tRational<LINTEGER>(temp);)
  } else if(*Field::s_currentFieldNumber_p==tRational<MyInteger>::s_ID) {
    RECORDHERE(p = new tRational<MyInteger>(x);)
  } else DBG();
  return p;
};

FieldRep * CreateNumber(const MyInteger & x,
             const MyInteger & y) {
  FieldRep * p = (FieldRep *) 0;
  if(*Field::s_currentFieldNumber_p==tRational<INTEGER>::s_ID) {
    DBG();
    INTEGER first(0); // use x
    INTEGER second(1); // use y
  } else if(*Field::s_currentFieldNumber_p==tRational<LINTEGER>::s_ID) {
    DBG();
    INTEGER first(0); // use x
    INTEGER second(1); // use x
    RECORDHERE(p = new tRational<INTEGER>(first,second);)
  } else if(*Field::s_currentFieldNumber_p==tRational<MyInteger>::s_ID) {
    RECORDHERE(p = new tRational<MyInteger>(x,y);)
  } else DBG();
  return p;
};
#endif

FieldRep * CreateNumber(const INTEGER & x) {
  FieldRep * p = (FieldRep *) 0;
  if(*Field::s_currentFieldNumber_p==tRational<INTEGER>::s_ID) {
    RECORDHERE(p = new tRational<INTEGER>(x);)
  } else if(*Field::s_currentFieldNumber_p==tRational<LINTEGER>::s_ID) {
    RECORDHERE(p = new tRational<LINTEGER>(x.internal());)
#ifdef USE_MyInteger
  } else if(*Field::s_currentFieldNumber_p==
            tRational<MyInteger>::s_ID) {
    int temp = x.internal();
    RECORDHERE(p = new tRational<MyInteger>(temp);)
#endif
  } else DBG();
  return p;
};

FieldRep *  CreateNumber(const INTEGER & x,const INTEGER & y) {
  FieldRep * p = (FieldRep *) 0;
  if(*Field::s_currentFieldNumber_p==tRational<INTEGER>::s_ID) {
    RECORDHERE(p = new tRational<INTEGER>(x,y);)
  } else if(*Field::s_currentFieldNumber_p==tRational<LINTEGER>::s_ID) {
    RECORDHERE(p = new tRational<LINTEGER>(LINTEGER(x.internal()),
                                           LINTEGER(y.internal()));)
#ifdef USE_MyInteger
  } else if(*Field::s_currentFieldNumber_p==tRational<MyInteger>::s_ID) {
    DBG();
    MyInteger first(x.internal()); // use x
    MyInteger second(x.internal()); // use y
    RECORDHERE(p = new tRational<MyInteger>(first,second);)
#endif
  } else DBG();
  return p;

};

FieldRep * CreateNumber(const LINTEGER & x) {
  FieldRep * p = (FieldRep *) 0;
  if(*Field::s_currentFieldNumber_p==tRational<INTEGER>::s_ID) {
    RECORDHERE(p = new tRational<INTEGER>(x.internal());)
  } else if(*Field::s_currentFieldNumber_p==tRational<LINTEGER>::s_ID) {
    RECORDHERE(p = new tRational<LINTEGER>(x);)
#ifdef USE_MyInteger
  } else if(*Field::s_currentFieldNumber_p==tRational<MyInteger>::s_ID) {
    DBG();
    int temp = x.internal();
    RECORDHERE(p = new tRational<MyInteger>(temp);)
#endif
  } else DBG();
  return p;
};

#if 0
FieldRep * CreateNumber(const LINTEGER & x,const LINTEGER & y) {
  FieldRep * p = (FieldRep *) 0;
  if(*Field::s_currentFieldNumber_p==tRational<INTEGER>::s_ID) {
    RECORDHERE(p = new tRational<INTEGER>(x.internal(),y.internal());)
  } else if(*Field::s_currentFieldNumber_p==tRational<LINTEGER>::s_ID) {
    RECORDHERE(p = new tRational<LINTEGER>(x,y);)
#ifdef USE_MyInteger
  } else if(*Field::s_currentFieldNumber_p==tRational<MyInteger>::s_ID) {
    DBG();
    Integer first(x.internal());
    Integer second(x.internal());
    MyInteger First(first); // use x
    MyInteger Second(second); // use y
    RECORDHERE(p = new tRational<MyInteger>(First,Second);)
#endif
  } else DBG();
  return p;
};
#endif
#endif
