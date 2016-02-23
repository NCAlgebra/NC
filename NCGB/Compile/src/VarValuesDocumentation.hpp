// VarValuesDocumentation.h

#ifndef INCLUDED_VARVALUESDOCUMENTATION_H
#define INCLUDED_VARVALUESDOCUMENTATION_H

#include "Documentation.hpp"
class TheFunctionSetUp;

class VarValuesDocumentation : public Documentation {
public:
  VarValuesDocumentation(char *,char *,char *,char *);
  virtual ~VarValuesDocumentation();
  void put(MyOstream & os);
  void setPtr(void * p);
public:
  TheFunctionSetUp * d_p;
};
#endif
