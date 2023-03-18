// Mark Stankus 1999 (c)

#ifndef INCLUDED_READSINGLECOLUMN_H
#define INCLUDED_READSINGLECOLUMN_H

#include "GraphVertex.hpp"
#include "ColoredGraph.hpp"
#include "TriColor.hpp"
class ifstream;

void readSingleColumn(ifstream & ifs,ColoredGraph<GraphVertex,TriColor> & gr);
#endif
