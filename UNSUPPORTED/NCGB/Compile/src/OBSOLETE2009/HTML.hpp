// Mark Stankus 1999 (c)
// HTML.hpp

#ifndef INCLUDED_HTML_H
#define INCLUDED_HTML_H

#include "MyOstream.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif

class HTML {
protected:
  HTML() {};
  static void errorh(int);
  static void errorc(int);
public:
  virtual ~HTML() = 0;
  virtual void print(MyOstream & os) const = 0;
};

class HTMLTable : public HTML {
  vector<vector<HTML*> > d_entries;
  bool d_border;
public:
  HTMLTable(bool border) : d_border(border) {};
  virtual ~HTMLTable();
  virtual void add(HTML*,int row,int col);
  virtual void print(MyOstream & os) const;
};

class HTMLTag : public HTML {
  HTML * d_p;
  char * d_begin;
  char * d_end;
public:
  HTMLTag(const char * common,HTML * p) : d_p(p) {
    int len = strlen(common);
    d_begin = new char[len+3];
    d_end = new char[len+4];
    strcpy(d_begin,"<");
    strcat(d_begin,common);
    strcat(d_begin,">");
    strcpy(d_end,"</");
    strcat(d_end,common);
    strcat(d_end,">");
  };
  HTMLTag(const char * begin,const char * end,HTML * p) : d_p(p) {
    int blen = strlen(begin);
    int elen = strlen(end);
    d_begin = new char[blen+3];
    d_end = new char[elen+4];
    strcpy(d_begin,"<");
    strcat(d_begin,begin);
    strcat(d_begin,">");
    strcpy(d_end,"</");
    strcat(d_end,end);
    strcat(d_end,">");
  };
  virtual ~HTMLTag();
  virtual void print(MyOstream & os) const;
};

class HTMLVerbatim : public HTML {
  char * d_s;
public:
  HTMLVerbatim(const char * s) : d_s(new char[strlen(s)+1]) { strcpy(d_s,s);};
  virtual ~HTMLVerbatim();
  virtual void print(MyOstream & os) const;
};

class HTMLInteger : public HTML {
  int d_n;
public:
  HTMLInteger(int n) : d_n(n){};
  virtual ~HTMLInteger();
  virtual void print(MyOstream & os) const;
};

class HTMLColor : public HTML {
  char * d_color_p;
  HTML * d_html_p;
public:
  HTMLColor(const char * c,HTML * p) : HTML(), d_html_p(p) {
    if(c) errorh(__LINE__);
    d_color_p = new char[strlen(c)+1];
    strcpy(d_color_p,c); 
    if(p) errorh(__LINE__);
  };
  virtual ~HTMLColor();
  const char * color() const { return d_color_p; };
  virtual void print(MyOstream & os) const;
};
#endif
