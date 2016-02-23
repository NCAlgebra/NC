// Mark Stankus 1999 (c)
// SFSGReduction.c

#include "SFSGReduction.hpp"
#include "SFSGExtra.hpp"
#include "SPIIDSet.hpp"
#include "MatcherMonomial.hpp"

//#define SFSG_DEBUG
//#define SFSG_DEBUG_EASY

SFSGReduction::~SFSGReduction() {};
  
void SFSGReduction::clear() { DBG();};
void SFSGReduction::remove(const SPIID & x) { DBG();};
void SFSGReduction::addFact(const SPIID & x) { DBG();};

void  SFSGReduction::ClearReductionsUsed() { DBG();};

const SPIIDSet & SFSGReduction::ReductionsUsed() const {
  DBG();
  SPIIDSet * s = 0;
  return *s;
};
const SPIIDSet & SFSGReduction::allPossibleReductionNumbers() const{
  DBG();
  SPIIDSet *s = 0;
  return *s;
};

void SFSGReduction::vTipReduction() {};

void SFSGReduction::reduce(Polynomial & p,ReductionHint & hint,const Tag &) {
  bool firsttime = false;
  if(!p.zero()) {
#ifdef DEBUG_SFSG
    GBStream << "Trying to reduce the polynomial:" << p << '\n';
#endif
    ReductionHint HINT = hint;
    MatcherMonomial matcher;
    Field f;
    bool todo = true;
    Monomial toreduce(p.tipMonomial()); 
    Polynomial change;
    while(todo) {
      todo = false;
#ifdef DEBUG_SFSG
      GBStream << "Starting at the beginning of the rules.\n";
#endif
      typedef BIMAP::const_iterator BCI;
      BCI w = d_M.first_begin(), e = d_M.first_end();
      while(w!=e) {
        const BIMAP::PAIR & pr = *w;
        if(pr.first==toreduce) break;
        const Monomial & aliasM = pr.first;
        if(matcher.matchExists(aliasM,toreduce)) {
          // MXS SLOW
          Monomial test(matcher.matchIs().const_left1());
          if(firsttime) {
            d_M.erase(hint.iter());
            firsttime = false;
          };
          test *= aliasM;
          test *= matcher.matchIs().const_right1(); 
          if(!matcher.matchIs().const_left2().one()) DBG(); 
          if(!matcher.matchIs().const_right2().one()) DBG(); 
          if(test!=toreduce) DBG();
          change.doubleProduct(p.tipCoefficient(),
            matcher.matchIs().const_left1(),
            pr.second.first,
            matcher.matchIs().const_right1()
          );
#ifdef DEBUG_SFSG
          GBStream << "After removing tip:" << p << '\n';
#endif
          p.Removetip();
#ifdef DEBUG_SFSG
          GBStream << "Change is :" << change << '\n';
#endif
          p -= change;
#ifdef DEBUG_SFSG
          GBStream << "New value is:" << p << "\n\n\n";
#endif
          if(!p.zero()) {
            typedef BIMAP::iterator BI;
            pair<BI,BI> pr(d_M.equal_range(p.tipMonomial()));
            while(pr.first!=pr.second) {
              // The leading monomial IS in the list
              p -= d_M.item(pr.second);
              if(p.zero()) break;
              f.setToOne();
              f /= p.tipCoefficient();
              p *= f;
              pr = d_M.equal_range(p.tipMonomial());
            };
            if(!p.zero()) {
              todo = true;
              // The leading monomial is not in the list
              d_M.ITER() = pr.first;
              // iter now points after the key higher
              toreduce = p.tipMonomial();
            };
          };
          break;
        }; // if(matcher.matchExists(aliasM,toreduce)) 
        ++w;
      }; // while(w!=e) 
    }; // while(todo) 
  }; //if(!p.zero()) 
  return !firsttime;
};
  
void SFSGReduction::reduce(const Polynomial &,Polynomial &){
  DBG();
};

void SFSGReduction::reduce(const GroebnerRule &,Polynomial &){
  DBG();
};
