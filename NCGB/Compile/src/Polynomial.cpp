// (c) Mark Stankus 1999
// Polynomial.c

#include "ChoicePolynomial.hpp"
#ifdef USE_POLYNOMIAL_NN
#include "Choice.hpp"
#include "nnPolynomial.cpp"
#endif
#ifdef USE_POLYNOMIAL_O
#include "Choice.hpp"
#include "oPolynomial.cpp"
#endif
