// Mark Stankus 1999 (c)
// ReportReduced.hpp

#ifndef INCLUDED_REPORTREDUCED_H
#define INCLUDED_REPORTREDUCED_H

#include "BroadCast.hpp"
#include <list>
class MyOstream;

class ReportReduced : public Recipient {
  MyOstream & d_os;
public:
  ReportReduced(MyOstream & os) : d_os(os) {};
  virtual ~ReportReduced();
  virtual void action(const BroadCastData & x) const;
  virtual Recipient * clone() const;
};
#endif
