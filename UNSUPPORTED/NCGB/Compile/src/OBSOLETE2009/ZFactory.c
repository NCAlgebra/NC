// (c) Mark Stankus 1999
// ZFactory.c

#include "UserOptions.hpp"
#include "CreateNewFactory.hpp"
#include "SetBuiltIn.hpp"

void s_set_factory_type(int n) {
  UserOptions::s_FactorySetting = n; 
  CreateNewFactory();
};

int s_get_factory_type() {
  return UserOptions::s_FactorySetting; 
};

SetBuiltIn initializeFactory1("FactorySetting",s_get_factory_type,s_set_factory_type);
