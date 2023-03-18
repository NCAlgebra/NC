// DataConversion.h

#include "load_flags.hpp"
//#pragma warning(disable:4786)
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"

void conversion(const GBList<GroebnerRule> & source,
      GBList<Polynomial> & dest);

#ifdef PDLOAD
#include "GBVector.hpp"
class FactControl;
void conversion(const GBList<Polynomial> & source,GBList<GroebnerRule> & dest);

void conversion(const GBList<GroebnerRule> & source,
                        FactControl & fc,GBVector<int> & nums);

void conversion(const GBList<Polynomial> & source,
    FactControl & fc,GBVector<int> & nums);
#endif

