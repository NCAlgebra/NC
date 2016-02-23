// subMonomial.c

#include "subMonomial.hpp"
#include "MyOstream.hpp"
#include "Debug1.hpp"
#include "GBStream.hpp"


void subMonomial::errorh(int n) { DBGH(n); };

void subMonomial::errorc(int n) { DBGC(n); };

const char * subMonomial::startSetTo = "The start of an subMonomial was set to ";
const char subMonomial::period = '.';
const char subMonomial::space = ' ';
const char subMonomial::newline = '\n';
const char * subMonomial::andThere = " and there are only ";
const char * subMonomial::children = "children.\n";
const char * subMonomial::lengthSetTo = "The length was set to ";
const char * subMonomial::Induced = "Induced:";
const char * subMonomial::subMonomialString = "subMonomial:";

// Calculate the first place where (*this) and aSubMonomial differ
// Returned value is a length (from the start's of the subMonomials.
int subMonomial::firstDifferSubMonomial(const subMonomial & aSubMonomial) const {
   int result = -1; // -1 indicates equality
#if 0
   bool shouldLoop = true;
   MonomialIterator j = start_iterator;
   MonomialIterator k = aSubMonomial.start_iterator;
   for(int i=1;i<=_length && shouldLoop;++i,++j,++k) {
      shouldLoop = (* j) == (* k);
      if(!shouldLoop) result = i;
   }
#else
   s_first_helper = start_iterator;
   s_second_helper = aSubMonomial.start_iterator;
   for(int i=1;i<=_length;++i,++s_first_helper,++s_second_helper) {
      if(!(*s_first_helper==*s_second_helper)) {
        result = i;
        break;
      };
   }
#endif
   return result;
};

int subMonomial::findVariableForward(int len,const Variable & v) {
  int result = -1;
  for(int i=1;i<=len  && result==-1;++i) {
    if(v==*start_iterator) {
      result = start();
    } else {
      incrementStart();
    };
  }
  return result;
};

int subMonomial::findVariableBackward(int len,const Variable & v) {
  int result = -1;
  for(int i=1;i<=len  && result==-1;++i) {
    if(v==*start_iterator) {
      result = start();
    } else {
      decrementStart();
    };
  }
  return result;
};

void subMonomial::error1(int newstart) const {
  GBStream << "The start of an subMonomial was set to "
           << newstart << ".\n";
  errorc(__LINE__);
};

void subMonomial::error2(int newstart) const {
  GBStream << "The start of an subMonomial was set to "
       << newstart << " and there are only "
       << _mono.numberOfFactors() << " factors .\n";
  GBStream << "The length was set to " << _length << '\n';
  errorc(__LINE__);
};

void subMonomial::error3(int newlength) const {
  GBStream << "Induced:" << newlength << '\n';
  errorc(__LINE__);
};

void subMonomial::error4(int newlength) const {
  GBStream << "subMonomial:" << _start << ' ' << newlength
              << ' ' << _mono.numberOfFactors() << '\n';
  errorc(__LINE__);
};

void subMonomial::error5() const {
  GBStream << "The start of an subMonomial was set to "
        << _start+1 << " and there are only "
        << _mono.numberOfFactors() << "factors.\n";
  GBStream << "The length was set to " << _length << "\n";
  errorc(__LINE__);
};

void subMonomial::error6(int newstart) const {
  GBStream << "The start of an subMonomial was set to "
           << newstart << ".\n";
};

MonomialIterator subMonomial::s_first_helper;
MonomialIterator subMonomial::s_second_helper;
