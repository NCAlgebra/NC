// integerMemory.c

#include "integerMemory.hpp"
#include "RecordHere.hpp"
#include "Debug1.hpp"

  // Assumption: sizeof(int)==sizeof(int*)
  // Assumption: int p; int * q; p = *q; is "nice"

class integerPool {
  static int s_numberOut;
  static int s_numberTotal;
  static int s_GROW;
  static int * s_free_p;
public:
  integerPool() {};
  ~integerPool() {};
  static int * s_allocate() {
    int * result = s_free_p;
    if(result) {
      s_free_p = (int *) *result;
    } else {
      RECORDHERE(int * q = result = new int[s_GROW];)
      s_numberTotal += s_GROW;
      s_free_p = q+1;
      for(int i=1;i<s_GROW;++i,++q) {
        *q = (int) q+1;
      };
      *q = 0; 
    };
    ++s_numberOut;
    return result;
  };
  static void s_release(int * p) {
    --s_numberOut;
    *p = (int) s_free_p;
    s_free_p = p;
  };
};

int integerPool::s_GROW = 10;
int integerPool::s_numberOut = 0; 
int integerPool::s_numberTotal = 0; 
int * integerPool::s_free_p = 0;

int * integerMemory() {
  return integerPool::s_allocate();
};

void integerMemory(int * p) {
  integerPool::s_release(p);
};
