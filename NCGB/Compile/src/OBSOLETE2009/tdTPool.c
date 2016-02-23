// Mark Stankus (c) 1999
// tdTPool.cpp

#include "Choice.hpp"
#ifdef USE_UNIX
#include "tdPool.c"
#else
#include "tdPool.cpp"
#endif

//#ifdef USE_BIMAP

#include "PDReduction.hpp"
#include "Tag.hpp"
#include "GBVector.hpp"
#include "Choice.hpp"
#include "Polynomial.hpp"
#include "GroebnerRule.hpp"
#include "GBHistory.hpp"
#include "GBList.hpp"
#include "BroadCast.hpp"
#include "TipDistinct.hpp"
#ifdef USE_BIMAP
#include "BiMap.hpp"
#endif
#include "Monomial.hpp"
#include "Polynomial.hpp"
#include "SFSGExtra.hpp"
#include "ByAdmissible.hpp"
#include "ConstantGiveNumber.hpp"
#include "SFSGRules.hpp"
#include "FactControl.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif

const char * tdPool<IntTag>::s_poolname = "IntTag";
const char * tdPool<list<GBHistory> >::s_poolname = "list<GBHistory>";
const char * tdPool<list<Variable> >::s_poolname = "list<Variable>";
const char * tdPool<list<Polynomial> >::s_poolname = "list<Polynomial>";
const char * tdPool<list<GroebnerRule> >::s_poolname = "list<GroebnerRule>";
const char * tdPool<GBList<Variable> >::s_poolname = "GBList<Variable>";
const char * tdPool<GBList<Polynomial> >::s_poolname = "GBList<Polynomial>";
const char * tdPool<GBList<GroebnerRule> >::s_poolname = "GBList<GroebnerRule>";
const char * tdPool<GBVector<int> >::s_poolname = "GBVector<int>";
const char * tdPool<BroadCast>::s_poolname = "BroadCast";
const char * tdPool<TipDistinct>::s_poolname = "TipDistinct";
const char * tdPool<ConstantGiveNumber>::s_poolname = "ConstantGiveNumber";
const char * tdPool<SFSGRules>::s_poolname = "SFSGRules";
const char * tdPool<FactControl>::s_poolname = "FactControl";
#ifdef USE_BIMAP
const char * tdPool<BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible>
     >::s_poolname = "BiMap";
#endif


template class tdPool<IntTag>;
template class tdPool<list<GBHistory> >;
template class tdPool<list<Variable> >;
template class tdPool<list<Polynomial> >;
template class tdPool<list<GroebnerRule> >;
template class tdPool<GBList<Variable> >;
template class tdPool<GBList<Polynomial> >;
template class tdPool<GBList<GroebnerRule> >;
template class tdPool<GBVector<int> >;
template class tdPool<BroadCast>;
template class tdPool<TipDistinct>;
template class tdPool<ConstantGiveNumber>;
template class tdPool<SFSGRules>;
template class tdPool<FactControl>;
#ifdef USE_BIMAP
template class tdPool<BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible>  >;
#endif


#include "StartEnd.hpp"
#include "Names.hpp"

struct DoForPools : public AnAction {
  DoForPools() : AnAction("DoForPools") {};
  void action() {
    AddPool temp2tdPool("IntTag",new tdPool<IntTag>);
    AddPool temp3tdPool("list<GBHistory>",new tdPool<list<GBHistory> >);
    AddPool temp4tdPool("list<Variable>",new tdPool<list<Variable> >);
    AddPool temp5tdPool("list<Polynomial>",new tdPool<list<Polynomial> >);
    AddPool temp6tdPool("list<GroebnerRule>",new tdPool<list<GroebnerRule> >);
    AddPool temp7tdPool("GBList<Variable>",new tdPool<GBList<Variable> >);
    AddPool temp8tdPool("GBList<Polynomial>",new tdPool<GBList<Polynomial> >);
    AddPool temp9tdPool("GBList<GroebnerRule>",new tdPool<GBList<GroebnerRule> >);
    AddPool temp10tdPool("GBVector<int>",new tdPool<GBVector<int> >);
    AddPool temp12tdPool("BroadCast",new tdPool<BroadCast>);
    AddPool temp13tdPool("TipDistinct",new tdPool<TipDistinct>);
    AddPool temp14tdPool("ConstantGiveNumber",new tdPool<ConstantGiveNumber>);
    AddPool temp15tdPool("SFSGRules",new tdPool<SFSGRules>);
    AddPool temp16tdPool("FactControl",new tdPool<FactControl>);
#ifdef USE_BIMAP
    AddPool temp7tPool("BiMap",
        new tdPool<BiMap<Monomial,Polynomial,ReductionHint,ByAdmissible>  >);
#endif
  };
};

AddingStart temp1Pools(new DoForPools);
