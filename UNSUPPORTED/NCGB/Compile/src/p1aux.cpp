// p11c_aux1.c

#include "GBIO.hpp"
#include "Command.hpp"
#include "RecordHere.hpp"
#include "GBOutputSpecial.hpp"
#include "Debug1.hpp"
#include "FactControl.hpp"
#include "GBGlobals.hpp"
#include "GBVector.hpp"
#include "MngrStart.hpp"
#include "PDRRFactory.hpp"
#include "PDRemoveRedundent.hpp"
#include "RemoveRedundent.hpp"
#include "MyOstream.hpp"
#include "marker.hpp"
#include "RA1.hpp"
#include "RA5.hpp"
#include "Source.hpp"
#include "Sink.hpp"

class MngrStart;
extern MngrStart * run;

#if 0
PDRRFactory * s_PDRRFactory_temp = 0;

RemoveRedundent * temp_RR_measure_start() {
  RECORDHERE(s_PDRRFactory_temp = new PDRemoveRedundent(*run);)
  return s_PDRRFactory_temp->create();
};

void temp_RR_measure_end(RemoveRedundent * p) {
  RECORDHERE(delete s_PDRRFactory_temp;)
  RECORDHERE(delete p;)
};

#endif


// ------------------------------------------------------------------

#ifdef WANT_internalRemoveRedundent_NO
void _internalRemoveRedundent(Source & so,Sink & si) {
#if 1
  Debug1::s_not_supported("internalRemoveRedundent");
#else
  int *  input;
  long len;
  int *  protectedList;
  long protectedLength;
  bool shouldDisOwnInput =  false;
  bool shouldDisOwnprotectedList =  false;
  if(GBInputIntArray(input,len,so)) {
    shouldDisOwnInput = true;
    if(GBInputIntArray(protectedList,protectedLength,so)) {
      shouldDisOwnprotectedList = false;
      so.shouldBeEnd();
      RemoveRedundent * rr = temp_RR_measure_start();
      rr->setDesiredLeafs(input,len);
//      rr->setProtectedLeafs(protectedList,protectedLength);
      vector<int> vec(rr->tryToEliminate());
      GBOutputSpecial(vec,ioh);
      temp_RR_measure_end(rr);
   }
  }
  if(shouldDisOwnInput) Disown(input,len,ioh);
  if(shouldDisOwnprotectedList) Disown(protectedList,protectedLength,ioh);
#endif
};  /* _internalRemoveRedundent */
AddingCommand temp1p1aux("internalRemoveRedundent",2,internalRemoveRedundent);
#endif

// ------------------------------------------------------------------

#ifndef INCLUDED_MARKER_H
#include "marker.hpp"
#endif

#ifdef WANT_internalMarkerMarkerRemoveRedundent_NO
void _internalMarkerMarkerRemoveRedundent(Source & so,Sink & si) {
#if 1
  Debug1::s_not_supported("internalMarkerMarkerRemoveRedundent");
#else
  marker integerMarker;
  integerMarker.getNamed("integers",so);

  marker factControlMarker;
  factControlMarker.getNamed("factcontrol",so);
 
  so.shouldBeEnd();
  const FactControl & fc = GBGlobals::s_factControls.const_reference(
       factControlMarker.number);
  const GBVector<int> & ints = GBGlobals::s_integers.const_reference(
       integerMarker.number);
 RemoveRedundent * rr = temp_RR_measure_start();
  RemoveRedundent rr(fc);
  rr.setDesiredLeafsVector(ints);
  GBVector<int> vec(rr.tryToEliminate());
  marker result(si);
  result.name("integers");
  result.number = GBGlobals::s_integers.push_back(vec);
  result.put();
#endif
};  /* _internalMarkerMarkerRemoveRedundent */
AddingCommand temp2p1aux("internalMarkerMarkerRemoveRedundent",
     2,_internalMarkerMarkerRemoveRedundent);
#endif

// ------------------------------------------------------------------

#ifdef WANT_CPPRemoveRedundent_NO
void _CPPRemoveRedundent(Source & so,Sink & si) {
  marker fcM,intM;
  fcM.getNamed("factcontrol",so);
  intM.getNamed("integers",so);
  so.shouldBeEnd();
#if 1
  const FactControl & fc = 
        GBGlobals::s_factControls.const_reference(fcM.num());
#endif
  const GBVector<int> & nums = 
        GBGlobals::s_integers.const_reference(intM.num());
#if 1
  PDRemoveRedundent rr(fc);
  rr.setDesiredLeafsVector(nums);
  vector<int> vec(rr.tryToEliminate());
  GBOutputSpecial(vec,si);
#else
GBStream << "Avoiding remove redundent...need to fix.\n";
  GBOutputSpecial(nums,si);
#endif
};  /* _CPPRemoveRedundent */
AddingCommand temp3p1aux("CPPRemoveRedundent",2,_CPPRemoveRedundent);
#endif

// ------------------------------------------------------------------

#ifdef WANT_fastRemoveRedundent_NO
void _fastRemoveRedundent(Source & so,Sink & si) {
#if 1
  Debug1::s_not_supported("_fastRemoveRedundent");
#else
// fastRemoveRedundent[GBMarker[factControlN,\"factcontrol\"],
//    GBMarker[ruleN,\"rules\"]]", "{factControlN,ruleN}" issue      
  marker fcM,rM;
  fcM.getNamed("factcontrol",fcM);
  rM.getNamed("rules",rM);
  int factControlN = fcM.num(), ruleN=rM.num();
  so.shouldBeEnd();
  const FactControl & fc = 
         GBGlobals::s_factControls.const_reference(factControlN);
  RemoveRedundent rr(fc);
  GBVector<int> ruleNumbers;
  const GBList<GroebnerRule> & source = 
     GBGlobals::s_rules.const_reference(ruleN);
  const int sz = source.size();
  GBList<GroebnerRule>::const_iterator w = source.begin();
  const int sz2 = fc.numberOfFacts();
  int temp;
  for(int i=1;i<=sz;++i,++w) {
    temp = -1;
    for(int j=1;j<=sz2;++j) {
      if(fc.fact(j)==(*w)) {
        temp = j;
        break;
      }
    }
    if(temp==-1) DBG();
    ruleNumbers.push_back(temp); 
    rr.setDesiredLeafsVector(ruleNumbers);
    GBVector<int> vec(rr.tryToEliminate());
    GBOutputSpecial(vec,si);
  }
#endif
};
AddingCommand temp4p1aux("fastRemoveRedundent",2,_fastRemoveRedundent);
#endif

void _RulesFromFCAndNumbers(Source & so,Sink & si) {
  marker fcm,intsm;
  fcm.getNamed("factcontrol",so);
  intsm.getNamed("integers",so);
  so.shouldBeEnd();
  const FactControl & fc = GBGlobals::s_factControls().const_reference(fcm.num());
  const GBVector<int> & ints = 
      GBGlobals::s_integers().const_reference(intsm.num());
  const long sz = (long) ints.size();
  Sink sink(si.outputFunction("List",sz));
  GBVector<int>::const_iterator w = ints.begin(); 
  for(long i=1L;i<=sz;++i,++w) {
    sink << fc.fact(*w);
  };
};

AddingCommand temp5p1aux("RulesFromFCAndNumbers",2,_RulesFromFCAndNumbers);
