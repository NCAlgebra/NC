// Mark Stankus 1999 (c)
// mat.h

#ifndef INCLUDED_MAT_H
#define INCLUDED_MAT_H

#include "Polynomial.hpp"
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <vector>
#else
#include <vector.h>
#endif

class mat {
  vector<vector<Polynomial> > d_L;
  int d_num_rows, d_num_cols;
public:
  struct IDENTITY {};
  struct DIAGONAL {};
  mat(int r,int c) : d_num_rows(r), d_num_cols(c) { 
    Polynomial zero;
    vector<Polynomials> X(c,zero);
    d_L.reserve(r);
    while(r>0) { d_L.push_back(X);};
  };
  mat(vector<Polynomial> & V,DIAGONAL) { 
    d_num_rows = d_num_cols = V.size();
    Polynomial zero;
    vector<Polynomials> X(d_num_cols,zero);
    d_L.reserve(r);
    while(r>0) { d_L.push_back(X);};
    vector<Polynomial>::const_iterator w = V.begin(), e = V.end();
    int i = 1;
    while(w!=e) {
      entry(i,i) = *w;
      ++w;++i;
    };
  };
  mat(int n,IDENTITY) { 
    d_num_rows = d_num_cols = n;
    Polynomial zero;
    vector<Polynomials> X(d_num_cols,zero);
    d_L.reserve(r);
    while(r>0) { d_L.push_back(X);};
    vector<Polynomial>::const_iterator w = V.begin(), e = V.end();
    Term tone;
    Polynomial one;
    one = tone;
    int i = 1;
    while(w!=e) {
      entry(i,i) = one;
      ++w;++i;
    };
  };
  mat(const vector<vector<Polynomial> > & L) : d_L(L) {};
  int cols() const { return d_num_cols;};
  int rows() const { return d_num_rows;};
  const Polynomial & entry(int i,int j) const {
    return d_L[i-1][j-1];
  };
  Polynomial & entry(int i,int j) {
    return d_L[i-1][j-1];
  };
  void listFlattenUnion(set<Polynomial> & result) {
    for(int i=1;i<=r;++i) {
      for(int j=1;j<=c;++j) {
        result.insert(entry(i,j));
      };
    };
  };
};

mat add(const mat &,const mat &);
mat subtract(const mat & m1,const mat & m2);
mat times(const mat & m1,const mat & m2);
#endif
