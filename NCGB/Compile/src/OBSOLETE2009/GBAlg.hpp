// GBAlg.h

#ifndef INCLUDED_GBALG_H
#define INCLUDED_GBALG_H

class Reduce;
class PolySource;
class RuleSet;
class MyOstream;

class GBAlg  {
  const bool d_user_created;
protected:
  Reduce     & d_reduce;
  PolySource & d_poly_source;
  RuleSet    & d_rules;
public:
  GBAlg(bool user_created,Reduce & reduce,PolySource & poly_source,
     RuleSet & rules) : d_user_created(user_created), d_reduce(reduce),
       d_poly_source(poly_source), d_rules(rules) {};
  virtual ~GBAlg() = 0;
  virtual bool perform() = 0;
  void print(MyOstream & os);
};
#endif
