// (c) Mark Stankus 1999
// ZDebug1.c

#include "Debug1.hpp"
#include "SetBuiltIn.hpp"

// ENTRY
SetBuiltIn initializeDebug11("RecordCommandNumbers",&Debug1::s_RecordCommandNumbers);

// ENTRY
SetBuiltIn initializeDebug12("PrintOutAllInputs",&Debug1::s_PrintOutAllInputs);

// ENTRY
SetBuiltIn initializeDebug13("PrintOutAllOutputs",&Debug1::s_PrintOutAllOutputs);
