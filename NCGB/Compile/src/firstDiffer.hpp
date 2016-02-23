// firstDiffer.h

#ifndef INCLUDED_FIRSTDIFFER_H
#define INCLUDED_FIRSTDIFFER_H

#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif

int  firstDiffer(const GBVector<int> & aList, const GBVector<int> & bList);
bool IsMember(const GBVector<int> & aList,int n);

#endif
