// CreateNumber.c

#include "FieldChoice.hpp"
#include "Choice.hpp"

#ifdef USE_V_FIELD
#ifdef USE_UNIX
#include "vCreateNumber.c"
#else
#include "vCreateNumber.cpp"
#endif
#endif

#ifdef  USE_VV_FIELD
#ifdef USE_UNIX
#include "vvCreateNumber.c"
#else
#include "vCreateNumber.cpp"
#endif
#endif
