// Mark Stankus 1999 (c)
// BroadCastData.hpp

#ifndef INCLUDED_BROADCASTDATA_H
#define INCLUDED_BROADCASTDATA_H

class BroadCastData {
protected:
  int d_ID;
  BroadCastData(int id) : d_ID(id) {};
public:
  BroadCastData() : d_ID(s_ID) {};
  virtual ~BroadCastData();
  virtual bool cancast(int) const;
  static const int s_ID;
};
#endif
