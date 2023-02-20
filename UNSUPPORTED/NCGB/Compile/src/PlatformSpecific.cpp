// PlatformSpecific.c

#include "PlatformSpecific.hpp"
#include "RecordHere.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <cstring>
#else
#include <string.h>
#endif

char * PlatformSpecific::s_GifDirectory = "../gif";
char * PlatformSpecific::s_GifDirectory2 = "../gif2";
#ifdef USE_UNIX
char * PlatformSpecific::s_Html_viewer = "netscape ";
char * PlatformSpecific::s_Dvi_viewer = "xdvi ";
char * PlatformSpecific::s_Latex_command = "latex ";
char * PlatformSpecific::s_Background = " & ";
#endif
#ifdef USE_VCPP
char * PlatformSpecific::s_Html_viewer = "\"c:\\Program Files\\Netscape\\Communicator\\Program\\netscape.exe\" ";
char * PlatformSpecific::s_Dvi_viewer = "\"c:\\windows\\desktop\\TeX and Such\\MikTeX\\MikTeX Updates\\YAP094C\\MIKTEX\\BIN\\yap.exe\" ";
char * PlatformSpecific::s_Latex_command = "latex ";
char * PlatformSpecific::s_Background = " ";
#endif
char * PlatformSpecific::s_Ascii_viewer = "cat ";
//char * PlatformSpecific::s_Background = "  ";

char * PlatformSpecific::s_Current_directory = "./";
char * PlatformSpecific::s_XML2TeX_Generator = 
           "../binary.ncgb/texspreadpagegenerator";
char * PlatformSpecific::s_XML2MiniTeX_Generator = 
           "../binary.ncgb/minitexspreadpagegenerator";
char * PlatformSpecific::s_XML2HTML_Generator = 
           "../binary.ncgb/htmlspreadpagegenerator";
char * PlatformSpecific::s_XML2MiniHTML_Generator = 
           "../binary.ncgb/minihtmlspreadpagegenerator";

const char * const PlatformSpecific::s_html_viewer() {
  return s_Html_viewer;
};

const char * const PlatformSpecific::s_dvi_viewer() {
  return s_Dvi_viewer;
};

const char * const PlatformSpecific::s_latex_command() {
  return s_Latex_command;
};

const char * const PlatformSpecific::s_ascii_viewer() {
  return s_Ascii_viewer;
};

const char * const PlatformSpecific::s_background() {
  return s_Background;
};

const char * const PlatformSpecific::s_current_directory() {
  return s_Current_directory;
};

void PlatformSpecific::s_gifDirectory(const char * const x)  {
  RECORDHERE(delete [] PlatformSpecific::s_GifDirectory;)
  const int sz = (int) strlen(x);
  RECORDHERE(PlatformSpecific::s_GifDirectory = new char[sz+1];)
  strcpy(PlatformSpecific::s_GifDirectory,x);
};

void PlatformSpecific::s_gifDirectory2(const char * const x)  {
  RECORDHERE(delete [] PlatformSpecific::s_GifDirectory2;)
  const int sz = (int) strlen(x);
  RECORDHERE(PlatformSpecific::s_GifDirectory2 = new char[sz+1];)
  strcpy(PlatformSpecific::s_GifDirectory2,x);
};

const char * const PlatformSpecific::s_gifDirectory() {
  return PlatformSpecific::s_GifDirectory;
};

const char * const PlatformSpecific::s_gifDirectory2() {
  return PlatformSpecific::s_GifDirectory2;
};

const char * const PlatformSpecific::s_XML2HTML_Executable() {
  return s_XML2HTML_Generator;   
};

const char * const PlatformSpecific::s_XML2MiniHTML_Executable() {
  return s_XML2MiniHTML_Generator;  
};

const char * const PlatformSpecific::s_XML2TeX_Executable() {
  return s_XML2TeX_Generator;  
};

const char * const PlatformSpecific::s_XML2MiniTeX_Executable() {
  return s_XML2MiniTeX_Generator;
};

#define AVERAGE_USER     0
#define DEVELOPER_USER   1

#define THIS_COMPILE     DEVELOPER_USER

const int  PlatformSpecific::s_default_user_level = THIS_COMPILE; 
