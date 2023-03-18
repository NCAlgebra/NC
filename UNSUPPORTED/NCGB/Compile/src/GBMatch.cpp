// Match.c

#include "GBMatch.hpp"
#ifndef INCLUDED_DEBUG1_H
#include "Debug1.hpp"
#endif
#include "MyOstream.hpp"
#include "Monomial.hpp"

void Match::operator = (const Match & x) {
   if(this!=&x) {
     d_left1 =  x.d_left1;
     d_right1 = x.d_right1;
     d_left2 =  x.d_left2;
     d_right2 = x.d_right2;
   
     subsetMatch = x.subsetMatch;
     overlapMatch = x.overlapMatch;
 
     firstGBData = x.firstGBData;
     secondGBData = x.secondGBData;
   }
};  

void Match::InstanceToOStream(MyOstream & os) const {
  os << "GBMatch[";
  os << const_left1() << ',' << const_right1() << ',' 
     << const_left2() << ',' << const_right2() << ',';
  os << firstGBData << ',';
  os << secondGBData << ']';
};
