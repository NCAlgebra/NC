// ReductionOrder.h

#ifndef INCLUDED_REDUCTIONORDER_H
#define INCLUDED_REDUCTIONORDER_H

class Polynomial;
class GroebnerRule;

class ReductionOrder {
  ReductionOrder(const ReductionOrder &);
    // not implemented
  void operator=(const ReductionOrder &);
    // not implemented
private:
  static ReductionOrder * s_Current_p;
protected:
  ReductionOrder(){};
public:
  virtual ~ReductionOrder();

  virtual bool less(const Polynomial &,const GroebnerRule &,
                    const Polynomial &,const GroebnerRule &) = 0;
  virtual ReductionOrder * clone() const = 0;
  static void s_setCurrent(ReductionOrder * p);
  static void s_setCurrent();
  static ReductionOrder & s_getCurrent();
  static bool s_currentValid();
  static bool s_tipReduction;
};
#endif
