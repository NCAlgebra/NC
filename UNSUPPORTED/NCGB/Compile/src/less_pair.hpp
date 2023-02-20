// less_pair.hpp

#ifndef INCLUDED_LESS_PAIR_H
#define INCLUDED_LESS_PAIR_H

class less_pair {
public:
  bool operator()(const pair<int,int> & x,const pair<int,int> & y) const {
    return x.first==y.first && x.second<y.second || x.first<y.first;
  };
};
#endif
