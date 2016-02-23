// Mark Stankus 1999 (c)
// BroadCastData.cpp

#include "BroadCastData.hpp"
#include "idValue.hpp"
#include "GBStream.hpp"
#include "MyOstream.hpp"

  
BroadCastData::~BroadCastData()  {};

bool BroadCastData::cancast(int id) const {
  bool result = d_ID==id;
  if(!result) {
    GBStream << "mismatch between " << id << " and " << d_ID; 
    int num = numberOfIdStrings();
    if(0<=id && id<=num) {
       GBStream << id << " corresponds to " << idString(id) << '\n';
    };
    if(0<=d_ID && d_ID<=num) {
       GBStream << d_ID << " corresponds to " << idString(d_ID) << '\n';
    };
  };
  return result;
};

const int BroadCastData::s_ID = idValue("BroadCastData::s_ID");
