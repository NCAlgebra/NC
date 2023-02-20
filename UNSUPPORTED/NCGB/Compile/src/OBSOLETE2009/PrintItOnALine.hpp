// PrintItOnALine.h

#ifndef INCLUDED_PRINTITONALINE_H
#define INCLUDED_PRINTITONALINE_H

#include "MyOstream.hpp"

class PrintItOnALineBool {
  MyOstream & d_os;
public:
  PrintItOnALineBool(MyOstream & os) : d_os(os) {};
  void operator()(const bool & t);
};

inline void PrintItOnALineBool::operator()(const bool & t){
  if(t) {
    d_os << "true\n";
  } else {
    d_os << "false\n";
  };
};

template<class T>
class PrintItOnALine {
  MyOstream & d_os;
public:
  PrintItOnALine(MyOstream & os) : d_os(os) {};
  void operator()(const T & t);
};

template<class T>
inline void PrintItOnALine<T>::operator()(const T & t){
  d_os << t << '\n';
};
#endif
