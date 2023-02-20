// PlatformSpecific.h

#ifndef INCLUDED_PLATFORMSPECIFIC_H
#define INCLUDED_PLATFORMSPECIFIC_H

class PlatformSpecific {
    // s_GifDirectory holds the "built-in" gifs.
    // The directory has probably been set up by the
    // system administrator. The user needs to have
    // read access, but not right access.
  static char * s_GifDirectory;
    // s_GifDirectory2 holds the "new" gifs.
    // The directory has probably been set up by the
    // the user. The user needs to have
    // read access, but not right access.
  static char * s_GifDirectory2;
  static char * s_Html_viewer;
  static char * s_Dvi_viewer;
  static char * s_Latex_command;
  static char * s_Ascii_viewer;
  static char * s_Background;
  static char * s_Current_directory;
  static char * s_XML2TeX_Generator; 
  static char * s_XML2MiniTeX_Generator; 
  static char * s_XML2HTML_Generator; 
  static char * s_XML2MiniHTML_Generator; 
public:
    // see above for s_Gif*y vs. s_Gif*y2
  static void s_gifDirectory(const char * const);
  static void s_gifDirectory2(const char * const);
  static const char * const s_gifDirectory();
  static const char * const s_gifDirectory2();
  static const char * const s_html_viewer();
  static const char * const s_dvi_viewer();
  static const char * const s_latex_command();
  static const char * const s_ascii_viewer();
  static const char * const s_background();
  static const char * const s_current_directory();
  static const char * const s_XML2HTML_Executable();
  static const char * const s_XML2MiniHTML_Executable();
  static const char * const s_XML2TeX_Executable();
  static const char * const s_XML2MiniTeX_Executable();
  static const int  s_default_user_level;
};
#endif
