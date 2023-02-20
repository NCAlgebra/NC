// ExtendedSPI.h

#ifndef INCLUDED_EXTENDEDSPI_h
#define INCLUDED_EXTENDEDSPI_h

#include "SPI.hpp"
#include "SelectionOrder.hpp"

class ExtendedSPI {
  SelectionOrder & d_sel;
  SPI d_spi;
  bool d_infinity;
public:
  ExtendedSPI(SelectionOrder & sel) : d_sel(sel), d_infinity(true) {};
  ExtendedSPI(SelectionOrder & sel,const SPI & s) : d_sel(sel), 
        d_spi(s), d_infinity(false) {};
  ~ExtendedSPI() {};
  void setInfinity() { d_infinity = true;};
  void setSPI(const SPI & spi) { d_spi = spi; d_infinity = false;};
  bool isInfinity() const { return d_infinity;};
  bool isFinite() const { return !d_infinity;};
  bool operator<(const ExtendedSPI & x) const {
    bool result = false;
    if(d_infinity) {
      if(x.d_infinity) {
        DBG();
      } else {
        result = false;
      };
    } else {
      if(x.d_infinity) {
        result = true;
      } else {
        result = d_sel(d_spi,x.d_spi);
      };
    };
    return result;
  };
};
#endif
