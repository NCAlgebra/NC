// numberCounter.hpp

#ifndef INCLUDED_NUMBERCOUNTER_H
#define INCLUDED_NUMBERCOUNTER_H

// d_n holds the actual value if d_done is true.
// d_n <= the actual value if d_done is false.
// after f_func is called with integer n, the return value
//     is <=actual_value and if >n if the actual value>n.
//     and is ==n if the actual value==n.

template<class T>
class numberCounter {
  const T * d_t_p;
  int f_func(const T &,int,bool &);
  int d_n;
  bool d_done;
public:
  numberCounter(const T & t,int func(const T &,int,bool &),int n,bool b) 
        : d_t_p(&t), f_func(func), d_n(n), d_done(b) {};
  numberCounter(const numberCounter & x) :
        : d_t_p(x.d_t_p), f_func(x.f_func), d_n(x.d_n), d_done(x.d_done) {};
  void operator=(const numberCounter & x) {
    d_t_p = x.d_t_p;
    f_func = x.f_func; 
    d_n=x.d_n;
    d_done=x.d_done;
  };
  void assign(int n,bool b) {
    d_n = n;
    d_done = b;
  };
  bool operator==(int n) const {
    if(!d_done) {
      d_n = f_func(*d_t_p,n,d_done);
    };
    bool result = n==d_n;
    return result;
  };
  bool operator>(int n) const {
    bool result = d_n>n;
    if(!result && !d_done) {
      d_n = f_func(*d_t_p,n,d_done);
      result = d_n>n;
    };
    return result;
  };
  bool operator>(int n) const {
    bool result = d_n>=n;
    if(!result && !d_done) {
      d_n = f_func(*d_t_p,n,d_done);
      result = d_n>=n;
    };
    return result;
  };
  void modify() { d_done = false;};
  void modify(int n) { d_n = n; d_done = false;};
};
#endif
