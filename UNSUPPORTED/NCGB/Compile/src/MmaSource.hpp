// MmaSource.h

#ifndef INCLUDED_MMASOURCE_H
#define INCLUDED_MMASOURCE_H

//class MLink;
extern "C" {
#include "mathlink.h"
}
#include "Debug1.hpp"
#include "FieldChoice.hpp"
#ifdef USE_VIRT_FIELD
#include "SimpleTable.hpp"
#endif
#include "TheChoice.hpp"

#ifdef USE_GB
#include "IISource.hpp"
class  MmaSource : public IISource {
#else
#include "ISource.hpp"
class  MmaSource : public ISource {
#endif
  MmaSource(const MmaSource &);
    // not implemented
  void operator=(const MmaSource &);
    // not implemented
  MLink * d_mlink;
#if MLINTERFACE >= 3
  int d_length;
#else
  long_st d_length;
#endif
public:
#ifdef USE_GB
  MmaSource(MLink * mlink)  : IISource(false,true), 
         d_mlink(mlink), d_has_new_packet(false) {};
#else
  MmaSource(MLink * mlink)  : ISource(false,true), 
         d_mlink(mlink), d_has_new_packet(false) {};
#endif
  static void errorh(int);
  static void errorc(int);
  bool d_has_new_packet;
  virtual ~MmaSource();
  void resetMLINK(MLink * mlink) { d_mlink = mlink;};
  void queryFunction() {
    if(!d_old_function_name_valid) {
      char * result;
      MLGetFunction(d_mlink,(const char **) &result,&d_length);
      d_old_function_name = result;
// INEFFICIENCY
//      DestroyFunction(d_mlink,result);
      d_old_function_name_valid = true;
    };
  };
  void getFunction(symbolGB & x,long & L) {
    if(!d_old_function_name_valid) {
      queryFunction();
    };
    x = d_old_function_name;
    L = d_length;
    d_old_function_name_valid = false;
  };
  void passFunction() {
    if(!d_old_function_name_valid) errorh(__LINE__);
    d_old_function_name_valid = false;
  };
  virtual void get(bool &);
  virtual void get(int &);
  virtual void get(long &);
  virtual void get(stringGB &);
  virtual void get(asStringGB &);
  virtual void get(symbolGB &);
  virtual Alias<ISource> inputCommand(symbolGB &);
  virtual Alias<ISource> inputFunction(symbolGB &);
  virtual Alias<ISource> inputNamedFunction(const symbolGB &);
  virtual Alias<ISource> inputNamedFunction(const char *);
  virtual void vQueryNamedFunction();
  virtual void vShouldBeEnd();
  virtual ISource * clone() const;
  virtual int getType() const;
  virtual void passString();
  virtual void get(Holder&);
  virtual void get(Field&);
  virtual void get(Variable&);
  virtual void get(Monomial&);
  virtual void get(Term&);
  virtual void get(Polynomial&);
  virtual void get(GroebnerRule &);
  virtual bool verror() const;
  void checkforerror() const;
  MLink * mlink() { return d_mlink;};
#ifdef USE_VIRT_FIELD
  static SimpleTable<MmaSource> s_table;
#endif
  static const int s_ID;
};
#endif
