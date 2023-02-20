// PolyGenerator.h

#ifndef INCLUDED_POLYGENERATOR_H
#define INCLUDED_POLYNOMIALGENERATOR_H

class Polynomial;
class GBHistory;

class PolyGenerator {
public:
  PolyGenerator(){};
  virtual ~PolyGenerator() = 0;
  virtual void addGoal(const Polynomial & p) = 0;
  virtual bool getPolynomialIteration(Polynomial & p,GBHistory & hist) = 0;
  virtual bool fillForNextIteration() = 0;
};
#endif
