// PointerPool.h

template<class T,class NEW
class fieldRepPool {
  static int s_numberOut;
  static int s_numberTotal;
  static vector<FieldRep *> s_free;
public:
  fieldRepPool() { s_free.reserve(100);};
  ~fieldRepPool() {};
  static FieldRep * s_allocate() {
    FieldRep * result;  
    if(s_free.empty()) {
      result = Field::s_currentRep_p->clone();
    } else { 
      result = s_free.back();
      s_free.pop_back();
    };
    return result;
  };
  static void s_release(FieldRep * p) {
    --s_numberOut;
    s_free.push_back(p);
  };
};

int fieldRepPool::s_numberOut = 0;
int fieldRepPool::s_numberTotal = 0;
vector<FieldRep *> fieldRepPool::s_free;

FieldRep * fieldRepMemory() {
  return fieldRepPool::s_allocate();
};

void fieldRepMemory(FieldRep * p) {
  fieldRepPool::s_release(p);
};

#ifndef INCLUDED_FIELDREPMEMORY_H
#define INCLUDED_FIELDREPMEMORY_H

FieldRep * fieldRepMemory();
void fieldRepMemory(FieldRep * p);

#endif
