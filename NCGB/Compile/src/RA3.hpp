// RA3.hpp

#ifndef INCLUDED_RA3_H
#define INCLUDED_RA3_H

#include "RAList.hpp"
#include "GBList.hpp"
#include "GroebnerRule.hpp"

class RAListGBListGroebnerRule : public RAList<GBList<GroebnerRule> >  {};
#endif
