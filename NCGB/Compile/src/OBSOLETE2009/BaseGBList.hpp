// BaseGBList.h

#ifndef INCLUDED_BASEGBLIST_H
#define INCLUDED_BASEGBLIST_H

#include "ListChoice.hpp"
#ifdef USE_OLD_GBLIST

class BaseGBList {
  BaseGBList(const BaseGBList &);
  void operator=(const BaseGBList &);
     // Above four not implemented
protected:
// Do not allow creation of BaseGBList's
// Have to create from derived class
   BaseGBList();
   virtual ~BaseGBList();
public:
   int size() const;
   bool empty() const;
protected:
   void incrementSize();
   void decrementSize();
   void zeroSize();
   int _size;
   static bool _DelayedCopying;
};

inline BaseGBList::BaseGBList(){};

inline int BaseGBList::size() const {
  return _size;
};

inline bool BaseGBList::empty() const {
  return size()==0;
};

inline void BaseGBList::zeroSize() {
  _size =0;
};

inline void BaseGBList::incrementSize() {
  ++_size;
};

inline void BaseGBList::decrementSize() { 
  --_size; 
}; 
#endif
#endif
