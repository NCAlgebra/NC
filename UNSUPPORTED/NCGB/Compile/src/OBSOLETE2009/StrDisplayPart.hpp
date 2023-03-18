// (c) Mark Stankus 1999
// StrDisplayPart.hpp

#ifndef INCLUDED_STRDISPLAYPART_H
#define INCLUDED_STRDISPLAYPART_H

#include "DisplayPart.hpp"
#include "ICopy.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

class MyOstream;

class StrDisplayPart : public DisplayPart {
   char * * d_strs;
   MyOstream & d_os;
public:
   StrDisplayPart(MyOstream & os,char *strs[]) : d_strs(strs), d_os(os) {};
   virtual ~StrDisplayPart();
   virtual void perform() const;
   list<ICopy<DisplayPart> >  d_list;
};
#endif
