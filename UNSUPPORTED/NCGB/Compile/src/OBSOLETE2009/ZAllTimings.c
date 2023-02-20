// (c) Mark Stankus 1999
// AllTimings.c

#include "AllTimings.hpp"
#include "SetBuiltIn.hpp"

// ENTRY
SetBuiltIn initializeAllTiming1("NCGBTiming",AllTimings::s_getTiming,
      AllTimings::s_setTiming);
