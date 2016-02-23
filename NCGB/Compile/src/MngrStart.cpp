// MngrStart.c

#include "MngrStart.hpp"
#include "MyOstream.hpp"
#include "GBStream.hpp"

MngrStart::MngrStart() : Deselected() {
  DefaultOptions();
};

MngrStart::~MngrStart(){};

void MngrStart::warning1(int n) const {
  WARNStream << "MXS::addDeselect " << n << '\n';     
};

void MngrStart::DefaultOptions() {
  _numberOfIterations = 1;
  _cleanFlag = true;
  _finished = false;
  _cutOffs = false;
  _minNumber =0;
  _sumNumber=0;
};
