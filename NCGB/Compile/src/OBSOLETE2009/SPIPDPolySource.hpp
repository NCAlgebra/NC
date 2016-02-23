// Mark Stankus 1999 (c)
// SPIPDPolySource.hppp

#ifndef INCLUEDED_SPIPDPOLYSOURCE_H
#define INCLUEDED_SPIPDPOLYSOURCE_H

#include "PolySource.hpp"
#include "RuleID.hpp"
#include "ICopy.hpp"
#include "SPI.hpp"
#include "SetSource.hpp"
#include "SPISource.hpp"
#include "Choice.hpp"
#pragma warning(disable:4786)
#ifdef HAS_INCLUDE_NO_DOTS
#include <list>
#include <set>
#include <utility>
#else
#include <list.h>
#include <set.h>
#include <pair.h>
#endif
#include "vcpp.hpp"
class GiveNumber;

class PDPolySource : public PolySource {
  void operator=(const PDPolySource &);
    // not implemented
  list<Match> d_list;
  pair<int,int> d_numbers;
  set<RuleID> d_active;
  set<RuleID> d_inactive;
  ICopy<SetSource<pair<int,int> > > d_ints;
  void fillList();
  void spolynomial(const Match &,Polynomial &) const;
  GiveNumber & d_give;
public:
  PDPolySource(SPISource & d_spis,
      const ICopy<SetSource<pair<int,int> > > & ints) : PolySource(s_ID),
      d_active(active), d_inactive(inactive), d_ints(ints), d_give(give) {};
  PDPolySource(const PDPolySource & x) : d_active(x.d_active), 
     d_inactive(x.d_inactive), d_ints(x.d_ints), d_give(x.d_give) {};
  virtual ~PDPolySource();
  virtual void insert(const RuleID &);
  virtual void insert(const PolynomialData &);
  virtual void remove(const RuleID &);
  virtual void fillForUnknownReason();
  virtual void print(MyOstream &) const;
  virtual void setPerm(int n);
  virtual void setNotPerm(int n);
    
  bool getNext(Polynomial & p,Tag *,Tag &) {
    bool result = false;
    bool todo = true;
    while(todo) {
      if(d_list.empty()) {
        if(d_ints.access().getNext(d_numbers)) {
          fillList();
        } else {
          todo = false;
          result = false;
        };
      } else {
        spolynomial(d_list.front(),p);
        d_list.pop_front();
        todo = p.zero();  
        result = !todo;
      };
    };
    return result;
  };
  static const int s_ID;
};
#endif
#endif
