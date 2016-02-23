// UserOptions.h

#ifndef INCLUDED_USEROPTIONS_H
#define INCLUDED_USEROPTIONS_H

class VersionControl;

class UserOptions {
  static bool s_shouldStopForHighDegree;
  static int  s_stopForDegree;
  static bool s_cutOffs;
  static int  s_minNumber;
  static int  s_sumNumber;
  static bool s_Experimental;
  static VersionControl * s_versionControl_p;
public:
  static int  s_SelectionOutputMethod;
  static int  s_FactorySetting;
  static bool s_UseSubMatch;
  static bool s_TellMultiGradedLex;
  static bool s_recordHistory;
  static bool s_RecordHistoryReductions;
  static bool s_supressOutput; 
  static void s_SupressOutput(bool yn) {
    s_supressOutput = yn;
  };
  static bool s_supressAllCOutput;
  static void s_SupressAllCOutput(bool yn) {
    s_supressAllCOutput = yn;
  };
  static void s_experimental(bool);
  static bool s_experimental();
  static void s_setStopDegreeOff() {
    s_shouldStopForHighDegree = false; s_stopForDegree = 0;
  };
  static void s_setStopDegree(int n) {
    s_shouldStopForHighDegree = true; s_stopForDegree = n;
  };
  static bool s_StopDegreeOn() { return s_shouldStopForHighDegree;};
  static int  s_stopDegree() { return s_stopForDegree;};
  static void s_setMinSum(int M,int S) {
    s_cutOffs = true; s_minNumber = M; s_sumNumber = S;
  };
  static int s_MinNumber() { return s_minNumber;}
  static int s_SumNumber() { return s_sumNumber;}
  static void s_VersionNumber(float,const char * const);
  static float s_VersionNumber(const char * const);
  void reset();
};
#endif
