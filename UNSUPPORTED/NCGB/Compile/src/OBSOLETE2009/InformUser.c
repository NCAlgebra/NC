// (c) Mark Stankus 1999
// InformUser.cpp

#include "ProgrammableSymbol.hpp"
#include "Command.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "MyOstream.hpp"
#include "Debug1.hpp"


void _PrintProgrammedSymbols(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
  TYPEINFO::const_iterator w = d_type_info.begin();
  TYPEINFO::const_iterator e = d_type_info.end();
  while(w!=e) {
    GBStream << "Type:" << (*w).first << '\n';
    ++w;
  };
  GBStream << "\n\n";
  NAME2TYPE::const_iterator w1 = d_name_to_type.begin();
  NAME2TYPE::const_iterator e1 = d_name_to_type.end();
  while(w1!=e1) {
    const pair<const simpleString,simpleString> & pr1 = *w1;
    GBStream << "Name:" << pr1.first << '\n';
    GBStream << "Type:" << pr1.second << '\n';
    GBStream << "Value:";
    (*d_type_info.find(pr1.second)).second.d_print(pr1.first,GBStream);
    GBStream << "\n\n";
    ++w1;
  };
};

AddingCommand temp1InformUser("PrintProgrammedSymbols",0,
                              _PrintProgrammedSymbols);
