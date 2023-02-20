// Debug1.h 

#ifndef INCLUDED_DEBUG1_H 
#define INCLUDED_DEBUG1_H

class MyOstream;

//#define DBG() { Debug1::s_run_time_error();};
#define DBG() { Debug1::s_run_time_error(__FILE__,__LINE__);};
#define DBGH(line) { Debug1::s_run_time_error_h(__FILE__,line);};
#define DBGC(line) { Debug1::s_run_time_error_c(__FILE__,line);};
#define DBGHF(file,line) { Debug1::s_run_time_error_h(file,line);};
#define DBGCF(file,line) { Debug1::s_run_time_error_c(file,line);};

struct Debug1 {
  static void s_DebugSetUp(); 
  static void s_DebugInput();
  static void s_Pause();
  static void s_PauseBeforeCrash();
  static void s_ReportFunctionCalled();
  static void s_not_supported(const char *);
  static void s_not_supported();
  static void s_mail_to();
  static void s_mail_to_message_with();
  static void s_run_time_error();
  static void s_run_time_error(const char *,int);
  static void s_run_time_error_h(const char *,int);
  static void s_run_time_error_c(const char *,int);
  static void s_run_time_error(const char *,int,MyOstream&);
  static void s_run_time_error_h(const char *,int,MyOstream&);
  static void s_run_time_error_c(const char *,int,MyOstream&);
  static void s_setErrorFile();
  static void s_setTimingFile();

  static int s_INPUT_CHECKER_NUMBER;
  static int s_OUTPUT_CHECKER_NUMBER;
  static int s_CLEAN_INPUT_NUMBER;


  static int s_pause_before_crash;
  static int s_pause_set_up;
  static bool s_PrintAllFunctionNames;
  static bool s_RecordCommandNumbers;
  static bool s_DebugDisown;
  static bool s_NoGdb;
  static bool s_PrintOutAllInputs;
  static bool s_PrintOutAllOutputs;
  static const char * s_FunctionNameOne;
  static const char * s_FunctionNameTwo;
  static char * s_binary_name;
  static char * s_ps_command;
  static char * s_debuger_name;
  static char * s_mail_to_person;
  static char * s_ErrorFileName_p;
  static char * s_TimingFileName_p;
  static void (*s_before_crash)();
};
#endif
