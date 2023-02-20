// (c) Mark Stankus 1999
// DisplayPart.h

#ifndef INCLUDED_DISPLAYPART_H
#define INCLUDED_DISPLAYPART_H

class DisplayPart {
  static DisplayPart * s_part;
public:
  DisplayPart(){};
  virtual ~DisplayPart() = 0;
  virtual void perform() const = 0;
  static void part(DisplayPart * p) {
    delete s_part;
    s_part = p;
  };
  static const DisplayPart * const part() {
    return s_part;
  };
};
#endif
