// GBStream.h 

#ifndef INCLUDED_GBSTREAM_H
#define INCLUDED_GBSTREAM_H

// GBStream will always be cerr. If using a Mma notebook, then
// these outputs go to the adjoining terminal, not the Mma
// session.
class MyOstream;
extern MyOstream GBStream;
// NBStream may change from cerr. If using a Mma notebook, then
// these outputs go to the notebook. This is added in anticipation
// of code changes desired by Dell K.
extern MyOstream NBStream;
// DEBStream is cerr. The goal here is to make temporary debugging
// messages a little easier to find.
extern MyOstream DEBBStream;
// WARNStream is cerr. The goal here is to make warnings
// messages a little easier to find.
extern MyOstream WARNStream;
#endif
