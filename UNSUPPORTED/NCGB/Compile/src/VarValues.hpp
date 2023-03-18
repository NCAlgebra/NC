// VarValues.h

#ifndef INCLUDED_VARVALUES_H
#define INCLUDED_VARVALUES_H

class Source;
class Sink;

struct int_ID {
  int_ID(){};
  static int id;
};

struct bool_ID {
  bool_ID(){};
  static int id;
};

class VarValues {
public:
  VarValues(){};
  virtual ~VarValues();
  virtual void set(Source &)  = 0;
  virtual void get(Sink &)  = 0;
};

template<class T,class ID>
class AddrVarValues : public VarValues {
  AddrVarValues();
    // not implemented
  AddrVarValues(const AddrVarValues &);
    // not implemented
  void operator =(const AddrVarValues &);
    // not implemented
  T * d_value_p;
  ID d_ID;
public:
  AddrVarValues(T & p,ID *) : d_value_p(&p), d_ID() {};
  virtual ~AddrVarValues() ;
  virtual void set(Source & ioh);
  virtual void get(Sink & ioh);
};

template<class T,class ID>
class FuncVarValues : public VarValues {
  FuncVarValues();
    // not implemented
  FuncVarValues(const FuncVarValues &);
    // not implemented
  void operator =(const FuncVarValues &);
    // not implemented
  void (*f_set)(T);
  T (*f_get)();
  ID d_ID;
public:
  FuncVarValues(void (*setFunction)(T),T (*getFunction)(),ID *) : 
     f_set(setFunction), f_get(getFunction), d_ID() {};
  virtual ~FuncVarValues() ;
  virtual void set(Source & ioh);
  virtual void get(Sink & ioh);
};

class BoolOrIntToInt : public VarValues {
  BoolOrIntToInt();
    // not implemented
  BoolOrIntToInt(const BoolOrIntToInt &);
    // not implemented
  void operator =(const BoolOrIntToInt &);
    // not implemented
  bool &  d_x;
public:
  BoolOrIntToInt(bool & x) : d_x(x) {};
  virtual ~BoolOrIntToInt() ;
  virtual void set(Source & ioh);
  virtual void get(Sink & ioh);
  static const int s_ID;
};
#endif
