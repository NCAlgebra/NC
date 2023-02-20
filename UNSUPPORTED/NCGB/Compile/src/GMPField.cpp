// GMPField.cpp
// Mark Stankus (c) Tue Jul  7 15:19:58 PDT 2009

#include "GMPField.hpp"
#include "MyOstream.hpp"
#include "Sink.hpp"

void Field::print(MyOstream & os) const {
  os << d_f.get_str().c_str();
};

void Field::put(Sink& sink) const {
  Sink inside = sink.outputFunction("ToExpression",1); 
  inside.putString(d_f.get_str().c_str());
};
