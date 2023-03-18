// (c) Mark Stankus 1999
// PDPolySource.c

#include "PDPolySource.hpp"
#include "GBMatch.hpp"
#include "GiveNumber.hpp"
#include "GeneralMora.hpp"
#include "GroebnerRule.hpp"
#include "Polynomial.hpp"
#include "MatcherMonomial.hpp"
#include "UserOptions.hpp"
#include "TripleList.hpp"
#include "PolynomialData.hpp"

extern TripleList<int> * s_TripleList;

PDPolySource::~PDPolySource() {};

void PDPolySource::insert(const RuleID & x) {
  int num = x.number();
  s_TripleList->addItem(num);
  setPerm(num);
};

void PDPolySource::insert(const PolynomialData & x) {
  int num = x.d_number;
  s_TripleList->addItem(num);
  setPerm(num);
};

void PDPolySource::remove(const RuleID &) {
  errorc(__LINE__);
};

void PDPolySource::fillForUnknownReason() {
  d_ints.access().fillForUnknownReason();
};

void PDPolySource::print(MyOstream & os) const {
  os << "Cannot output a polynomial source yet.\n";
};

#if 0
bool findRule(RuleID &,int,set<RuleID> &);
#endif

void PDPolySource::spolynomial(const Match & aMatch,
     Polynomial & result) const {
   const GroebnerRule & rule1 = d_give.fact(d_numbers.first);
   const GroebnerRule & rule2 = d_give.fact(d_numbers.second);
   Polynomial firstpart;
   firstpart.doubleProduct(aMatch.const_left1(),
                           rule1.RHS(),
                           aMatch.const_right1());
   Polynomial secondpart;
   secondpart.doubleProduct(aMatch.const_left2(),
                            rule2.RHS(),
                            aMatch.const_right2());
   result = firstpart;
   result -= secondpart;
}

void PDPolySource::setPerm(int n) {
  d_give.setPerm(n);
};

void PDPolySource::setNotPerm(int n) {
  d_give.setNotPerm(n);
};

bool PDPolySource::getNext(Polynomial & p,ReductionHint&,Tag *,Tag &) {
  bool result = false;
  bool todo = true;
  while(todo) {
    if(d_list.empty()) {
      if(d_ints.access().getNext(d_numbers)) {
        fillList();
#if 0
GBStream << "Adding " << d_list.size() << " (" 
         << d_numbers.first << ' ' << d_numbers.second << ")\n";
#endif
      } else {
        todo = false;
        result = false;
      };
    } else {
      ++s_number_of_spolynomials;
      spolynomial(d_list.front(),p);
      d_list.pop_front();
      todo = p.zero();  
      result = !todo;
    };
  };
  return result;
};

#include "idValue.hpp"
const int PDPolySource::s_ID = idValue("PDPolySource::s_ID");

void PDPolySource::errorh(int n) { DBGH(n); };

void PDPolySource::errorc(int n) { DBGC(n); };
