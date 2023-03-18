// CreateOrder.c

#include "CreateOrder.hpp"
#include "EditChoices.hpp"
#include "RecordHere.hpp"
#include "Variable.hpp"
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif
#include "MLex.hpp"
#ifdef WANT_WREATH
#include "Wreath.hpp"
#endif

#include "vcpp.hpp"

vector<vector<Variable> > s_currentVariables;
vector<AdmissibleOrder *> s_Admissible;
#include "idValue.hpp"
int s_MULTIGRADED_CHOICE = idValue("::s_MULTIGRADED_CHOICE");
int s_WREATH_CHOICE = idValue("::s_WREATH_CHOICE");

// The following line CAN be changed.
int s_ORDER_CHOICE = s_MULTIGRADED_CHOICE;

AdmissibleOrder * CreateOrder() {
  AdmissibleOrder * result = 0;
  if(s_ORDER_CHOICE==s_MULTIGRADED_CHOICE) {
    RECORDHERE(result = new MLex(s_currentVariables);)
#ifdef WANT_WREATH
  } else if(s_ORDER_CHOICE==s_WREATH_CHOICE) {
    RECORDHERE(result = new Wreath(s_currentVariables,s_Admissible);)
#endif
  } else DBG();
  return result;
};

void setOrderAdopt(AdmissibleOrder * p) {
  AdmissibleOrder::s_setCurrentAdopt(p);
};

void setOrderClone(AdmissibleOrder * p) {
  AdmissibleOrder::s_setCurrentClone(p);
};

#include "StartEnd.hpp"

class startUpOrder : public AnAction {
public:
  startUpOrder() : AnAction("startUpOrder") {};
  void action() {
    setOrderAdopt(CreateOrder());
  };
};

AddingStart temp1CreateOrder(new startUpOrder);
