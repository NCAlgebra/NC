// OstreamFix.h

#ifndef INCLUDED_OSTREAM_FIX_H
#define INCLUDED_OSTREAM_FIX_H

#ifdef NEW_CPP

class MyOstream;
#define OSTREAM MyOstream

#else

using namespace std;
#define OSTREAM std::MyOstream
#endif

#endif
