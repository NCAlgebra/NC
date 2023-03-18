// RA2.hpp

#ifndef INCLUDED_RA2_H
#define INCLUDED_RA2_H

#include "RAList.hpp"
#include "Polynomial.hpp"
#include "GBList.hpp"

class RAListGBListPolynomial : public RAList<GBList<Polynomial> >  {};
#endif
