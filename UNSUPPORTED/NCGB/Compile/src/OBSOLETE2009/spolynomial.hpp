// spolynomial.h

#ifndef INCLUDED_SPOLYNOMIAL_H
#define INCLUDED_SPOLYNOMIAL_H

#include "TimingInts.hpp"

class TimingRecorder;

class Polynomial;
class SPI;
class FactBase;

Polynomial spolynomial(const SPI &,const FactBase &,TimingRecorder *);

#endif
