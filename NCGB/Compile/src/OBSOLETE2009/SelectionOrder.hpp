// SelectionOrder.h

#ifndef INCLUDED_SELECTIONORDER_H
#define INCLUDED_SELECTIONORDER_H

//#include "RCountPLock.hpp"
#include "RCountedPLocked.hpp"
#ifndef INCLUDED_BASESELECTIONORDER_H
#include "BaseSelectionOrder.hpp"
#endif
#ifndef INCLUDED_COMPARISONEXTENDED_H
#include "ComparisonExtended.hpp"
#endif

//This is the Selection Order class.  Build one by constructing
//an actual order (as a child of BaseSelectionOrder) and passing in as
//pointer to constructor.

class SelectionOrder {
public:
  SelectionOrder();
  explicit SelectionOrder(BaseSelectionOrder* ord) : 
//   d_ToRemove_p(0), p(RCountPLocked<BaseSelectionOrder>(*ord)) {}
   d_ToRemove_p(0), p(RCountedPLocked<BaseSelectionOrder>(*ord)) {}
  SelectionOrder(const SelectionOrder& ord) : p(ord.p) {}
  SelectionOrder& operator=(const SelectionOrder & ord) {
    if (this != &ord) p = ord.p;
    return *this;
  }
  ~SelectionOrder() {}

  ComparisonExtended compare(const SPI& s, const SPI& t) const { 
    return p().compare(s,t); 
  }
  bool operator() (const SPI& s, const SPI& t) const { 
    return (p().compare(s,t)==ComparisonExtended::s_LESS); 
  }
private:
  BaseSelectionOrder * d_ToRemove_p;
 // RCountPLock<BaseSelectionOrder> p;
  RCountedPLocked<BaseSelectionOrder> p;
};
#endif
