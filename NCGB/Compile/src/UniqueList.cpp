#include "choice_variable.hpp"
#ifdef USE_OLD_VARIABLE
#include "Choice.hpp"
#include "OldUniqueList.cpp"
#endif
#ifdef USE_N_VARIABLE
#include "Choice.hpp"
#include "newUniqueList.cpp"
#endif
#ifdef USE_NN_VARIABLE
#include "Choice.hpp"
#include "newerUniqueList.cpp"
#endif
