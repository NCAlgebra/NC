// FactControl.h

#ifndef INCLUDED_FACTCONTROL_H
#define INCLUDED_FACTCONTROL_H

#include "FactBase.hpp"

#ifndef INCLUDED_LOAD_FLAGS_H
#include "load_flags.hpp"
#endif
#ifdef PDLOAD
#ifndef INCLUDED_GBHISTORY_H
#include "GBHistory.hpp"
#endif
#ifndef INCLUDED_GROEBNERRULE_H
#include "GroebnerRule.hpp"
#endif
#ifndef INCLUDED_GBLIST_H
#include "GBList.hpp"
#endif
#ifndef INCLUDED_GBVECTOR_H
#include "GBVector.hpp"
#endif

extern GBList<GroebnerRule> selectRules;

class FactControl : public FactBase {
  friend class OKFriend;
public:
  typedef GroebnerRule Fact;
  typedef GBHistory History;
  typedef GBList<int> InternalPermanentType;
  typedef GBList<History> HistoryListType;
  typedef GBVector<int> ExtraListType;

  FactControl();
  FactControl(const FactControl & x);
  virtual ~FactControl();
  void operator = (const FactControl & x);

  // accessor functions
  const GroebnerRule & fact(int index) const {
    return *d_rules[index-1];
  };
  const History & history(int index) const;
  const int & extra(int index) const;
  bool findFact(const GroebnerRule &,int &) const;
  void getFacts(GBList<GroebnerRule> &) const;
  friend MyOstream & operator << (MyOstream & os, const FactControl & x)
     { x.PrintArrays(os); return os;};
  void PrintArrays(MyOstream & out) const;

  // update functions
  int addFact(const Fact & aFact);
  int addFactAndHistory(const Fact & aFact,
                        const History & aHistory,
                        const int & extra);
  inline void clearFacts();

  // permanence functions
  void setFactPermanent(int index);
  void unsetFactPermanent(int index);
  inline bool getFactPermanent(int index) const;
  int numberOfPermanentFacts() const {return _permanent.size();};
  int indexOfnthPermanentFact(int n) const;
  const GBList<int> & indicesOfPermanentFacts() const;
  GBList<int>::const_iterator permanentBegin() const;

  void markDone(int i,int j);
  bool isDoneQ(int i,int j);
  bool operator == (const FactControl & fc) const;
  bool operator != (const FactControl & fc) const { return !((*this)==fc);};
  GBVector<int> PermNumbers() const; 
private: 
   HistoryListType _history;
   ExtraListType _extra;
   GBVector<GBList<History>::const_iterator> _historyIterators;
   GBList<int> _permanent;
   GBList<GBList<int> > _done;
   GBList<GBList<GBList<int> >::iterator>  _doneIt;
#ifdef CAREFUL 
   void check(int index) const;
#endif
  static const char * addFactS;
  static const char * whichIs;
  static const char newline;
  static const char * tried;
  static const char * toTheList;
  static const char * afterInsert;
  static const char * Thevalue;
  static const char * nowAppears;
  static const char * times;
  static const char * Triedtoremove;
  static const char * Thelistafterthedeletionis;
  void expandDoneList(int i);
  virtual const GroebnerRule & grabRule(int i) const;
};

inline FactControl::FactControl()  {
  clearFacts();
};

inline FactControl::FactControl(const FactControl & x)  {
  operator =(x);
};

inline FactControl::~FactControl() {
  clearFacts();
};

inline void FactControl::clearFacts() {
  clearFactBase();
  _history.clear();
  _extra.clear();
  _historyIterators.clear();
  d_numberOfFacts = 0;
  _done.clear();
  _doneIt.clear();
};

inline const int & FactControl::extra(int index) const {
#ifdef CAREFUL
   check(index);
#endif
   return _extra[index];
};

inline bool FactControl::getFactPermanent(int index) const {
#ifdef CAREFUL
   check(index);
#endif
  return _permanent.Member(index).first();
};

inline int FactControl::indexOfnthPermanentFact(int n) const {
  GBList<int>::const_iterator i = _permanent.begin();
  i.advance(n-1);
  return *i;
}

inline const GBList<int> & FactControl::indicesOfPermanentFacts() const { 
  return _permanent;
};

inline GBList<int>::const_iterator FactControl::permanentBegin() const { 
  return _permanent.begin();
};

inline bool FactControl::isDoneQ(int i,int j) {
  bool flag = _done.size()>=i;
  if(!flag) {
    GBList<GBList<int> >::const_iterator ww = 
      ((const GBList<GBList<int> > &)_done).begin();
    ww.advance(i-1);
    flag = (*ww).Member(j).first();
  }
  return flag;
};

// Mark that fact(i) can not be simplified using fact(j)
inline void FactControl::markDone(int i,int j) { 
  if(_done.size()<i) {
    expandDoneList(i);
  }
  GBList<GBList<int> >::iterator ww = _done.begin();
  ww.advance(i-1);
  (*ww).insertIfNotMember(j);
};
#endif 
#endif
