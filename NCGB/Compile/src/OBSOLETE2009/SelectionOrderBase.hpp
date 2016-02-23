// SelectionOrderBase.h

#ifndef INCLUDED_SELECTIONORDERBASE_H
#define INCLUDED_SELECTIONORDERBASE_H

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
//because the RCountedPLocked class requires it -- it serves no
//purpose whatsoever.)

class SPI;
class ComparisonExtended;

class SelectionOrderBase {
  SelectionOrderBase (const SelectionOrderBase&);
    // not implemented
  SelectionOrderBase& operator= (const SelectionOrderBase&);
    // not implemented
public:
  SelectionOrderBase(){}
  virtual ~SelectionOrderBase();
  virtual ComparisonExtended compare(const SPI&, const SPI&) const;
  virtual SelectionOrderBase* clone() const;
  virtual bool operator==(const SelectionOrderBase&) const;
};
#endif
