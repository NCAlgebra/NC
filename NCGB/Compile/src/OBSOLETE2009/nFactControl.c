// FactControl.c

#include "nFactControl.hpp"
#pragma warning(disable:4786)
#include "RecordHere.hpp"
#include "load_flags.hpp"
#ifdef PDLOAD
#ifndef INCLUDED_USEROPTIONS_H
#include "UserOptions.hpp"
#endif
#include "MyOstream.hpp"
#include "my_stl_algo.hpp"

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
  out << "Facts:\n";
  vector<GroebnerRule *>::const_iterator ww = d_rules.begin();
  vector<GroebnerRule *>::const_iterator ee = d_rules.end();
  int i=1;
  while(ww!=ee) {
    out << i << ") " << *ww << '\n';
    ++ww;++i;
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
   int result;
   if(findFact(aFact,result)) {
     DBG();
   } else {
     d_rules.push_back(new GroebnerRule(aFact));
     _history.push_back(history);
     GBList<History>::const_iterator iter2 = 
        ((const GBList<History>)_history).begin();
     iter2.advance(_history.size()-1);
     _historyIterators.push_back(iter2);
     _extra.push_back(extra);

     ++d_numberOfFacts;
     ++d_rules_sz;
     result = d_numberOfFacts;
   }
   return result;
};

// operator = so we can have a list of FactControl's
void FactControl::operator = (const FactControl & x) { 
  if(this!=&x) {
    clearFacts();
    d_rules.reserve(x.d_rules.size());
    copynew(x.d_rules.begin(),x.d_rules.end(),back_inserter(d_rules),
            (GroebnerRule *)0);
    _history = x._history;
    _extra = x._extra;
    _historyIterators = x._historyIterators;
    _permanent = x._permanent;
    d_numberOfFacts = x.d_numberOfFacts;
    _done = x._done;
    _doneIt = x._doneIt;
  };
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
GBStream << "Rule before becoming invalid:" << fact(index) << '\n';
      d_rules[index-1]  = new GroebnerRule(*InvalidHistoryFact_p);
GBStream << "Rule after becoming invalid:" << fact(index) << '\n';
    };
    _permanent.removeElement(temp.second());
  }
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
      GBList<int>::const_iterator w = _permanent.begin();
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
        int place;
        for(int j=1;j<=sz;++j,++w) {
          if(findFact(*w,place)) {
            if(getFactPermanent(place)) {
              result.push_back(place);
            };
          }
        };
      };
    };
  };
  return result;
};

const GroebnerRule & FactControl::grabRule(int i) const {
  DBG();
  return *(const GroebnerRule *) 0;
};

bool FactControl::operator == (const FactControl & fc) const { 
  bool result = _history == fc._history && 
                _extra == fc._extra &&
                _permanent == fc._permanent;
  if(result) {
    const int sz = numberOfFacts();
    for(int i=1;result && i<=sz;++i) {
      result = fact(i)==fc.fact(i);
    };
  };
  return result;
};

bool FactControl::findFact(const GroebnerRule & x,int & n) const {
  bool result = false;
  typedef vector<GroebnerRule *>::const_iterator VI;
  VI w = d_rules.begin(), e = d_rules.end();
  int i = 1;
  while(w!=e) {
    if(x==**w) {
      result = true;
      n = i;
      break;
    };
    ++w;++i;
  };
  return result;
};

void FactControl::getFacts(GBList<GroebnerRule> & x) const { 
  typedef vector<GroebnerRule *>::const_iterator VI;
  VI w = d_rules.begin(), e = d_rules.end();
  while(w!=e) {
    x.push_back(**w);
    ++w;
  };
};
#endif
