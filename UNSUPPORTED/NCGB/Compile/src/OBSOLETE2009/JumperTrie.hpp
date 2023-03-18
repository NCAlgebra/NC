// Mark Stankus 
// JumperTrie.hpp

#ifndef INCLUDED_JUMPERTRIE_H
#define INCLUDED_JUMPERTRIE_H

class JumperTrie {
  Monomial d_m;
  list<Polynomial> d_rests;
  class Jump {
    Jump(const Location & from,const Location & to) : d_from(from), d_to(to) {}; 
    ~Jump(){};
    Location d_from, d_to; 
  };
  vector<Jump> d_jump_forward;
  struct Location {
    Location(JumperTrie * place_p,int num) : d_place_p(place_p), d_num(num) {};
    ~Location(){};
    JumperTrie * d_place_p;
    int d_num;
  };
  vector<Jump> d_jump_forward;
  bool force_forward(const Variable & v,Location & L) {
    bool didit = false;
    const Monomial & m = L.d_place_p->d_m;
    MonomialIterator w = m.begin();
    int m.n = L.d_num;
    int sz = m.numberOfFactors();
    m = n;
    while(n) {
      --n;++w;
    };
    if(m==sz) {
    } else {
      ++w;
      if(v==*w) {
        ++L.d_num;
        didit = true;
      } else {
        // we cannot go forward, we may have to jump!
        typedef vector<Jump>::const_iterator VCI;
        VCI w = d_jump_forward.begin(), e = d_jump_forward.end();
        while(w!=e) {
          const Jump & j = *w;
          if(j.d_from.d_place_p == L.d_place_p && j.d_from.d_num==L.d_num) {
            DBG();
            break;
          };
          ++w;
        };
      };
    vector<Jump> d_jump_forward;
  };
};
#endif
