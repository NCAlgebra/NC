// PDPolyGenerator.h

#ifndef INCLUDED_PDPOLYGENERATOR_H
#define INCLUDED_PDPOLYGENERATOR_H

#include "PolyGenerator.hpp"
#include "GBMatch.hpp"
#include "Reduction.hpp"
#include "MatchGenerator.hpp"
#include "FactControl.hpp"
#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#else
#include <list.h>
#endif
#include "vcpp.hpp"

class PDPolyGenerator : public PolyGenerator {
  list<Match> d_reserve;
  pair<int,int> d_indices;
  GroebnerRule d_first, d_second; 
  FactControl & d_fc;
  Reduction d_currentRules;
  MatchGenerator d_matches;
public:
  PDPolyGenerator(FactControl & fc) : d_fc(fc), 
          d_currentRules(fc), d_matches(fc) {};
  virtual ~PDPolyGenerator();
  virtual bool getPolynomialIteration(Polynomial & p,GBHistory & hist);
  virtual bool fillForNextIteration();
};
#endif
