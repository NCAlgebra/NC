// SPIID.h

#ifndef INCLUDED_SPIID_H
#define INCLUDED_SPIID_H

class MyOstream;

class SPIID {
public:
  SPIID() : d_data(-999) {};
  SPIID(int n) : d_data(n) {};
  bool operator<(const SPIID & x) const {
    return d_data<x.d_data;
  };
  bool operator==(const SPIID & x) const {
    return d_data==x.d_data;
  };
  bool operator!=(const SPIID & x) const {
    return d_data!=x.d_data;
  };
  int d_data;
};

MyOstream & operator<<(MyOstream & os,const SPIID & x);
#endif
