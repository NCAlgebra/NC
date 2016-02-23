// (c) Mark Stankus 1999 
// TeXSink.h

#ifndef INCLUDED_TEXSINK_H
#define INCLUDED_TEXSINK_H

#include "ISink.hpp"
#include "Choice.hpp"
class MyOstream;

class TeXSink : public ISink {
  static void errorh(int);
  static void errorc(int);
  TeXSink(const TeXSink &);
    // not implemented
  void operator=(const TeXSink &);
    // not implemented
  void error();
  MyOstream & d_os;
public:
  TeXSink(MyOstream & os) : d_os(os) {};
  virtual ~TeXSink();
  MyOstream & stream() { return d_os;};
  void flush();
  virtual void put(bool);
  virtual void put(int);
  virtual void put(long);
#ifdef USE_UNIX
  virtual void put(long long);
#endif
  virtual void put(const char *); // same as a symbol
  void TeXSink::put(char x) {
    * this <<x;
  };
  
  TeXSink &  operator <<(char);
  TeXSink &  operator <<(int);
  TeXSink &  operator <<(float);
  TeXSink &  operator <<(double);
  TeXSink &  operator <<(const char *);
  virtual void put(const stringGB &);
  virtual void put(const symbolGB &);
  virtual void put(const asStringGB &);

  virtual Alias<ISink> outputFunction(const symbolGB &,long);
  virtual Alias<ISink> outputFunction(const char * s,long);
  virtual ISink * clone() const;

  // FAT interface -- implementation optional
  virtual void put(const Field&);
  virtual void put(const Variable&);
  virtual void put(const Monomial&);
  virtual void put(const Term&);
  virtual void put(const Polynomial&);
  virtual void put(const RuleID&);
  virtual void put(const GroebnerRule&);
  virtual void noOutput();
  static bool s_showPlusWithNumbers;
  static bool s_CollapsePowers;
};


#endif
