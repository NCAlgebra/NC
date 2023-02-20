// Mark Stankus 1999 (c)
// namedStarting.c

#include "Source.hpp"
#include "Sink.hpp"
#include "stringGB.hpp"
#include "GBList.hpp"
#include "Polynomial.hpp"
#include "Pools.hpp"
#include "MyOstream.hpp"
#include "Debug1.hpp"
#include "Command.hpp"

void registerStartingRelationsHelper(const GBList<Polynomial> &);

void _namedRegisterStartingRelations(Source & so,Sink & si) {
  stringGB item_name;
  so >> item_name;
  so.shouldBeEnd();
  si.noOutput();
  GBList<Polynomial>*  p =
     Pools<GBList<Polynomial> >::s_lookup_error(GBStream,item_name.value());
  if(p) {
    registerStartingRelationsHelper(*p);
  } else {
    GBStream << "There is no GBList of polynomials called \""
             << item_name << "\"\n";
  };
};

AddingCommand temp0RegisterRecipients("namedRegisterStartingRelations",1,
      _namedRegisterStartingRelations);
