// simple2String.h

#ifndef INCLUDED_SIMPLESTRING_H
#define INCLUDED_SIMPLESTRING_H

class MyOstream;

class simpleString {
  const char *       d_s;
  int                d_len;
  static char *      s_empty_string;
public:
  simpleString() : d_s(0), d_len(0) {
    assign(s_empty_string); 
  };
  simpleString(const simpleString & x) : d_s(x.d_s),
    d_len(x.d_len) {};
  explicit simpleString(const char * s) : d_s(0), d_len(0) {
    assign(s);
  };
  void operator =(const char * x) {
    assign(x);
  };
  void operator =(const simpleString & x) {
    d_s=x.d_s;
    d_len=x.d_len;
  };
  ~simpleString() {};
  void assign(const simpleString & x) {
    d_s=x.d_s;
    d_len=x.d_len;
  };
  void assign(const char *);
  void reserve(int) {};
  bool operator ==(const simpleString & x) const {
    return d_s==x.d_s;
  };
  bool operator ==(const char *) const;
  bool operator<(const simpleString &) const;
  const char * chars() const { 
    return d_s;
  };
  int length() const { 
    return d_len; 
  };
  friend MyOstream & operator <<(MyOstream &,const simpleString &);
};
#endif
