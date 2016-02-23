// (c) Mark Stankus 1999
// CompDisplayPart.hpp

#ifndef INCLUDED_COMPDISPLAYPART_H
#define INCLUDED_COMPDISPLAYPART_H

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

using namespace std;

class CompDisplayPart : public DisplayPart {
public:
   CompDisplayPart(){};
   virtual ~CompDisplayPart();
   virtual void perform() const;
   list<ICopy<DisplayPart> > d_list;
};
#endif
