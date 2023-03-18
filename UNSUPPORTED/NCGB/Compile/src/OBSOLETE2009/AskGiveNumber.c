// Mark Stankus 1999 (c)
// AskGiveNumber.c

#include "AskGiveNumber.hpp"
#include "FactControl.hpp"

template<class T>
AskGiveNumber<T>::~AskGiveNumber() {};

template<class T>
int AskGiveNumber<T>::operator()(const Polynomial & p) {
  return d_askee.findInt(p);
};

template<class T>
const GroebnerRule & AskGiveNumber<T>::fact(int num) const {
  return d_askee.fact(num);
};

template<class T>
GiveNumber * AskGiveNumber<T>::clone() const {
  return new AskGiveNumber(d_askee);
};

template<class T>
const vector<int> & AskGiveNumber<T>::perm_numbers() const {
  return d_askee.perm_numbers();
};

template<class T>
void AskGiveNumber<T>::setNotPerm(int n) {
  d_askee.T::setNotPerm(n);
};

template<class T>
void AskGiveNumber<T>::setPerm(int n) {
  d_askee.T::setPerm(n);
};

#if 0 
template<class T>
int AskGiveNumber<T>::findInt(const Polynomial &) const {
  DBG();
  return 0;
};
#endif

#include "CommonPolynomials.hpp"
template class AskGiveNumber<CommonPolynomials>;
