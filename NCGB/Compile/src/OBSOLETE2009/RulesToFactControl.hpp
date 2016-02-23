// RulesToFactControl.h

class FactControl;
#include "GBList.hpp"
#include "GroebnerRule.hpp"

void RulesToFactControl(const GBList<GroebnerRule> & source,
                        FactControl & fc);
