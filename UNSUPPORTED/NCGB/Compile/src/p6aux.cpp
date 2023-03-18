// p6aux.c

 
#include "GBStream.hpp"
#include "Source.hpp"
#include "Sink.hpp"
#include "RAs.hpp"
#include "PrintGBVector.hpp"
#include "PrintGBList.hpp"
#include "GBOutputSpecial.hpp"
#include "stringGB.hpp"
#include "load_flags.hpp"
#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
//#include "RegularOutput.hpp"
#define NOREGULAROUTPUT
#ifndef INCLUDED_ADJOINT_H
#include "adjoint.hpp"
#endif
#ifndef INCLUDED_FIRSTDIFFER_H
#include "firstDiffer.hpp"
#endif
#include "Command.hpp"
#include "MyOstream.hpp"

#define RECORDMARKERS
#ifdef  RECORDMARKERS

#include "MemoryOptions.hpp"

#endif

#ifdef PDLOAD
#ifndef INCLUDED_RALIST_H
#include "RAList.hpp"
#endif
#endif

#ifndef INCLUDED_GBGLOBALS_H
#include "GBGlobals.hpp"
#endif
#ifndef INCLUDED_MARKER_H
#include "marker.hpp"
#endif

#ifdef NOFACCATEGORY
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#endif

 

void destroySingleMarker(int fromn,const char * s) {
#ifdef  RECORDMARKERS
  if(MemoryOptions::s_recordNamesOfGBMarkers) {
    GBGlobals::s_dismissMarker(fromn,s);
  };
  simpleString ss(s);
#endif
  if(ss=="integers") {
    GBGlobals::s_integers().reference(fromn).clear();
    GBGlobals::s_integers().makeHole(fromn);
#ifdef PDLOAD
  } else if(ss=="factcontrol") {
    GBGlobals::s_factControls().reference(fromn).clearFacts();
    GBGlobals::s_factControls().makeHole(fromn);
#endif
  } else if(ss=="polynomials") {
    GBGlobals::s_polynomials().reference(fromn).empty();
    GBGlobals::s_polynomials().makeHole(fromn);
  } else if(ss=="rules") {
    GBGlobals::s_rules().reference(fromn).empty();
    GBGlobals::s_rules().makeHole(fromn);
  } else if(ss=="variables") {
    GBGlobals::s_variables().reference(fromn).empty();
    GBGlobals::s_variables().makeHole(fromn);
  } else {
    GBStream << "The command _destroyGBMarker cannot "
             << "recognize a marker of type " 
             << s << '\n';
    DBG();
  };
};

// ------------------------------------------------------------------

void _destroyGBMarker(Source & so,Sink & si) {
  int fromn;
  stringGB x;

  so >> fromn;
  so >> x;
  so.shouldBeEnd();
  si.noOutput();
  destroySingleMarker(fromn,x.value().chars());
} /* _destroyGBMarker */

AddingCommand temp1p6aux("destroyGBMarker",2,_destroyGBMarker);

// ------------------------------------------------------------------

// Note the  plualization

void _destroyGBMarkers(Source & so,Sink & si) {
  int fromn;
  stringGB x;
  Source source1(so.inputNamedFunction("List"));
  while(!source1.eoi()) {
    Source source2(source1.inputNamedFunction("GBMarker"));
    source2 >> fromn >> x;
    destroySingleMarker(fromn,x.value().chars());
  };
  so.shouldBeEnd();
  si.noOutput();
} /* _destroyGBMarkers */

AddingCommand temp2p6aux("destroyGBMarkers",1,_destroyGBMarkers);

// ------------------------------------------------------------------

void _printGBMarker(Source & so,Sink & si) {
  marker input;
  input.get(so);
  const simpleString ss(input.name());
  int n = input.num();
  so.shouldBeEnd();
  if(ss=="categoryFactories") {
#ifdef NOREGULAROUTPUT
    Debug1::s_not_supported("printGBMarker for categoryFactories in C++");
#else
    RegularOutput reg(_categoryFactories.const_reference(n));
    GBStream << reg << '\n';
#endif
#ifdef PDLOAD
  } else if(ss=="factcontrol") {
    GBStream << GBGlobals::s_factControls().const_reference(n) << '\n';
#endif
  } else if(ss=="integers") {
    PrintGBVector(0,GBGlobals::s_integers().const_reference(n)); 
    GBStream << '\n';
  } else if(ss=="polynomials") {
    PrintGBList(0,GBGlobals::s_polynomials().const_reference(n));
    GBStream << '\n';
  } else if(ss=="rules") {
    PrintGBList(0,GBGlobals::s_rules().const_reference(n));
    GBStream << '\n';
  } else if(ss=="variables") {
    PrintGBList(0,GBGlobals::s_variables().const_reference(n));
    GBStream << '\n';
  } else {
    GBStream << "The command _printGBMarker cannot "
             << "recognize a marker of type " 
             << ss.chars() << '\n';
    DBG();
  };
  si.noOutput();
} /* _printGBMarker */

AddingCommand temp3p6aux("printGBMarker",1,_printGBMarker);

#ifndef INCLUDED_DATACONVERSIONS_H
#include "DataConversions.hpp"
#endif

// ------------------------------------------------------------------

void _copyGBMarker(Source & so,Sink & si) {
  stringGB froms,tos;
  int fromn;
  so >> froms >>  fromn >> tos;
  marker result;
  result.name(tos.value().chars());
  so.shouldBeEnd();
  if(false) {
#ifdef PDLOAD
  } else if(froms=="factcontrol") {
    if(tos=="factcontrol") {
      result.num(GBGlobals::s_factControls().push_back(
            GBGlobals::s_factControls().const_reference(fromn) 
                                         ));
    } else if(tos=="rules") {
      const FactControl & fc = 
         GBGlobals::s_factControls().const_reference(fromn);
      GBList<GroebnerRule> FACTS;
      fc.getFacts(FACTS);
      result.num(GBGlobals::s_rules().push_back(FACTS));
    } else DBG();
#endif
    } else if(froms=="polynomials") {
      if(false) {
#ifdef PDLOAD
      } else if(tos=="factcontrol") {
        result.num(GBGlobals::s_factControls().push_back(FactControl()));
        FactControl & fc = 
           GBGlobals::s_factControls().reference(result.num());
        const GBList<Polynomial> & aList =
           GBGlobals::s_polynomials().const_reference(result.num());
        GBVector<int> dummy;
        conversion(aList,fc,dummy);
#endif
      } else if(tos=="polynomials") {
        result.num(GBGlobals::s_polynomials().push_back(
              GBGlobals::s_polynomials().const_reference(fromn)
                                          ));
#ifdef PDLOAD
      } else if(tos=="rules") {
        result.num(GBGlobals::s_rules().push_back(GBList<GroebnerRule>()));
        GBList<GroebnerRule> & aList = 
             GBGlobals::s_rules().reference(result.num());
        const GBList<Polynomial> & srcList = 
             GBGlobals::s_polynomials().const_reference(fromn);
        conversion(srcList,aList);
#endif
      } else DBG(); 
    } else if(froms=="rules") {
      if(false) {
#ifdef PDLOAD
      } else if(tos=="factcontrol") {
        const GBList<GroebnerRule> & source =
          GBGlobals::s_rules().const_reference(fromn);
        result.num(GBGlobals::s_factControls().push_back(FactControl()));
        FactControl & fc = 
           GBGlobals::s_factControls().reference(result.num());
        GBVector<int> nums;
            conversion(source,fc,nums);
#endif
      } else if(tos=="polynomials") {
        result.num(GBGlobals::s_polynomials().push_back(GBList<Polynomial>()));
        GBList<Polynomial> & aList = 
            GBGlobals::s_polynomials().reference(result.num());
        const GBList<GroebnerRule>& srcList = 
          GBGlobals::s_rules().const_reference(fromn);
        conversion(srcList,aList);
      } else if(tos=="rules") {
        result.num(GBGlobals::s_rules().push_back(
                GBGlobals::s_rules().const_reference(fromn)
                                      ));
      } else DBG(); 
    } else if(froms=="variables") {
      if(tos=="variables") {
        result.num(GBGlobals::s_variables().push_back(
              GBGlobals::s_variables().const_reference(fromn)
                                              ));
      } else DBG();
    } else {
      GBStream << "The command _copyGBMarker cannot "
               << "recognize a marker of type " 
               << froms.value().chars() << ".\n" 
               << "By the way, the above character string has " 
               << froms.value().length() << " characters.";
    DBG();
  };
  result.put(si);
}; /* _copyGBMarker */

AddingCommand temp4p6aux("copyGBMarker",3,_copyGBMarker);

// ------------------------------------------------------------------

void _numberOfElementsBehindMarker(Source & so,Sink & si) {
  marker mark;
  mark.get(so);
  so.shouldBeEnd();
  stringGB x(mark.name());
  int m = mark.num();
  int ans = -1;
  if(x=="polynomials") {
    ans = GBGlobals::s_polynomials().const_reference(m).size();
  } else if(x=="rules") {
    ans = GBGlobals::s_rules().const_reference(m).size();
  } else if(x=="variables") {
    ans = GBGlobals::s_variables().const_reference(m).size();
  } else DBG();
  si << ans;
};

AddingCommand temp5p6aux("numberOfElementsBehindMarker",1,_numberOfElementsBehindMarker);

// ------------------------------------------------------------------

void _returnGBMarkerContents(Source & so,Sink &  si) {
  marker from;
  from.get(so);
  so.shouldBeEnd();
  if(false) {
#ifdef PDLOAD
  } else if(from.nameis("factcontrol")) {
    GBVector<int> numbers;
    const FactControl & fc = 
        GBGlobals::s_factControls().const_reference(from.num());
    const int sz = fc.numberOfFacts(); 
    for(int i=1;i<=sz;++i) {
      numbers.push_back(i);
    }
    GBOutputSpecial2(fc,numbers,si);
#endif
  } else if(from.nameis("integers")) {
    GBOutputSpecial(GBGlobals::s_integers().const_reference(from.num()),si);
  } else if(from.nameis("polynomials")) {
    GBOutputSpecial(GBGlobals::s_polynomials().const_reference(from.num()),si);
  } else if(from.nameis("rules")) {
    GBOutputSpecial(GBGlobals::s_rules().const_reference(from.num()),si);
  } else if(from.nameis("variables")) {
    GBOutputSpecial(GBGlobals::s_variables().const_reference(from.num()),si);
  } else {
    GBStream << "The command _sendGBMarkerContents cannot "
             << "recognize a marker of type " 
             << from.name() << '\n';
    DBG();
  };
}; /* _returnGBMarkerContents */

AddingCommand temp6p6aux("returnGBMarkerContents",1,_returnGBMarkerContents);

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

This function takes two markers and returns a marker holding their intersection.

Duplicates in each marker are NOT removed.

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

void _IntersectMarkers(Source & so,Sink & si) {
  marker mark1,mark2;
  mark1.get(so);
  mark2.get(so);
  int n = mark1.num(), m = mark2.num();
  if(!mark1.nameis(mark2.name())) DBG();
  marker result;
  result.name(mark1.name());
  so.shouldBeEnd();
  if(result.nameis("integers")) {
// Special case - _integers is a GBVector<int>
    result.num(GBGlobals::s_integers().push_back(GBVector<int>()));
    GBVector<int> & dest =
    GBGlobals::s_integers().reference(result.num());
    const GBVector<int> & source1 = GBGlobals::s_integers().const_reference(n);
    const GBVector<int> & source2 = GBGlobals::s_integers().const_reference(m);
    const_iter_GBVector<int> w = source2.begin();
    const int sz = source2.size();
    for (int i = 1; i <= sz; ++i, ++w) {
      if (IsMember(source1,*w)) dest.push_back(*w);
    }
	} else if (result.nameis("polynomials")) {
	  result.num(GBGlobals::s_polynomials().push_back(GBList<Polynomial>()));
	  GBList<Polynomial> & dest =
	    GBGlobals::s_polynomials().reference(result.num());
	  const GBList<Polynomial> & source1 = 
	    GBGlobals::s_polynomials().const_reference(n);
	  const GBList<Polynomial> & source2 = 
	    GBGlobals::s_polynomials().const_reference(m);

          dest.clear();
          GBList<Polynomial>::const_iterator w = source1.begin();
          const int sz = source2.size();
          for (int i = 1; i <= sz; ++i, ++w) {
            if (source2.Member(*w).first()) dest.push_back(*w);
          }
	} else if (result.nameis("rules")) {
	  result.num(
	    GBGlobals::s_rules().push_back(GBList<GroebnerRule>()));
	  GBList<GroebnerRule> & dest =
	    GBGlobals::s_rules().reference(result.num());
	  const GBList<GroebnerRule> & source1 = 
	    GBGlobals::s_rules().const_reference(n);
	  const GBList<GroebnerRule> & source2 = 
	    GBGlobals::s_rules().const_reference(m);

          dest.clear();
          GBList<GroebnerRule>::const_iterator w = source1.begin();
          const int sz = source2.size();
          for (int i = 1; i <= sz; ++i, ++w) {
            if (source2.Member(*w).first()) dest.push_back(*w);
          }
	} else if (result.nameis("variables")) {
	  result.num(GBGlobals::s_variables().push_back(GBList<Variable>()));
	  GBList<Variable> & dest =
	    GBGlobals::s_variables().reference(result.num());
	  const GBList<Variable> & source1 = 
	    GBGlobals::s_variables().const_reference(n);
	  const GBList<Variable> & source2 = 
	    GBGlobals::s_variables().const_reference(m);
          dest.clear();
          GBList<Variable>::const_iterator w = source1.begin();
          const int sz = source2.size();
          for (int i = 1; i <= sz; ++i, ++w) {
            if (source2.Member(*w).first()) dest.push_back(*w);
          }
	} else {
	  GBStream << "Invalid marker name " << result.name() << ".\n";
	  DBG();
        }

	result.put(si);
};

AddingCommand temp7p6aux("IntersectMarkers",2,_IntersectMarkers);
/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

This function will take two markers and find the union, regardless of type
(though the two must be of the same type).  The integer type is coded
differently, because it uses a GBVector instead of a GBList.  Thus, for
all types, if the markers themselves have duplicates, they will be removed
EXCEPT in the integer case; for integers, if the first list has duplicates,
they will not be removed.

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

void _UnionMarkers(Source & so,Sink & si) {
  marker mark1,mark2;
  mark1.get(so);
  mark2.get(so);
  if(!mark1.nameis(mark2.name())) DBG();
  int m = mark1.num(),n = mark2.num();
  marker result;
  result.name(mark1.name());
  so.shouldBeEnd();
  if (result.nameis("integers")) {
// Special case - _integers is a GBVector<int>
    const GBVector<int> & source1 = 
      GBGlobals::s_integers().const_reference(n);
    const GBVector<int> & source2 = 
      GBGlobals::s_integers().const_reference(m);
    result.num(GBGlobals::s_integers().push_back(source1));
    GBVector<int> & dest =
      GBGlobals::s_integers().reference(result.num());

    const_iter_GBVector<int> w = source2.begin();
    const int sz = source2.size();

    for (int i = 1; i <= sz; ++i, ++w) {
      dest.insertIfNotMember(*w);
    }
  } else if (result.nameis("polynomials")) {
    const GBList<Polynomial> & source1 = 
	    GBGlobals::s_polynomials().const_reference(n);
	  const GBList<Polynomial> & source2 = 
	    GBGlobals::s_polynomials().const_reference(m);
	  result.num(GBGlobals::s_polynomials().push_back(source1));
	  GBList<Polynomial> & dest =
	  GBGlobals::s_polynomials().reference(result.num());
          // MXS LOOK HERE JULY 11,1999
	  dest.joinTo(source2);
	} else if (result.nameis("rules")) {
	  const GBList<GroebnerRule> & source1 = 
	    GBGlobals::s_rules().const_reference(n);
	  const GBList<GroebnerRule> & source2 = 
	    GBGlobals::s_rules().const_reference(m);
	  result.num(GBGlobals::s_rules().push_back(source1));
	  GBList<GroebnerRule> & dest =
	    GBGlobals::s_rules().reference(result.num());

	  dest.joinTo(source2);
	} else if (result.nameis("variables")) {
	  const GBList<Variable> & source1 = 
	    GBGlobals::s_variables().const_reference(n);
	  const GBList<Variable> & source2 = 
	    GBGlobals::s_variables().const_reference(m);
	  result.num(GBGlobals::s_variables().push_back(source1));
	  GBList<Variable> & dest =
	    GBGlobals::s_variables().reference(result.num());

	  dest.joinTo(source2);
	} else {
	  GBStream << "Invalid marker name " << result.name() << ".\n";
	  DBG();
        }
	result.put(si);
};

AddingCommand temp8p6aux("UnionMarkers",2,_UnionMarkers);

/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

This function takes two markers and returns a marker holding the first marker
complement the second.  Duplicates in each marker are NOT removed.

* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */

void _ComplementMarkers(Source & so,Sink & si) {
  marker mark1,mark2;
  mark1.get(so);
  mark2.get(so);
  int m = mark1.num(),n = mark2.num();
  if(!mark1.nameis(mark2.name())) DBG();
  marker result;
  result.name(mark1.name());
  so.shouldBeEnd();
	if (result.nameis("integers")) {
// Special case - _integers is a GBVector<int>
	  result.num(GBGlobals::s_integers().push_back(GBVector<int>()));
	  GBVector<int> & dest =
	    GBGlobals::s_integers().reference(result.num());
	  const GBVector<int> & source1 = 
	    GBGlobals::s_integers().const_reference(m);
	  const GBVector<int> & source2 = 
	    GBGlobals::s_integers().const_reference(n);

	  const_iter_GBVector<int> w = source1.begin();
	  const int sz = source1.size();

	  for (int i=1;i<=sz;++i,++w) {
	    if (!IsMember(source2,*w)) dest.push_back(*w);
          }
	} else if (result.nameis("polynomials")) {
	  result.num(GBGlobals::s_polynomials().push_back(GBList<Polynomial>()));
	  GBList<Polynomial> & dest =
	    GBGlobals::s_polynomials().reference(result.num());
	  const GBList<Polynomial> & source1 = 
	    GBGlobals::s_polynomials().const_reference(m);
	  const GBList<Polynomial> & source2 = 
	    GBGlobals::s_polynomials().const_reference(n);
          dest.clear();
          GBList<Polynomial>::const_iterator w = source1.begin();
          const int sz = source1.size();
          for(int i=1;i<=sz;++i,++w) {
            if (!source2.Member(*w).first()) dest.push_back(*w);
          }
	} else if (result.nameis("rules")) {
	  result.num(GBGlobals::s_rules().push_back(GBList<GroebnerRule>()));
	  GBList<GroebnerRule> & dest =
	    GBGlobals::s_rules().reference(result.num());
	  const GBList<GroebnerRule> & source1 = 
	    GBGlobals::s_rules().const_reference(m);
	  const GBList<GroebnerRule> & source2 = 
	    GBGlobals::s_rules().const_reference(n);
          dest.clear();
          GBList<GroebnerRule>::const_iterator w = source1.begin();
          const int sz = source1.size();
          for(int i=1;i<=sz;++i,++w) {
            if (!source2.Member(*w).first()) dest.push_back(*w);
          }
	} else if (result.nameis("variables")) {
	  result.num(GBGlobals::s_variables().push_back(GBList<Variable>()));
	  GBList<Variable> & dest =
	    GBGlobals::s_variables().reference(result.num());
	  const GBList<Variable> & source1 = 
	    GBGlobals::s_variables().const_reference(m);
	  const GBList<Variable> & source2 = 
	    GBGlobals::s_variables().const_reference(n);
          dest.clear();
          GBList<Variable>::const_iterator w = source1.begin();
          const int sz = source1.size();
          for(int i=1;i<=sz;++i,++w) {
            if (!source2.Member(*w).first()) dest.push_back(*w);
          }
	} else {
	  GBStream << "Invalid marker name " << result.name() << ".\n";
	  DBG();
        }
	result.put(si);
};

AddingCommand temp9p6aux("ComplementMarkers",2,_ComplementMarkers);

// ------------------------------------------------------------------

#ifdef WANT_categoryFactoriesFactControl_NO
void _categoryFactoriesFactControl(Source & so,Sink & si) {
  int n;
  so >> n;
  so.shouldBeEnd();
  Debug1::s_not_supported("categoryFactoriesFactControl is ");
  si.noOutput();
};
AddingCommand temp10p6aux("categoryFactoriesFactControl",1,
                          _categoryFactoriesFactControl);
#endif

// ------------------------------------------------------------------

void _MarkerAdjoint(Source & so,Sink & si) {
  marker m;
  m.get(so);
  stringGB x;  // x is "tp" or "aj" --- make not just "tp" later.
  so >> x;
  so.shouldBeEnd();
  marker result;
  result.name(m.name());
  if(false) {
#ifdef PDLOAD
  } else if(m.nameis("rules")) {
    result.num(GBGlobals::s_rules().push_back(GBList<GroebnerRule>()));
    const GBList<GroebnerRule> & src = 
        GBGlobals::s_rules().const_reference(m.num());
    GBList<GroebnerRule> & dest = GBGlobals::s_rules().reference(result.num());
    GBList<GroebnerRule>::const_iterator w = src.begin();
    const int sz = src.size();
    GBList<Polynomial> aList;
    for(int i=1;i<=sz;++i,++w) {
      aList.push_back(adjoint(*w,"tp"));
    } 
    conversion(aList,dest);
#endif
  } else if(m.nameis("polynomials")) {
    result.num(GBGlobals::s_polynomials().push_back(GBList<Polynomial>()));
    const GBList<Polynomial> & src = 
          GBGlobals::s_polynomials().const_reference(m.num());
    GBList<Polynomial> & dest = 
          GBGlobals::s_polynomials().reference(result.num());
    GBList<Polynomial>::const_iterator w = src.begin(); 
    const int sz = src.size();
    for(int i=1;i<=sz;++i,++w) { 
      dest.push_back(adjoint(*w,"tp")); 
    } 
  } else DBG();
  result.put(si);
};

AddingCommand temp11p6aux("MarkerAdjoint",2,_MarkerAdjoint);
