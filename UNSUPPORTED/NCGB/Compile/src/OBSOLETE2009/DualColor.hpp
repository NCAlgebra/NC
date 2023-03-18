// Mark Stankus (c) 1999
// DualColor.hpp

#ifndef INCLUDED_DUALCOLOR_H
#define INCLUDED_DUALCOLOR_H

template<class ONE,class TWO>
class DualColor {
  ONE d_one;
  TWO d_two;
public:
  DualColor(ONE one,TWO two) : d_one(one), d_two(two) {};
  DualColor(const DualColor & x) : d_one(x.d_one), d_two(x.d_two) {};
  ~DualColor(){};
  void operator=(const DualColor & x) const { 
    d_one=x.d_one;
    d_two=x.d_two;
  };
  void operator=(const ONE& x) const { 
    d_one=x.d_one;
  };
  void operator=(const TWO& x) const { 
    d_two=x.d_two;
  };
  bool operator==(const DualColor & x) const { 
    return d_one==x.d_one && d_one==x.d_one;
  }
  bool operator==(const ONE & x) const { 
    return d_one==x.d_one;
  }
  bool operator==(const TWO & x) const { 
    return d_two==x.d_two;
  }
  bool operator!=(const DualColor & x) const { return !operator==(x); }
  bool operator!=(const ONE & x) const { return !operator==(x); }
  bool operator!=(const TWO & x) const { return !operator==(x); }
};
#endif
