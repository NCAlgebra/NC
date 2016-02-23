// simpleString.h

#ifndef INCLUDED_SIMPLESTRING_H
#define INCLUDED_SIMPLESTRING_H

class MyOstream;
class StringImpl;

class simpleString {
  char * d_s;
  int d_len;
  int d_cap;
  StringImpl * d_impl_p;
public:
  simpleString(); 
  simpleString(const simpleString &);
  explicit simpleString(const char * s);
  void operator =(const char *);
  void operator =(const simpleString & x);
  ~simpleString(); 
  void reserve(int);
  bool operator ==(const simpleString &) const;
  bool operator ==(const char *) const;
  bool operator<(const simpleString &) const;
  const char * chars() const { return d_s;};
  int length() const { return d_len;};
};

MyOstream & operator <<(MyOstream &,const simpleString &);
#endif
