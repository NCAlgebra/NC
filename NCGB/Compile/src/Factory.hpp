// Factory.h

#ifndef INCLUDED_FACTORY_H
#define INCLUDED_FACTORY_H

template<class T>
class Factory {
private:
  const int d_ID;
  static Factory * s_Current_p;
protected:
  explicit Factory(int id) : d_ID(id) {};
public:
  Factory();
  int ID() const { return d_ID;};
  virtual ~Factory() = 0;
  virtual T * create() = 0;
  static void s_setCurrent();
  static void s_setCurrent(Factory *);
  static Factory & s_getCurrent();
  static bool s_currentValid();
};
#endif
