// FactControl.c

#include "FactControl.hpp"
#include "GBStream.hpp"
#include "RecordHere.hpp"
#include "load_flags.hpp"
#ifdef PDLOAD
#ifndef INCLUDED_USEROPTIONS_H
#include "UserOptions.hpp"
#endif
#include "MyOstream.hpp"

const char * FactControl::addFactS = "MXS: Adding fact number ";
const char * FactControl::whichIs = " which is ";
const char FactControl::newline = '\n';
const char * FactControl::tried = "Tried to add ";
const char * FactControl::toTheList = " to the list.\n";
const char * FactControl::afterInsert = "The list after the insertion is ";
const char * FactControl::Thevalue = "The value ";
const char * FactControl::nowAppears = " now appears " ;
const char * FactControl::times = " times.\n";
const char * FactControl::Triedtoremove = "Tried to remove ";
const char * FactControl::Thelistafterthedeletionis = "The list after the deletion is " ;

// A stupid and ugly print function. Not used much
void FactControl::PrintArrays(MyOstream & out) const {
  int i;
  out << "Facts:\n";
  FactListType::const_iterator ww = 
      ((const FactListType &)_facts).begin();
  const int sz1 = _facts.size();
  for (i = 1; i <= sz1; ++i,++ww) {
    const GroebnerRule & rule = *ww;
    out << i << ") ";
    out << rule;
    out  << '\n' << rule;
    out  << '\n';
  }
  out << "History:\n";
  const int sz2 = _history.size();
  HistoryListType::const_iterator j = 
      ((const HistoryListType &)_history).begin();
  for (i = 1; i <= sz2; ++i,++j) {
    out << i << ") " << *j << '\n';
  }
  out << "Degrees:\n";
  const int sz3 = _extra.size();
  for(i=1;i<=sz3;++i) {
    out << i << ") " << _extra[i] << '\n';
  }
 
  out << "Permanent:\n";
  GBList<int>::const_iterator w = 
     ((const GBList<int> &)_permanent).begin();
  const int sz4 = _permanent.size();
  for (i = 1; i <= sz4; ++i,++w) {
    out << i << ") " << *w << '\n';
  }
}

int FactControl::addFact(const Fact & aFact) {
  GBHistory dummy1(0,0);
  int dummy2=-999;
  return addFactAndHistory(aFact,dummy1,dummy2);
};

// Add data to (*this)
int FactControl::addFactAndHistory(const Fact & aFact,
         const History & history,const int & extra) {
   intpair temp = _facts.Member(aFact);
   int result;
   if(temp.first()) {
     result = temp.second();
   } else {
     _facts.push_back(aFact);
     _history.push_back(history);
     _extra.push_back(extra);
     d_numberOfFacts++;
     result = d_numberOfFacts;
   }
   return result;
};

// operator = so we can have a list of FactControl's
void FactControl::operator = (const FactControl & x) { 
  clearFacts();
  _facts = x._facts; 
  _history = x._history;
  _extra = x._extra;
  _permanent = x._permanent;
  d_numberOfFacts = x.d_numberOfFacts;
  _done = x._done;
};

void FactControl::expandDoneList(int i) { 
  int diff = i - _done.size();
  GBList<int> aList;
  for(int k=1;k<=diff;++k) {
    _done.push_back(aList);
  }
};

GroebnerRule * InvalidHistoryFact_p = (GroebnerRule *) 0;

inline void setInvalidHistoryFact() {
  if(!InvalidHistoryFact_p) {
    Variable tempv("InvalidHistoryRule");
    Monomial tempm;
    tempm *= tempv;
    Polynomial tempp;
    RECORDHERE(InvalidHistoryFact_p = new GroebnerRule(tempm,tempp);)
GBStream << "InvalidHistoryFact_p is pointing to " 
         << * InvalidHistoryFact_p << '\n';
  }
};

void FactControl::setFactPermanent(int index) {
  if(! getFactPermanent(index)) {
    if(!UserOptions::s_recordHistory) {
      setInvalidHistoryFact();
      if(fact(index)==*InvalidHistoryFact_p) DBG();
    };
    _permanent.push_back(index);
  }
};

void FactControl::unsetFactPermanent(int index) {
  intpair temp = _permanent.Member(index);
  if(temp.first()) {
    GBList<int>::const_iterator i = 
        ((const GBList<int> &)_permanent).begin();
    i.advance(temp.second()-1);
    if((*i)!= index) {
      DBG();
    }
    if(!UserOptions::s_recordHistory) {
      setInvalidHistoryFact();
      GBList<GroebnerRule>::iterator w = _facts.begin();
      w.advance(index-1);
GBStream << "Rule before becoming invalid:" << *w << '\n';
      *w = *InvalidHistoryFact_p;
GBStream << "Rule after becoming invalid:" << *w << '\n';
    };
    _permanent.removeElement(temp.second());
  }
};

const FactControl::Fact & FactControl::fact(int index) const {
  GBList<GroebnerRule>::const_iterator w = _facts.begin();
  for(int i=2;i<=index;++i) {++w;}; // start i=2 as at begin already.
  return * w;
};        

const FactControl::History & FactControl::history(int index) const {
  GBList<GBHistory>::const_iterator w = _history.begin();
  for(int i=2;i<=index;++i) {++w;}; // start i=2 as at begin already.
  return * w;
};

GBVector<int> FactControl::PermNumbers() const { 
  GBVector<int> result;
  vector<int> temp;
  const int len = _extra.size();
  int n;
  int tempsz;
  for(int i=1;i<=len;++i) {
    n = _extra[i];
    tempsz = temp.size();
    if(n>=tempsz) {
      for(int j=tempsz-1;j<=n;++j) { temp.push_back(-1);};
    };
    if(temp[n]==-1) temp[n] = i; 
  };
  tempsz = temp.size();
  int j=0;
  int item;
  bool didUserSelects = false;
  for(int tempcounter=0;tempcounter<tempsz;++tempcounter) {
    if(temp[tempcounter]!=-1) {
      InternalPermanentType::const_iterator w = _permanent.begin();
      const int permsize = _permanent.size();
      for(int k=1;k<=permsize;++k,++w) {
        item = (*w);
        if(_extra[item]==j) {
          result.push_back(item);
        }
      }
      if(!didUserSelects) {
        didUserSelects = true;
        GBList<GroebnerRule>::const_iterator w = 
          ((const GBList<GroebnerRule> &)::selectRules).begin();
        const int sz = ::selectRules.size();
        for(int j=1;j<=sz;++j,++w) {
          intpair pair(_facts.Member(*w));
          if(pair.first()) {
            if(getFactPermanent(pair.second())) {
              result.push_back(pair.second());
            };
          }
        };
      };
    };
  };
  return result;
};

const GroebnerRule & FactControl::grabRule(int i) const {
  return fact(i);
#if 0
  int j = i-1;
  int  sz = d_rules.size();
  for(;j>=sz;++sz) { d_rules.push_back((GroebnerRule *)0);};
  d_rules[j] = (GroebnerRule *) &fact(i);
#endif
};

bool FactControl::findFact(const GroebnerRule & x,int & n) const {
  bool result = false;
  int sz = _facts.size();
  GBList<GroebnerRule>::const_iterator w = _facts.begin();
  for(int i=1;i<=sz;++i,++w) {
    if(x==*w) {
      result = true;
      n = i;
      break;
    };
  };
  return result;
};

void FactControl::getFacts(GBList<GroebnerRule> & x)  const {
  x = _facts;
};

#include "Choice.hpp"
#include "GBVector.cpp"
#include "iterGBVector.cpp"
#include "constiterGBVector.cpp"
template class GBVector<GBList<GroebnerRule>::const_iterator>;
template class const_iter_GBVector<GBList<GroebnerRule>::const_iterator>;
template class iter_GBVector<GBList<GroebnerRule>::const_iterator>;
template class GBVector<GBList<GBHistory>::const_iterator>;
template class const_iter_GBVector<GBList<GBHistory>::const_iterator>;
template class iter_GBVector<GBList<GBHistory>::const_iterator>;
#endif
