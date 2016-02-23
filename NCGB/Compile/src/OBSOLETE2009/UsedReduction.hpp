// UsedReduction.h

#ifndef INCLUDED_USEDREDUCTION_H
#define INCLUDED_USEDREDUCTION_H

class FactControl;

class UsedReduction {
  UsedReduction();
    // not implemented
  UsedReduction(const UsedReduction &);
    // not implemented
public:
  explicit UsedReduction(const FactControl & fc);
  ~UsedReduction();
  bool passed(int n) const;
private:
  const FactControl & _fc;
};

inline ReductionsUsed::UsedReduction(const FactControl & fc) : _fc(fc) {};

inline  bool ReductionsUsed::passed(int n) const { 
  return true;
};
#endif
