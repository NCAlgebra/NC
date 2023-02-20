// Mark Stankus 1999 (c)
// GBLoop.hpp

#ifndef INCLUDED_GBLOOP_H
#define INCLUDED_GBLOOP_H

class PolySource;
class Tag;
class Reduction;
class BroadCast;
class GiveNumber;

void GBLoop(PolySource &,Tag &,Reduction &,Tag *,BroadCast &,bool &,GiveNumber &);
#endif
