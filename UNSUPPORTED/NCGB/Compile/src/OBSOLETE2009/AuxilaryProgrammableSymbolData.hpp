// (c) Mark Stankus 1999
// AuxilaryProgrammableSymbolData.h

#ifndef INCLUDED_AUXILARYPROGRAMMABLESYMBOLDATA_H
#define INCLUDED_AUXILARYPROGRAMMABLESYMBOLDATA_H

class Source;
class Sink;
class simpleString;

class AuxilaryProgrammableSymbolData {
public:
  AuxilaryProgrammableSymbolData(
      void (*construct_default)(const simpleString &),
      void (*remove)(const simpleString &),
      void (*print)(const simpleString &,MyOstream &),
      void (*input)(const simpleString &,Source &source),
      void (*output)(const simpleString &,Sink &source)) :
    d_construct_default(construct_default), d_construct_not_default(0), 
    d_remove(remove), d_print(print), d_input(input), d_output(output) {};
  AuxilaryProgrammableSymbolData(
      void (*construct_not_default)(const simpleString &,Source &),
      void (*remove)(const simpleString &),
      void (*print)(const simpleString &,MyOstream &),
      void (*input)(const simpleString &,Source &source),
      void (*output)(const simpleString &,Sink &source)) :
    d_construct_default(0),d_construct_not_default(construct_not_default), 
    d_remove(remove), d_print(print), d_input(input), d_output(output) {};
  void (*d_construct_default)(const simpleString &);
  void (*d_construct_not_default)(const simpleString &,Source &);
  void (*d_remove)(const simpleString &);
  void (*d_print)(const simpleString &,MyOstream &);
  void (*d_input)(const simpleString &,Source &source);
  void (*d_output)(const simpleString &,Sink &source);
};
#endif
