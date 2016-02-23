// Mark Stankus 1999 (c) 
// FCData.hpp

#ifndef INCLUDED_MYOSTREAMDATA_H
#define INCLUDED_MYOSTREAMDATA_H

#include "BroadCast.hpp"
#include "OrdData.hpp"
class MyOstream;
class FactControl;

class FCData : public OrdData {
public:
  static const int s_ID;
  const FactControl &d_fc;
  FCData(const AdmissibleOrder & ord,const FactControl & fc,
       MyOstream & os) : OrdData(s_ID,ord,os), d_fc(fc) {};
};
#endif
