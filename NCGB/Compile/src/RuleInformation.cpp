// RuleInformation.c

#include "RuleInformation.hpp"

bool RuleInformation::divides(const RuleInformation & ri,
    Monomial & front,Monomial & back) const {
  bool result = false;
  int m = degree();
  int n = ri.degree();
  if((m==n)&&(d_r.LHS()==ri.d_r.LHS())) {
    front.setToOne();
    back.setToOne();
    result  = true;
  } else if(m<n && 
            dividesDoubleCount(variableDoubleCounts(),
                               ri.variableDoubleCounts())
           ) {
    result = true;
    DBG();
  };
  return result;
};

// Determine if small is a subset of big. Both vectors are sorted.
bool RuleInformation::dividesDoubleCount(const vector<int> & small,
      const vector<int> & big) const {
  bool result = true;
  int szSmall = small.size();
  int szBig = big.size();
  vector<int>::const_iterator ww = big.begin(); 
  vector<int>::const_iterator ee = big.end(); 
  vector<int>::const_iterator w = small.begin(); 
  vector<int>::const_iterator e = small.end(); 
  while(w!=e && result) {
    result = szSmall<=szBig; 
    int n = *w;
    while(szSmall<=szBig&& ww!=ee &&*ww<n) {++ww;--szBig;}
    if(szSmall>szBig || ww==ee) {
      result = false;
    } else {
      result = *ww==n;
    };
    ++w; --szSmall;
  };
  return result;
};

// can use Table[Prime[i],{i,1,n}] to get the first n primes
int RuleInformation::s_primes[100] = 
{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 
  73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 
  157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 
  239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 
  331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 
  421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 
  509, 521, 523, 541};

int RuleInformation::s_number_primes = 100;
