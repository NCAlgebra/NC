// Mark Stankus 1999 (c)
// RuleIDSet.h

#ifndef INCLUDED_RULEIDSET_H
#define INCLUDED_RULEIDSET_H

class RuleIDSetImpl;
class RuleOrder;
class RuleID;

class RuleIDSet {
  RuleIDSetImpl * d_p;
  int d_sz;
public:
  RuleIDSet();
  RuleIDSet(RuleOrder);
  RuleIDSet(const RuleIDSet &);
  void operator=(const RuleIDSet &);
  ~RuleIDSet();
  bool firstRuleID(RuleID & id);
  bool nextRuleID(RuleID & id);
  void insert(const RuleID & id);
  void remove(const RuleID & id);
  const int size() const { 
    return d_sz;
  };
  const RuleIDSetImpl & impl() const { 
    return *d_p;
  };
  void clear();
  bool operator==(const RuleIDSet & x) const;
  bool operator!=(const RuleIDSet & x) const { 
    return ! operator==(x);
  };
};
#endif
