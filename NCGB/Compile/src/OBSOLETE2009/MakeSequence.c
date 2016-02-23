// Mark Stankus 1999 (c)
// MakeSequence.cpp

#include "Monomial.hpp"
#include "Source.hpp"
#include "GBInput.hpp"
#include "Sink.hpp"
#include "Command.hpp"
#include "PrintVector.hpp"
#include "PrintList.hpp"
#include "Debug1.hpp"
#include "MyOstream.hpp"
#include <vector>
#include <list>
#include <pair.h>


void constructVector(Monomial & x,vector<pair<int,char> > & vec) {
  pair<int,char> pr;
  vec.clear();
  int sz = x.numberOfFactors();
  if(sz==0) {
    // do nothing
  } else if(sz==1) {
    pr.first = 1;
    pr.second = 'C'; // Constant
    vec.push_back(pr);
  } else {
    MonomialIterator w = x.begin();
    MonomialIterator e = x.end();
    int last = (*w).stringNumber();
    ++w;
    int next = (*w).stringNumber();
    if(last<next) {
      pr.second = 'I'; // increasing
    } else if(last==next) {
      pr.second = 'C'; // constant
    } else {
      pr.second = 'D'; // decreasing
    };
    pr.first = 1;
    while(1) {
      if(pr.second=='I') {
        if(last<next) {
          ++pr.first;
        } else if(last==next) {
          vec.push_back(pr);
          pr.first = 2;
          pr.second = 'C';
        } else {
          vec.push_back(pr);
          pr.first = 2;
          pr.second = 'D';
        };
       } else if(pr.second=='C') {
        if(last<next) {
          vec.push_back(pr);
          pr.first = 2;
          pr.second = 'I';
        } else if(last==next) {
          ++pr.first;
        } else {
          vec.push_back(pr);
          pr.first = 2;
          pr.second = 'D';
        };
       } else if(pr.second=='D') {
        if(last<next) {
          vec.push_back(pr);
          pr.first = 2;
          pr.second = 'I';
        } else if(last==next) {
          vec.push_back(pr);
          pr.first = 2;
          pr.second = 'C';
        } else {
          ++pr.first;
        };
       } else DBG();
       ++w;
       if(w==e) break;
       last = next;
       next = (*w).stringNumber();
    };
    if(pr.first!=1) vec.push_back(pr);
  };
};

void PrintTheSequence(const vector<pair<int,char> > & vec) {
  typedef vector<pair<int,char> >::const_iterator VI;
  VI w = vec.begin(), e = vec.end();
  while(w!=e) {
    const pair<int,char> & pr = *w;
    GBStream << ' ' << pr.first << ' ' << pr.second << ' ';
    ++w;
  };
  GBStream << '\n';
};

void _PrintSequence(Source & so,Sink & si) {
  Monomial m;
  so >> m;
  so.shouldBeEnd();
  si.noOutput();
  vector<pair<int,char> > vec;
  constructVector(m,vec);
  GBStream << "monomial:" << m << '\n';
  PrintTheSequence(vec);
};

AddingCommand temp1MakeSequence("PrintSequence",1,_PrintSequence);

void checkDisibilitySimple(list<int> & result,int item,
     const Monomial & big,const vector<pair<int,char> > & bigV,
     const Monomial & small,int single,int num) {
#if 1
  GBStream << "num:" << num <<'\n';
  result.push_back(num);
#else
  DBG();
#endif
};

void checkDisibilityComplicated(list<int> & result,
     int item,const Monomial & big,const vector<pair<int,char> > & bigV,
     const Monomial & small,const vector<pair<int,char> > & smallV,
     const pair<int,bool> & pr,int num) {
#if 1
  int ssz = smallV.size();
  typedef vector<pair<int,char> >::const_iterator VI;
  int place=num+1;
  bool flag = true;
  for(int i=1;i<ssz;++i,++place) {
    if(bigV[place]!=smallV[i]) {
      flag = false;
      break;
    };
  };
  if(flag && bigV[place]>=smallV[ssz-1]) {
//    GBStream << "num:" << num <<'\n';
    result.push_back(num);
  };
#else
  DBG();
#endif
};

void checkDivisibility(list<int> & result,const Monomial & big,
        const vector<pair<int,char> > & bigV,const Monomial & small,
        const vector<pair<int,char> > & smallV) {
  typedef vector<int>::const_iterator VCI;
  const int ssz = smallV.size();
  const int bsz = bigV.size();
  int len = 1, num = 0, item;
  int diff = bsz-ssz;
  if(diff<0) {
    // do nothing
  } else if(ssz==1) {
    int single = smallV.front().first;
    typedef vector<pair<int,char> >::const_iterator VI;
    VI w = bigV.begin(), e = bigV.end();
    while(w!=e) {
      checkDisibilitySimple(result,item,big,bigV,small,single,num);
      --len;
      len += (*w).first;
      ++w;++num;
    };
  } else {
    const pair<int,char> & singlepair = smallV.front();
    int singlenum = singlepair.first;
    char singlechar = singlepair.second;
    typedef vector<pair<int,char> >::const_iterator VI;
    VI w = bigV.begin(), e = bigV.end();
    int count = 0;
#if 0 
    GBStream << "length of bigV " << (int) bigV.size() << '\n';
    GBStream << "count is " << count << '\n';
    GBStream << "diff is " << diff << '\n';
#endif
    while(w!=e && count <=diff) {
#if 0
      GBStream << "count is " << count << '\n';
      GBStream << "diff is " << diff << '\n';
#endif
      const pair<int,char> & pr = *w;
#if 0
      GBStream << "comparing " << pr.first << ' ' << pr.second 
               << " against " << singlenum << ' ' << singlechar << '\n';
#endif
      if(pr.second==singlechar && pr.first>=singlenum) {
        checkDisibilityComplicated(result,item,big,bigV,small,smallV,pr,num);
      };
      --len;
      len += (*w).first;
      ++w;++num;++count;
    };
  };
};

void _PrintSequenceDivides(Source & so,Sink & si) {
  Monomial m,n;
  so >> m >> n;
  so.shouldBeEnd();
  si.noOutput();
  vector<pair<int,char> > vec1,vec2;
  constructVector(m,vec1);
  constructVector(n,vec2);
  GBStream << "monomial:" << m << '\n';
  PrintTheSequence(vec1);
  GBStream << "monomial:" << n << '\n';
  PrintTheSequence(vec2);
  list<int> result;
  checkDivisibility(result,m,vec1,n,vec2);
  PrintList("Places:",result);
};

AddingCommand temp2MakeSequence("PrintSequenceDivides",2,_PrintSequenceDivides);
