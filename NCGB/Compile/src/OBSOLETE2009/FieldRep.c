// FieldRep.c

#include "FieldRep.hpp"
#ifdef USE_VIRT_FIELD
#include "RecordHere.hpp"
#include "Debug1.hpp"

FieldRep::~FieldRep(){};
//#include "QFRep.hpp"
//#include "GNUQFRep.hpp"
#include "tRational.hpp"
#include "AltInteger.hpp"
#include "LINTEGER.hpp"
#include "Field.hpp"
#ifdef USE_MyInteger
#include "MyInteger.hpp"
#endif

void SwitchFields(int i) {
  if(i==1) {
    Field::s_currentFieldNumber_p = &tRational<INTEGER>::s_ID;
    RECORDHERE(delete Field::s_currentRep_p; )
    RECORDHERE(Field::s_currentRep_p = new tRational<INTEGER>(); )
  } else if(i==2) {
    Field::s_currentFieldNumber_p = &tRational<LINTEGER>::s_ID;
    RECORDHERE(delete Field::s_currentRep_p; )
    RECORDHERE(Field::s_currentRep_p = new tRational<LINTEGER>(); )
#ifdef USE_MyInteger
  } else  if(i==3) {
    Field::s_currentFieldNumber_p = &tRational<MyInteger>::s_ID;
    RECORDHERE(delete Field::s_currentRep_p; )
    RECORDHERE(Field::s_currentRep_p = new tRational<MyInteger>(); )
#endif
  } else DBG();
};

#include "Choice.hpp"
#ifdef USE_UNIX
#include "RCountedPLocked.c"
#else
#include "RCountedPLocked.cpp"
#endif
template class RCountedPLocked<FieldRep>;
#endif
