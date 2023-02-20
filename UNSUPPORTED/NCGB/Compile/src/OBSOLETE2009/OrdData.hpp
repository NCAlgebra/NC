// Mark Stankus 1999 (c) 
// OrdData.hpp

#ifndef INCLUDED_ORDDATA_H
#define INCLUDED_ORDDATA_H

#include "BroadCastData.hpp"
class MyOstream;
class AdmissibleOrder;

class OrdData : public BroadCastData {
public:
  const AdmissibleOrder & d_ord;
  MyOstream &d_os;
  OrdData(int id,const AdmissibleOrder & ord,MyOstream & os) : 
        BroadCastData(id), d_ord(ord), d_os(os)  {};
};
#endif
