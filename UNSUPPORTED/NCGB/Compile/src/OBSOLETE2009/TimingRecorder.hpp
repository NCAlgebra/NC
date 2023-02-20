// TimingRecorder.h

#ifndef INCLUDED_TIMINGRECORDER_H
#define INCLUDED_TIMINGRECORDER_H

class Polynomial;
#ifndef INCLUDED_SPI_H
#include "SPI.hpp"
#endif

class TimingRecorder {
  TimingRecorder(const TimingRecorder &);
    // not implemented
  void operator=(const TimingRecorder &);
    // not implemented
protected:
  TimingRecorder();
public:
  virtual ~TimingRecorder();
  virtual void start(int ID) = 0;
  virtual void print(const char * name,int ID) = 0;
  virtual void printpause(const char * name,int ID) = 0;
  virtual TimingRecorder * clone() const = 0;
};
#endif
