// Copyright 1996, Benjamin J. Keller
//
// The programs and data structures in this file are provided for use
// within the NCGB system and are not to be altered or distributed to
// others except as part of the NCGB distribution.
// 
// These files are provided with no warranty as to the correctness of
// the results.  Anyone using these files in a system or computation
// the failure of which could cause loss of life, injury or damage to
// equipment assumes the responsibility of any failure.
//

#if(0)
  FTANGLE v1.53, created with UNIX on "Saturday, September 23, 1995 at 16:17." 
  COMMAND LINE: "ftangle -ynf256 suffixtree.web"
  RUN TIME: "Monday, December 9, 1996 at 14:31."
  WEB FILE:    "suffixtree.web"
  CHANGE FILE: (none)

  (This file was continued via @O from suffixtree.C.)
#endif


/* :117 */
/* 118: */
#line 2113 "suffixtree.web"


#ifndef SUFIX_ID_H 
#define SUFIX_ID_H 1 
/* 102: */
#line 1910 "suffixtree.web"

template<class ID>
class SuffixId  {
public:
  SuffixId (const ID& i,const length_type& l, bool p) :
    patt(p), ident(i), len(l)  {}
  const ID& patternID () const  {  return ident;  }
  const length_type& length() const  { return len;  }
private:
  bool patt;
  ID ident;
  length_type len;
  friend bool isPattern(const SuffixId<ID>&);
};
#line 1926 "suffixtree.web"
/* :102 */
#line 2117 "suffixtree.web"

/* 103: */
#line 1927 "suffixtree.web"
\
template<class ID>
inline bool isPattern(const SuffixId<ID>&s_id){
return(s_id.patt);
}

/* :103 */
#line 2118 "suffixtree.web"

#endif SUFIX_ID_H 
#line 2122 "suffixtree.web"
/* :118 */

