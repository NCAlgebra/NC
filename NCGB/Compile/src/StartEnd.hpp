// (c) Mark Stankus 1999
// StartEnd.h

#ifndef INCLUDED_STARTEND_H
#define INCLUDED_STARTEND_H

struct AnAction {
  const char * d_s;
  static const char * s_last;
private:
  AnAction();
public:
  AnAction(const char * s) : d_s(s) { s_last = d_s;};
  const char * const str() const { return d_s;};
  virtual ~AnAction();
  virtual void action() = 0;
};

struct AddingStart{
  AddingStart(AnAction *);
  static void s_execute();
  static void s_print();
};

struct AddingEnd {
  AddingEnd(AnAction *);
  static void s_execute();
};

struct AddingCrash {
  AddingCrash(AnAction *);
  static void s_execute();
};

struct AddingVersion {
  AddingVersion(AnAction *);
  static void s_execute();
};
#endif
