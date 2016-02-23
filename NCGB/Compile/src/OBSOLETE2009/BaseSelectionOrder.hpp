// BaseSelectionOrder.h

#ifndef INCLUDED_BASESELECTIONORDER_H
#define INCLUDED_BASESELECTIONORDER_H

// Code from selectionorder.h from
//   Defines classes for selection strategies on SPIs
//
//   Author: Ben Keller
//   Date: July, 1997

//A selection strategy determines a priority on SPIs.  They are used
//within the SPISet class to determine which SPI will be returned as
//the "next" element.

//The actual selection order class is an envelope for an instantiation
//of the following base class.  (Note: the equality operator is there
//because the RCountPLock class requires it -- it serves no
//purpose whatsoever.)

class SPI;
class ComparisonExtended;

class BaseSelectionOrder {
  BaseSelectionOrder (const BaseSelectionOrder&);
  BaseSelectionOrder& operator= (const BaseSelectionOrder&);
public:
  BaseSelectionOrder(){}
  virtual ~BaseSelectionOrder();
  virtual ComparisonExtended compare(const SPI&, const SPI&) const;
  virtual BaseSelectionOrder* clone() const;
  virtual bool operator==(const BaseSelectionOrder&) const;
};
#endif
