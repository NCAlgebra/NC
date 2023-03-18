// (c) Mark Stankus 1999
// TellHead.h

#ifndef INCLUDED_TELLHEAD_H
#define INCLUDED_TELLHEAD_H

class Source;
class ISource;

void TellJustHead(Source &);
void TellJustHead(ISource &);
void TellHead(Source &,bool b);
void TellHead(ISource &,bool b);
inline void TellHead(Source & x) {
  TellHead(x,true);
};
inline void TellHead(ISource & x) {
  TellHead(x,true);
};
#endif
