// (c) Mark Stankus 1999
// Variable.c

#include "ChoiceVariable.hpp"
#include "Choice.hpp"
#ifdef USE_OLD_VARIABLE
#include "oVariable.cpp"
#endif
#ifdef USE_N_VARIABLE
#include "nVariable.cpp"
#endif
#ifdef USE_NN_VARIABLE
#include "nnVariable.cpp"
#endif
#include "StartEnd.hpp"

class startUpVariables : public AnAction {
public:
  startUpVariables() : AnAction("startUpVariables") {};
  void action() {
    Variable::s_newStringList();
  };
};

AddingStart temp1Variable(new startUpVariables);
