// (c) Mark Stankus 1999
// TriePolySource.h

#ifndef INCLUDED_TRIEPOLYSOURCE_H
#define INCLUDED_TRIEPOLYSOURCE_H

#include "PolySource.hpp"
#include "Trie.hpp"

class TriePolySource : public PolySource {
  static void errorh(int);
  static void errorc(int);
  Trie d_t;
public:
  TriePolySource(Trie & t) : PolySource(s_ID), d_t(t) {};
  virtual ~TriePolySource();
  virtual bool getNext(Polynomial & p,ReductionHint &,Tag *,Tag & limit);
  virtual void insert(const RuleID &);
  virtual void insert(const PolynomialData &);
  virtual void remove(const RuleID &);
  virtual void fillForUnknownReason();
  virtual void print(MyOstream &) const;
  virtual void setPerm(int);
  virtual void setNotPerm(int);
};
#endif
