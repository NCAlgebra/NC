// BaRoutineFactory.h

#ifndef INCLUDED_BAROUTINEFACTORY_H
#define INCLUDED_BAROUTINEFACTORY_H

class MngrStart;

class BaRoutineFactory {
  BaRoutineFactory();
    // not implemented
  BaRoutineFactory(const BaRoutineFactory &);
    // not implemented
  void operator =(const BaRoutineFactory &);
    // not implemented
  const int d_ID;
  static BaRoutineFactory * s_Current_p;
protected:
  explicit BaRoutineFactory(int id) : d_ID(id) {};
public:
  int ID() const { return d_ID;};
  virtual ~BaRoutineFactory() = 0;
  virtual MngrStart * create() = 0;
  static void s_setCurrent();
  static void s_setCurrent(BaRoutineFactory *);
  static BaRoutineFactory & s_getCurrent();
  static bool s_currentValid();
};
#endif
