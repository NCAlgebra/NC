// RA4.hpp

#ifndef INCLUDED_RA4_H
#define INCLUDED_RA1_H

#include "RAList.hpp"
#include "GBList.hpp"
#include "Variable.hpp"

class RAListGBListVariable : public RAList<GBList<Variable> >  {};
#endif
