// version.h

#ifndef INCLUDED_VERSION_H
#define INCLUDED_VERSION_H

#include "UserOptions.hpp"

inline bool isPD() { return UserOptions::s_FactorySetting==0;};
inline bool isCP() { return UserOptions::s_FactorySetting==1;};
#endif
