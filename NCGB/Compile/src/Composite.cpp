// Composite.c

#include "Composite.hpp"
#include "symbolGB.hpp"
#include "Source.hpp"
#include "GBInputNumbers.hpp"

Composite GetComposite(Source & source) {
  Composite result;
  symbolGB x;
  int type = source.getType();
  if(GBInputNumbers::isSymbol(type)) {
    source >> x;
    result = Composite(x.value().chars());
  } else if(GBInputNumbers::isFunction(type)) {
    Source source2(source.inputFunction(x));
    vector<Polynomial> V;
    Polynomial p;
    while(!source2.eoi()) {
      source2 >> p;
      V.push_back(p);
    };
    result = Composite(x.value().chars(),V);
  } else DBG();
  return result;
};

simpleString Composite::s_invalid("invalid");
