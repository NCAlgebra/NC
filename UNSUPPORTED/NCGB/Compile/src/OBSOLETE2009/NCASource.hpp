// (c) Mark Stankus 1999
// NCASource.hpp

#ifndef INCLUDED_NCASOURCE_H
#define INCLUDED_NCASOURCE_H

#include "TheChoice.hpp"
#include "CharacterSource.hpp"
#include "FieldChoice.hpp"
#ifdef USE_VIRT_FIELD
#include "SimpleTable.hpp"
#endif

#ifdef USE_GB
#include "IISource.hpp"
class  NCASource : public IISource {
#else
#include "IISource.hpp"
class  NCASource : public ISource {
#endif
  static void errorh(int);
  static void errorc(int);
  NCASource(const NCASource &);
    // not implemented
  void operator=(const NCASource &);
    // not implemented
  CharacterSource  * d_so;
public:
  NCASource(CharacterSource *);
  virtual ~NCASource();
  virtual void get(bool&);
  virtual void get(int &);
  virtual void get(long &);;
  virtual void get(stringGB &);
  virtual void get(asStringGB &);
  virtual void get(symbolGB &);
  virtual void vShouldBeEnd();
  virtual Alias<ISource> inputCommand(symbolGB &);
  virtual Alias<ISource> inputFunction(symbolGB &);
  virtual Alias<ISource> inputNamedFunction(const symbolGB &);
  virtual Alias<ISource> inputNamedFunction(const char *); 
  virtual ISource * clone() const;
  virtual int getType() const;
  virtual void vQueryNamedFunction();
  virtual void passString();
  
#ifdef USE_VIRT_FIELD
  static SimpleTable<NCASource> s_table;
#endif
  virtual void get(Holder&);
#ifdef USE_GB
  virtual void get(Field&);
  virtual void get(Variable&);
  virtual void get(Monomial&);
  virtual void get(Term&);
  virtual void get(Polynomial&);
  virtual void get(GroebnerRule&);
#endif

  void passComma(bool ok = false) const {
    if(!d_eoi) {
      bool b = (const_cast<NCASource*>(this))->d_eoi = d_so->eof();
      if(!b) {
        char c;
        d_so->peekCharacter(c);
        if(c==',') {
          d_so->passCharacter();
        } else if(!ok) {
          errorh(__LINE__);
        };
      };
    };
  };
  static bool s_pass_comma;
  CharacterSource * so() { return d_so;};
};
#endif
