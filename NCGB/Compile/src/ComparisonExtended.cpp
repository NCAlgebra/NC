// ComparisonExtended.c

#include "ComparisonExtended.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"

MyOstream & operator <<(MyOstream & os, const ComparisonExtended & x) {
  switch(x.d_value) {
  case 1:
    os << "ComparisonExtended::s_LESS";
    break;
  case 2:
    os << "ComparisonExtended::s_EQUAL";
    break;
  case 3:
    os << "ComparisonExtended::s_EQUIVALENT";
    break;
  case 4:
    os << "ComparisonExtended::s_GREATER";
    break;
  case 5:
    os << "ComparisonExtended::s_INCOMPARABLE";
    break;
  default:
    os << x.d_value << '\n';
    DBG();
  };
  return os;
};


const ComparisonExtended ComparisonExtended::s_LESS(1);
const ComparisonExtended ComparisonExtended::s_EQUAL(2);
const ComparisonExtended ComparisonExtended::s_EQUIVALENT(3);
const ComparisonExtended ComparisonExtended::s_GREATER(4);
const ComparisonExtended ComparisonExtended::s_INCOMPARABLE(5);

