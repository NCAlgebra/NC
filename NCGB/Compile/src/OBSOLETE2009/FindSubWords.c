// FindSubWords.c


#include "FindSubWords.hpp"

int FindSubWords::findMatch(int & start,const Monomial & m) const {
  MonomialIterator w = m.begin();
  for(int i=0;i<start;++i,++w) {};
  const int sz = m.numberOfFactors();
  bool done = false;
  int Min,numLeft=sz - start;
  int result = findValidFirstLetter(start,numLeft,w);
  Monomial current(d_monos[result]);
  int csz = current.numberOfFactors();
  MonomialIterator cw = current.begin();
  int saveNumLeft;
  while(result!=-1 && !done && numLeft>0) {
    Min = (numLeft > csz) ? csz : numLeft; 
    saveNumLeft = numLeft;
    int numberAdvanced = advanceUntilMismatch(numLeft,Min,cw,w);
    if(numberAdvanced==csz) {
      // we are done, we have a match;
      break;
    } else if(numberAdvanced==saveNumLeft) {
      // we ran into the end of the word without making a match
      result = -1;
      break;
    } else {
      // we have to jump to a different monomial now
      // see if there is jump data
      if((int)d_jumps.size()>result) {
        // cannot jump -- do something conservative here. rethink later.
        ++start;
        result = findMatch(start,m);
        break;
      } ;
      bool didJump = false;
      const list<triple<int,int,int> > & L = d_jumps[result];
      int newplace = -999; DBG();
      typedef list<triple<int,int,int> >::const_iterator LI;
      LI w = L.begin();
      LI e = L.end();
      while(w!=e) {
        const triple<int,int,int> & currentplace = *w;
        if(currentplace.first>newplace) break;
        if(currentplace.first==newplace) {
          // do something here
          DBG();
          result = currentplace.second;
          current = d_monos[result];
          // readjust start
          DBG();
          w = L.begin();
          for(int i=0;i<start;++i,++w) {};
          didJump = true;
          break;
        };
        ++w;
      };
      if(!didJump) {
        // cannot jump -- do something conservative here. rethink later.
        ++start;
        result = findMatch(start,m);
        break;
      }; 
    };
  };
  return result;
};

  // first element of the pair is the monomial number
  // second element of the pair is the place where it starts in m.
void FindSubWords::findAllSubWords(const Monomial & m,
       list<pair<int,int> > & L) const {
  int start = 0;
  int sz = m.numberOfFactors();
  pair<int,int> pr;
  while(start<sz) {
    pr.first = findMatch(start,m);
    if(pr.first==-1) break;
    pr.second = start;
    L.push_back(pr);
    ++start;
  };
};

int FindSubWords::advanceUntilMismatch(int & numLeft,int len,
                  MonomialIterator & first1,
                  MonomialIterator & first2) const {
  int result = 0;
  while(numLeft>0 && len>0) {
    if(*first1!=*first2) break;
    --numLeft;++first1;++first2; ++result;--len;
  };
  return result;
};
    
 

int FindSubWords::findValidFirstLetter(int & start,int & numLeft,
                  MonomialIterator & w) const {
  DBG();
  // Move to a valid starting variable
  int m,result=-1;
  bool done = false;
  while(numLeft>0) {
    m = (*w).stringNumber();
    result = d_stringNumberToStartMono[m];
    done = (m>d_sz && result!=-1);
    if(done) break;
    ++w;--numLeft;
  };
  return result;
};

void FindSubWords::setUp(const vector<Monomial> & m) {
  typedef vector<Monomial>::const_iterator VI;
  VI w = m.begin();
  VI e = m.end();
  while(w!=e) {
    setUp(*w);
    ++w;
  };
};

void FindSubWords::setUp(const Monomial & m) {
  const int sz = d_monos.size();
  d_monos.push_back(m);
  setUpFirstVariable(m,sz);
  setUpJumps(m,sz);
};

void FindSubWords::setUpFirstVariable(const Monomial & m,int i) {
  int num = (*m.begin()).stringNumber();
  if(num>=d_sz) {
    d_firstLetters.reserve(num+1);
    d_stringNumberToStartMono.reserve(num+1);
    const list<int> empty;
    for(;d_sz<=num;++d_sz) {
      d_stringNumberToStartMono.push_back(-1);
      d_firstLetters.push_back(empty);
    };
  };
  d_firstLetters[num].push_back(i);
  int & x = d_stringNumberToStartMono[num];
  if(x==-1) {
    x = i; 
  };
};

void FindSubWords::setUpJumps(const Monomial & m,int i) {
  const int sz = m.numberOfFactors();
  if(sz>2) {
    MonomialIterator w2 = m.begin();
    ++w2;
    int j = 2;
    while(j<sz) {
      // Look elsewhere for jumps
      DBG();
      ++j;++w2;
    }; 
  };
};
