// Mark Stankus 1999 (c)
// Holder.hpp

#ifndef INCLUDED_HOLDER_H
#define INCLUDED_HOLDER_H

class Holder {
  void * d_v;
  int d_ID;
public:
  Holder(void * v,int id) : d_v(v), d_ID(id) {};
  void * ptr() const { return d_v;};
  void * ptr() { return d_v;};
  int ID() const { return d_ID;};
  static void errorh(int);
  static void errorc(int);
}; 

template<class T>
inline void castHolder(Holder & hold,T * & ptr) {
  if(hold.ID()!=T::s_ID) Holder::errorh(__LINE__);
  if(!hold.ptr()) Holder::errorh(__LINE__);
  ptr = (T *)hold.ptr();
};

template<class T>
inline void castHolder(const Holder & hold,T * & ptr) {
  if(hold.ID()!=T::s_ID) Holder::errorh(__LINE__);
  if(!hold.ptr()) Holder::errorh(__LINE__);
  ptr = (T *)hold.ptr();
};
#endif
