// OriginalFunctions.h

#ifndef INCLUDED_ORIGINALFUNCTIONS_H
#define INCLUDED_ORIGINALFUNCTIONS_H

class SPI;
class Monomial;
class Polynomial;

bool getSPI(SPI & s);
bool monomialDivides(const Monomial & m,const Monomial & n,int & result);
void reduce1(Polynomial & p,const Polynomial & usedToSimplify,int k);
bool selectCompare(const SPI & r,const SPI & s);
Polynomial spolynomial(const SPI & s);

template<class ITER> void reduceUsingSet(Polynomial & p,ITER w,ITER e);

#endif
