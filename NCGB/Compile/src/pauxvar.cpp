// p11c_aux_var.c

#ifndef INCLUDED_GBIO_H
#include "GBIO.hpp"
#endif
#include "Source.hpp"
#include "Sink.hpp"
#include "symbolGB.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#ifndef INCLUDED_USEROPTIONS_H
#include "UserOptions.hpp"
#endif
#include "Command.hpp"
#include "Choice.hpp"
#ifndef INCLUDED_CSTRING_H
#define INCLUDED_CSTRING_H
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif
#endif

// ------------------------------------------------------------------

void _SetRecordHistory(Source & so,Sink & si) {
  int type = so.getType();
  if(isInteger(type)) { 
    int i;
    so >> i;
    UserOptions::s_recordHistory = i!=0;
  } else if(isSymbol(type)) {
    symbolGB x;
    so >> x;
    if(x=="True") {
      UserOptions::s_recordHistory = 1;
    } else if(x=="False") {
      UserOptions::s_recordHistory = 0;
    } else DBG();
  } else DBG();
  so.shouldBeEnd();
  si.noOutput();
};

AddingCommand temp1pauxvar("SetRecordHistory",1,_SetRecordHistory);

// ------------------------------------------------------------------

void _RecordHistoryQ(Source & so,Sink & si) {
  so.shouldBeEnd();
  GBOutputTrueFalse(UserOptions::s_recordHistory,si);
};

AddingCommand temp2pauxvar("RecordHistoryQ",0,_RecordHistoryQ);
