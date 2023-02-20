// RA1.hpp

#ifndef INCLUDED_RA1_H
#define INCLUDED_RA1_H

#include "load_flags.hpp"
#ifdef PDLOAD
#include "RAList.hpp"
#include "FactControl.hpp"

class RAListFactControl  : public RAList<FactControl>  {};
#endif
#endif
