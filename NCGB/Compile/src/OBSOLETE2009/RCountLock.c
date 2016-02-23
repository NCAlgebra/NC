//  RCountLock.c

#include "RCountLock.hpp"
#include "load_flags.hpp"

#ifdef PDLOAD
#include "FactControl.hpp"
template class RCountLock<FactControl>;
//bool RCountLock<FactControl>::s_CanShare = true;
bool RCountLock<FactControl>::s_CanShare = false;
#endif
