// Mark Stankus 1999 (c)

#ifndef INCLUDED_READDOUBLECOLUMNGRAPH_H
#define INCLUDED_READDOUBLECOLUMNGRAPH_H

#include "GraphVertex.hpp"
#include "ColoredGraph.hpp"
#include "TriColor.hpp"
class ifstream;
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif

void readDoubleColumnGraph(ifstream & ifs,set<GraphVertex,less<GraphVertex> > & S, 
              ColoredGraph<GraphVertex,TriColor> & gr,bool forward);
#endif
