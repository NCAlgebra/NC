// FieldRep.h

#ifndef INCLUDED_FIELDREP_H
#define INCLUDED_FIELDREP_H

#include "FieldChoice.hpp"

#ifdef USE_VIRT_FIELD

class MyOstream;
class OutputVisitor;
class Sink;

class FieldRep {
public:
  virtual FieldRep * make(int) = 0;
  virtual FieldRep * make(const FieldRep &) = 0;
  virtual FieldRep * clone()  const = 0;
  virtual ~FieldRep();
  bool operator == (const FieldRep & f) const {return equal(f);}; 
  bool operator != (const FieldRep & f) const {return !equal(f);}; 
  void operator +=(const int & i)  { add(i);};
  void operator -=(const int & i) { subtract(i);};
  void operator *=(const int & i) { times(i);};
  void operator /=(const int & i) { divide(i); };
  void operator +=(const FieldRep & f) { add(f);};
  void operator -=(const FieldRep & f) { subtract(f);};
  void operator *=(const FieldRep & f) { times(f);};
  void operator /=(const FieldRep & f) { divide(f); };

  // Abstract functions
  virtual void setToZero() = 0;
  virtual void setToOne() = 0;
  virtual int sgn() const = 0;
  virtual void initialize(int) = 0;
  virtual void initialize(const FieldRep &) = 0;
  virtual bool equal(const FieldRep &) const = 0;
  virtual bool less(const FieldRep &) const = 0;
  virtual int compareNumbers(const FieldRep &) const = 0;
  virtual void invert() = 0;
  virtual void add(int) = 0;
  virtual void add(const FieldRep &) = 0;
  virtual void subtract(int) = 0;
  virtual void subtract(const FieldRep &) = 0;
  virtual void times(int) = 0;
  virtual void times(const FieldRep &) = 0;
  virtual void divide(int) = 0;
  virtual void divide(const FieldRep &) = 0;
  virtual bool isZero() const = 0;
  virtual bool isOne() const = 0;
  virtual void print(MyOstream &) const = 0;
  virtual void print(OutputVisitor &) const = 0;
  virtual void put(Sink & ioh) const = 0;

  int ID() const { return d_ID;};
protected:
  FieldRep(int id) : d_ID(id) {};
private:
  int d_ID;
  FieldRep(const FieldRep & f);      // not implemented
  void operator =(const FieldRep &); // not implemented
};
#endif  
#endif
