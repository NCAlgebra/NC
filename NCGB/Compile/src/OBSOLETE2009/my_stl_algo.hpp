// my_stl_algo.h

#ifndef INCLUDED_MY_STL_ALGO_H
#define INCLUDED_MY_STL_ALGO_H

template<class In,class Out,class Pred>
Out copy_if(In first,In last,Out res,Pred p) {
  while(first!=last) {
    if(p(*first)) *res++ = * first;
    ++first;
  };
  return res;
};

template<class ITER,class FUNC,class TIME,class TIMEITER>
bool for_all_make1(ITER w,ITER e,FUNC f,TIME t,TIMEITER tw,TIMEITER te) {
  bool result = false;
  while(w!=e) {
    if((*tw)<t) {
      result = true;
      f(*w);
      (*tw)->setToNow();
      TIME::s_IncrementClock();
    }
    ++w;++tw;
  };
  return result;
};

template<class ITER,class FUNC,class TIME,class TIMEITER>
void for_all_make(ITER w,ITER e,FUNC f,TIME t,TIMEITER tw,TIMEITER te) {
  while(for_all_make1(w,e,f,t,tw,te)) {};
};

template<class ITER,class FUNC,class T>
ITER for_all_till(ITER w,ITER e,FUNC f, const T & x) {
  while(w!=e) {
    if(t>=f(*w)) break;
    ++w;
  };
  return w;
};

#if 0
template<class CONT,class FUNC,class T>
ITER  for_all_set(CONT & c,FUNC f,T *) {
  T xx;
  bool todo = c.first(xx);
  while(todo) {
    f(xx);
    todo = c.next(xx);
  };
};
#endif

template<class ITER>
void delete_each_pointer(ITER first,ITER last) {
  while(first!=last) {
    delete *first; 
    ++first;
  };
};

template <class InputIterator1, class InputIterator2>
inline bool equal_via_pointer(InputIterator1 first1, InputIterator1 last1,
                  InputIterator2 first2) {
  for ( ; first1 != last1; ++first1, ++first2)
    if (*first1 != *first2)
      return false;
  return true;
}

template<class InputIterator,class OutputIterator,class T>
inline void copynew(InputIterator first, InputIterator last,
    OutputIterator result,T *) {
  T * p;
  for( ; first != last; ++result, ++first) {
    p =  *first;
    *result = p ? new T(*p) : 0;
  };
};
#endif
