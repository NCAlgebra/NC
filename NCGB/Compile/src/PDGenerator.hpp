// PDGenerator.h

#ifndef INCLUDED_PDGENERATOR_H
#define INCLUDED_PDGENERATOR_H

#include "Generator.hpp"
#include "FactControl.hpp"
#include "UnifierBin.hpp"
#include "GBMatch.hpp"
//#pragma warning(disable:4786)
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <utility>
#else
#include <pair.h>
#endif
#ifdef HAS_INCLUDE_NO_DOTS
#include <set>
#else
#include <set.h>
#endif
#include "less_pair.hpp"

#include "vcpp.hpp"

class PDGenerator : public Generator {
  void operator=(const PDGenerator &);
    // not implemented
  FactControl & d_fc;
  UnifierBin * d_bin_p;
  list<Match> d_list;
  pair<int,int> d_numbers;
  bool shouldReject() const;
  set<int,less<int> > d_toremove;
  set<pair<int,int>,less_pair > d_toremove_pairs;
public:
  PDGenerator(FactControl & fc,UnifierBin * bin_p) : Generator(), d_fc(fc), d_bin_p(bin_p) {};
  PDGenerator(const PDGenerator & x) : Generator(), d_fc(x.d_fc), d_bin_p(0), d_list(x.d_list),
      d_numbers(x.d_numbers) {
    d_bin_p = new UnifierBin(d_fc);
  };
  virtual ~PDGenerator();

  // SPI Specific
//FAT  virtual void insert(const SPI &);
  virtual void insert(const SPIID &);
  virtual void remove(const SPIID &);
  virtual void remove(const SPIID &,const SPIID &);
//FAT  virtual void remove(const SPIID &,list<SPI>&);


  // Match Specific
  virtual bool getNext(Match &);
//FAT  virtual void insert(const Match &);
//FAT  virtual void remove(int,list<Match>&);

  // Polynomial Specific
  virtual bool getNext(Polynomial &);

  // Polynomial And GBHistory Specific
  virtual bool getNext(Polynomial &,GBHistory &);

  // SPI and Polynomial Specific
//FAT  virtual bool getNext(SPI &,Polynomial &);


  // Match and Polynomial Specific
  virtual bool getNext(Match &,Polynomial &);

  // Match and Polynomial and GBHistory Specific
  virtual bool getNext(Match &,Polynomial &,GBHistory &);

  // General 
  virtual void clear();
  virtual long size() const;
  virtual Generator * clone() const;
  virtual bool empty() const;
  virtual bool iterationEmpty() const;
  virtual void fillForUnknownReason();
  virtual const GroebnerRule & retrieve(const SPIID &) const;
};
#endif
