// (c) Mark Stankus 1999
// TellHead.c

#include "TellHead.hpp"
#include "GBInputNumbers.hpp"
#include "symbolGB.hpp"
#include "stringGB.hpp"
#include "Debug1.hpp"
#include "Source.hpp"
#include "idValue.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"

void TellJustHead(Source & so) {
  TellHead(so,false);
};

void TellJustHead(ISource & so) {
  TellHead(so,false);
};

void TellHead(Source & so,bool b) {
  int type = so.getType();
  GBStream << "The ";
  if(b) GBStream << "confusing ";
  GBStream << "token is ";
  if(isSymbol(type)) {
    GBStream << "a symbol.\n";
    if(b) {
      symbolGB x;
      so >> x;
      GBStream << "The symbol is " << x.value().chars() << ".\n";
    };
  } else if(isString(type)) {
    GBStream << "a string.\n";
    if(b) {
      stringGB x;
      so >> x;
      GBStream << "The string is " << x.value().chars() << ".\n";
    };
  } else if(isInteger(type)) {
    GBStream << "an integer.\n";
    if(b) {
      int i;
      so >> i;
      GBStream << "The integer is " << i << ".\n";
    };
  } else if(isFunction(type)) {
    GBStream << "a function header.\n";
  } else if (isReal(type)) {
    GBStream << "a real number.\n";
  } else if (type==GBInputNumbers::s_IOEOI) {
    GBStream << "end of input.\n";
  } else if (type==GBInputNumbers::s_IOEOF) {
    GBStream << "end of file.\n";
  } else {
    GBStream << "of unknown type (?!) and "
             << "has the ``code\" " << type << " (which is) "
             << (char) type  << '\n';
    if(numberOfIdStrings()>type) {
      GBStream << "The following may or may not be helpful: "
               << idString(type) << '\n';
    };
    if(b) DBG();
  };
};

void TellHead(ISource & so,bool b) {
  int type = so.getType();
  GBStream << "The ";
  if(b) GBStream << "confusing ";
  GBStream << "token is ";
  if(isSymbol(type)) {
    GBStream << "a symbol.\n";
    if(b) {
      symbolGB x;
      so.get(x);
      GBStream <<  "The symbol is " << x.value().chars() << ".\n";
    };
  } else if(isString(type)) {
    GBStream << "a string.\n";
    if(b) {
      stringGB x;
      so.get(x);
      GBStream << "The string is " << x.value().chars() << ".\n";
    };
  } else if(isInteger(type)) {
    GBStream << "an integer.\n";
    if(b) {
      int i;
      so.get(i);
      GBStream << "The integer is " << i << ".\n";
    };
  } else if(isFunction(type)) {
    GBStream << "a function header.\n";
  } else if (isReal(type)) {
    GBStream << "a real number.\n";
  }
  else {
    GBStream << "of unknown type (?!) and "
             << "has the ``code\" " << type << " (which is) "
             << (char) type  << '\n';
    if(numberOfIdStrings()>type) {
      GBStream << "The following may or may not be helpful: "
               << idString(type) << '\n';
    };
    if(b) DBG();
  };
};
