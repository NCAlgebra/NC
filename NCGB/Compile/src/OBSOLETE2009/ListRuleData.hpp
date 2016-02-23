// Mark Stankus 1999 (c) 
// ListRuleData.hpp

#ifndef INCLUDED_LISTRULEDATA_H
#define INCLUDED_LISTRULEDATA_H

#include "BroadCast.hpp"
#include "VariableSet.hpp"
#include <list>
class MyOstream;
class AdmissibleOrder;

class ListRuleData : public OrdData {
  const list<GroenberRule> & d_L;
  const VariableSet & d_knowns;
  const VariableSet & d_unknowns;
  static const int s_ID;
public:
  ListRuleData(const AdmissibleOrder & ord,MyOstream & os,
     list<GroebnerRule> & L,constVariableSet & knowns,
     const VariableSet & unknowns) : OrdData(s_ID,ord,os), 
      d_L(L), d_knowns(knowns), d_unknowns(unknowns) {};
  const list<GroebnerRule> & rules() const {
    return d_L;
  };
};
#endif
