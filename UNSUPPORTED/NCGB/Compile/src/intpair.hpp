// intpair.h

#ifndef INCLUDED_INTPAIR_H
#define INCLUDED_INTPAIR_H

class MyOstream;

class intpair {
public:
  intpair(){};
  intpair(const bool & t,const int & u) : d_t(t),
    d_u(u) {};
  intpair(const intpair & x) : d_t(x.d_t), d_u(x.d_u) {};
  ~intpair(){};
  void operator = (const intpair & x) {
    d_t = x.d_t;
    d_u = x.d_u;
  };
  bool operator==(const intpair & x) const {
    return d_t==x.d_t && d_u==x.d_u;
  };
  bool operator !=(const intpair & x) const {
    return !operator==(x);
  };

  // accessors
  inline const bool & first() const {
    return d_t;
  };
  inline int second() const {
    return d_u;
  };
  inline void first(bool t) { d_t = t;};
  inline void second(int u) { d_u = u;};

  MyOstream & InstanceToOStream(MyOstream & os) const;
  friend MyOstream & operator << (MyOstream & os,const intpair & aPair);
private:
  bool d_t;
  int d_u;
};
#endif
