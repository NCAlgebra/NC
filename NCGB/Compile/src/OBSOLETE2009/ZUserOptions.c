// (c) Mark Stankus 1999
// ZUserOptions.c

#include "UserOptions.hpp"
#include "SetBuiltIn.hpp"

// ENTRY
SetBuiltIn initializeUserOptions1("SupressMoraOutput",
                                  &UserOptions::s_supressOutput);

// ENTRY
SetBuiltIn initializeUserOptions2("SupressAllCOutput",
                        &UserOptions::s_supressAllCOutput);

// ENTRY
SetBuiltIn initializeUserOptions3("SupressAllCOutput",
                       &UserOptions::s_SelectionOutputMethod);

// ENTRY
SetBuiltIn initializeUserOptions4("TellMultiGradedLex",
           &UserOptions::s_TellMultiGradedLex);

// ENTRY
SetBuiltIn initializeUserOptions5("NCGBSubMatch",&UserOptions::s_UseSubMatch);
