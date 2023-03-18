// MatcherMonomial.c

//#define NEWCODE

#include "MatcherMonomial.hpp"
#include "load_flags.hpp"
#ifdef PDLOAD
#ifndef INCLUDED_SUBMONOMIAL_H
#include "subMonomial.hpp"
#endif

// * * * * * fastSubMatch.c code

bool MatcherMonomial::matchExistsNoRecord(const Monomial & mona,
                                     const Monomial & monb) {
  k = 0; // mutable class variable
  bool result = mona==monb;
  if(!result) {
    int leni = mona.numberOfFactors();
    int lenj = monb.numberOfFactors();
    if(leni<lenj) {
      subMonomial INodei(mona,1,0);
      subMonomial INodej(monb,1,0);

      const int spread = lenj - leni + 1;

      INodei.length(leni);
      INodej.length(leni);
#ifdef NEWCODE
      if(spread>0) {
        Variable v = * mona.begin();
#endif
        for(int tempk = 1; tempk <= spread && !result; ++tempk) {
          if(tempk!=1) {
            INodej.incrementStart();
          }
#ifdef NEWCODE
          tempk = INodej.findVariableForward(spread-tempk+1,v);
          if(tempk==-1) {
            tempk = spread+1;
          } else
#endif
          {
            result = INodei==INodej;
            if(result) k = tempk;
          }
        }
#ifdef NEWCODE
      } else {
        k = 1; // deal with matching against 1
      }
#endif
    }
  }
  return result;
};

bool MatcherMonomial::matchExists(const Monomial & mona,
                             const Monomial & monb) {
  setInternalMatch();
  bool result = matchExistsNoRecord(mona,monb);
  if(result && k > 0) {
    const int beginNum = k-1;
    MonomialIterator iter = monb.begin();
    for(int i = 1; i <= beginNum; ++i,++iter) {
      _theMatch->left1() *= (*iter);
    }
    const int numberFactors = monb.numberOfFactors();
    const int temp2 = k + mona.numberOfFactors();
    if(temp2<=numberFactors) {
      MonomialIterator iter2 = monb.begin();
      int jj = temp2-1;
      while(jj) {++iter2;--jj;};
      for(int j=temp2;j<=numberFactors;++j,++iter2) {
        _theMatch->right1() *= (*iter2);
      }
    }
  }
  return result;
};

void MatcherMonomial::subMatch(const Monomial & mona,int a,
   const Monomial & monb, int b, GBList<Match> & result)  {
  if(mona==monb) {
    Match match;
    match.firstGBData = a;
    match.secondGBData = b;
    match.subsetMatch = true;
    match.overlapMatch = false;
    result.push_back(match);
  } else {
    int leni = mona.numberOfFactors();
    int lenj = monb.numberOfFactors();
    if(leni<lenj) {
      subMonomial INodei(mona,1,0);
      subMonomial INodej(monb,1,0);
  
      const int spread = lenj - leni + 1;
  
      INodei.length(leni);
      INodej.length(leni);
      for(int k=1;k<=spread;++k) {
         if(k>1) INodej.incrementStart();
         if(INodei==INodej) {
            Match match;
            constructMatch(mona,a,monb,b,
               INodei,INodej,SUBSET_MATCH,match);
            result.push_back(match);
         }
      }
    }
  }
};

void MatcherMonomial::overlapMatch(const Monomial & mona,int a,
     const Monomial & monb,int b, GBList<Match> & result) {
   int leni = mona.numberOfFactors();
   int lenj = monb.numberOfFactors();
   int spread = (leni<lenj) ? leni-1 : lenj-1;
   subMonomial INodei(mona,1,0);
   subMonomial INodej(monb,1,0);
   for(int tempk=1;tempk<=spread;++tempk) {
     INodei.length(0);
     if(tempk>1) {
        INodei.decrementStart();
     } else {
        INodei.start(leni);
     }
     INodei.length(tempk); 
     INodej.length(tempk); 
     // special meaning here
     if(INodei==INodej) {
        Match match;
        constructMatch(mona,a,monb,b,
               INodei,INodej,OVERLAP_MATCH,match);
        result.push_back(match);
     }
   }   
};

void MatcherMonomial::overlapMatch(const Monomial & mona,
     const Monomial & monb, list<int> & result) {
   int leni = mona.numberOfFactors();
   int lenj = monb.numberOfFactors();
   int spread = (leni<lenj) ? leni-1 : lenj-1;
   subMonomial INodei(mona,1,0);
   subMonomial INodej(monb,1,0);
//mxs redundent   INodej.start(1);
   for(int tempk=1;tempk<=spread;++tempk) {
     INodei.length(0);
     if(tempk>1) {
        INodei.decrementStart();
     } else {
        INodei.start(leni);
     }
     INodei.length(tempk); 
     INodej.length(tempk); 
     // special meaning here
     if(INodei==INodej) {
        result.push_back(tempk);
     }
   }   
};

void MatcherMonomial::constructMatch( const Monomial & mona,int a,
       const Monomial & monb,int b, const subMonomial & aINode,
       const subMonomial & bINode, MATCHING_TYPES type,
       Match & match ) const {
  match.firstGBData = a;
  match.secondGBData = b;

  const int bStartm1 = bINode.start()-1;
  MonomialIterator iter = monb.begin();
  int i=1;
  for(;i<=bStartm1;++i,++iter) {
    match.left1() *= (* iter);
  }
  const int bNumFactor = monb.numberOfFactors();
  int temp2 = bINode.start()+bINode.length();
  if(temp2<=bNumFactor) {
    MonomialIterator iter2 = monb.begin();
    int jj = temp2-1;
    while(jj) { ++iter2;--jj;};
    for(int j=temp2;j<=bNumFactor;++j,++iter2) {
      match.right1() *= (* iter2);
    }
  }
  if(type==SUBSET_MATCH) {
    match.subsetMatch = false;
    match.overlapMatch = true;  
  } else if(type==OVERLAP_MATCH) {
    match.subsetMatch = false;
    match.overlapMatch = true;
    const int aStartm1 = aINode.start()-1;
    MonomialIterator iter3 = mona.begin(); 
    for(i=1;i<=aStartm1;++i,++iter3) {   
       match.left2() *= (* iter3);
    }   
    MonomialIterator iter4 = mona.begin(); 
    const int temp4 = aINode.start()+aINode.length();
    int jj = temp4-1;
    while(jj) { ++iter4;--jj;};
    for(int j=temp4;j<=mona.numberOfFactors();++j,++iter4) {   
       match.right2() *= (* iter4);
    }   
  }
};

void MatcherMonomial::subMatch(const Monomial & mona,int a,
   const Monomial & monb, int b, list<Match> & result)  {
  if(mona==monb) {
    Match match;
    match.firstGBData = a;
    match.secondGBData = b;
    match.subsetMatch = true;
    match.overlapMatch = false;
    result.push_back(match);
  } else {
    int leni = mona.numberOfFactors();
    int lenj = monb.numberOfFactors();
    if(leni<lenj) {
      subMonomial INodei(mona,1,0);
      subMonomial INodej(monb,1,0);
  
      const int spread = lenj - leni + 1;
  
      INodei.length(leni);
      INodej.length(leni);
      for(int k=1;k<=spread;++k) {
         if(k>1) INodej.incrementStart();
         if(INodei==INodej) {
            Match match;
            constructMatch(mona,a,monb,b,
               INodei,INodej,SUBSET_MATCH,match);
            result.push_back(match);
         }
      }
    }
  }
};

void MatcherMonomial::overlapMatch(const Monomial & mona,int a,
     const Monomial & monb,int b, list<Match> & result) {
   int leni = mona.numberOfFactors();
   int lenj = monb.numberOfFactors();
   int spread = (leni<lenj) ? leni-1 : lenj-1;
   subMonomial INodei(mona,1,0);
   subMonomial INodej(monb,1,0);
   for(int tempk=1;tempk<=spread;++tempk) {
     INodei.length(0);
     if(tempk>1) {
        INodei.decrementStart();
     } else {
        INodei.start(leni);
     }
     INodei.length(tempk); 
     INodej.length(tempk); 
     // special meaning here
     if(INodei==INodej) {
        Match match;
        constructMatch(mona,a,monb,b,
               INodei,INodej,OVERLAP_MATCH,match);
        result.push_back(match);
     }
   }   
};
#endif

void MatcherMonomial::errorh(int n) { DBGH(n); };

void MatcherMonomial::errorc(int n) { DBGC(n); };
