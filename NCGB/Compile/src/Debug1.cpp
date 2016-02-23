// Debug1.c

#include "Debug1.hpp"
#include "GBStream.hpp"
#include "StartEnd.hpp"
#ifndef INCLUDED_TEMPLATES_H
#include "templates.hpp"
#endif
#ifndef INCLUDED_DEBUG2_H
#include "Debug2.hpp"
#endif
#ifndef INCLUDED_STDLIB_H
#define INCLUDED_STDLIB_H
#include <stdlib.h>
#endif
#include "compiler_specific.hpp"
/*
#ifdef USE_UNIX
#include <unistd.h>
#endif
*/
#include "ncgbofstream.hpp"
#include "MyOstream.hpp"

void Debug1::s_setErrorFile() {
  // Nothing here --- is obsolete
};

void Debug1::s_setTimingFile() {
  // Nothing here --- is obsolete
};

void Debug1::s_DebugSetUp() {
  s_DebugInput();
};

void Debug1::s_DebugInput() {
#ifdef TEMPLTE_OK
  Debug2::s_DebugDisownGBVector.reserve(10);
#endif
};

void Debug1::s_Pause() {
  if(s_pause_set_up>0) {
    GBStream << "Going to pause for " << s_pause_set_up << " seconds.\n";
    SLEEP(s_pause_set_up);
    GBStream << "Done pausing for " << s_pause_set_up << " seconds.\n";
  };
};

void Debug1::s_ReportFunctionCalled() {
 if(s_FunctionNameOne) {
    GBStream << "In the function " << s_FunctionNameOne << ".\n";
    if(s_FunctionNameTwo) {
      GBStream << "With part " << s_FunctionNameTwo << ".\n";
    };
  } else {
    GBStream << "The function name is not avaialable.\n";
  };
};

void Debug1::s_PauseBeforeCrash() {
  AddingCrash::s_execute();
  s_ReportFunctionCalled();
  if(Debug1::s_before_crash) {
     Debug1::s_before_crash();
  };
  if(s_NoGdb && s_pause_before_crash>0) {
    GBStream << "The program is going to 'sleep' for two minutes"
             << " to give you a chance to start the debugger"
             << " by typing \n" << s_debuger_name << "###" << s_binary_name 
             << "\n where ### is replaced by the process-id(below).\n";
    system(s_ps_command);
    SLEEP(s_pause_before_crash);
  };
  GBStream.flush();
  int m=0;
  m=1/m;
};

const char * s_CompileTime = __TIME__;
const char * s_CompileDate = __DATE__;

void DebugHelper(const char * fileName,int lineNo,MyOstream & os) {
  os << "***Error in file " << fileName << " on line number "
     << lineNo  << ".\n";
  os << "By the way, your version of the code was compiled at "
     << s_CompileTime << " on the day " << s_CompileDate << ".\n";
};

void DebugHelperH(const char * fileName,int lineNo,MyOstream & os) {
  os << "***Error in HEADER file " << fileName << " on line number "
     << lineNo  << ".\n";
  os << "By the way, your version of the code was compiled at "
     << s_CompileTime << " on the day " << s_CompileDate << ".\n";
};

void DebugHelperC(const char * fileName,int lineNo,MyOstream & os) {
  os << "***Error in file " << fileName << " on line number "
     << lineNo  << ".\n";
  os << "By the way, your version of the code was compiled at "
     << s_CompileTime << " on the day " << s_CompileDate << ".\n";
};

void Debug1::s_run_time_error(const char * fileName,const int lineNo,MyOstream & os) {
  DebugHelper(fileName,lineNo,os);
  Debug1::s_PauseBeforeCrash();
};

void Debug1::s_run_time_error_h(const char * fileName,const int lineNo,MyOstream & os) {
  DebugHelperH(fileName,lineNo,os);
  Debug1::s_PauseBeforeCrash();
};

void Debug1::s_run_time_error_c(const char * fileName,const int lineNo,MyOstream & os) {
  DebugHelperC(fileName,lineNo,os);
  Debug1::s_PauseBeforeCrash();
};
 
void Debug1::s_run_time_error(const char * fileName,const int lineNo) {
  s_run_time_error(fileName,lineNo,GBStream);
};

void Debug1::s_run_time_error_h(const char * fileName,const int lineNo) {
  s_run_time_error_h(fileName,lineNo,GBStream);
};

void Debug1::s_run_time_error_c(const char * fileName,const int lineNo) {
  s_run_time_error_c(fileName,lineNo,GBStream);
};

void Debug1::s_run_time_error() {
  s_run_time_error("Not recorded",-999,GBStream);
};
 
void Debug1::s_mail_to_message_with() {
  GBStream  << "Please send e-mail to " << s_mail_to_person << '\n';
  GBStream << "With the following information\n";
};
 
void Debug1::s_mail_to() {
  GBStream  << "Please send e-mail to mstankus@calpoly.edu\n";
};

void Debug1::s_not_supported(const char  * s) {
  for(int i=1;i<=10;++i) {
    GBStream << s << " not supported in this binary!\n\n";
  };
  s_mail_to();
  s_ReportFunctionCalled();
  DBG();
};

void Debug1::s_not_supported() { Debug1::s_not_supported("");};

int         Debug1::s_pause_before_crash = 0;
bool        Debug1::s_RecordCommandNumbers= false;
bool        Debug1::s_DebugDisown = true;
bool        Debug1::s_NoGdb = true;
//int         Debug1::s_pause_set_up = 60;
int         Debug1::s_pause_set_up = 0;

// The following two char * 's point to static char *'s in memory
// malloc, new, delete will NEVER be called with them!!!
const char * Debug1::s_FunctionNameOne = 0;
const char * Debug1::s_FunctionNameTwo = 0;

char * Debug1::s_binary_name = "p9c";
char * Debug1::s_ps_command  = "ps | grep p9c";
char * Debug1::s_mail_to_person = "mstankus@calpoly.edu";
char * Debug1::s_debuger_name = "gdb";
char * Debug1::s_ErrorFileName_p = "p9c_error_file";
char * Debug1::s_TimingFileName_p = "p9c_timing_file";

bool Debug1::s_PrintOutAllInputs = false;
bool Debug1::s_PrintOutAllOutputs = false;
bool Debug1::s_PrintAllFunctionNames = false;
//bool Debug1::s_PrintAllFunctionNames = true;

int Debug1::s_INPUT_CHECKER_NUMBER = 0;
int Debug1::s_OUTPUT_CHECKER_NUMBER = 0;
int Debug1::s_CLEAN_INPUT_NUMBER = 0;
void (*Debug1::s_before_crash)() = 0;
