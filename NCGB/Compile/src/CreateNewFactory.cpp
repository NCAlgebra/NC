// CreateNewFactory.c

#include "CreateNewFactory.hpp"
#include "RecordHere.hpp"
#include "load_flags.hpp"
#include "code_flags.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "GBStream.hpp"
#ifndef INCLUDED_USEROPTIONS_H
#include "UserOptions.hpp"
#endif

#ifndef INCLUDED_PDROUTINEFACTORY_H
#include "PDRoutineFactory.hpp"
#endif

#include "BaRoutineFactory.hpp"

#include "MyOstream.hpp"
#include "Monomial.hpp"

void CreateNewFactory() {
GBStream << "> You are using factory setting " 
         << UserOptions::s_FactorySetting << '\n';
  BaRoutineFactory * p = 0;
  switch(UserOptions::s_FactorySetting) {

  case 0: RECORDHERE(p = new PDRoutineFactory();)
          BaRoutineFactory::s_setCurrent(p);
          break;
  default: DBG();
           break;
  };
};

#include "StartEnd.hpp"

class  setCreateNewFactory : public AnAction {
public:
  setCreateNewFactory() : AnAction("startUpOrder") {};
  void action() {
    CreateNewFactory();
  };
};

AddingStart temp1CreateNewFactory(new setCreateNewFactory);
