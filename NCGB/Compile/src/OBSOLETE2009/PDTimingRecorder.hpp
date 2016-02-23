// PDTimingRecorder.h

#ifndef INCLUDED_PDTIMINGRECORDER_H
#define INCLUDED_PDTIMINGRECORDER_H

class Polynomial;
#ifndef INCLUDED_SPI_H
#include "SPI.hpp"
#endif

class PDTimingRecorder : public TimingRecorder {
  PDTimingRecorder(const PDTimingRecorder &);
    // not implemented
  void operator=(const PDTimingRecorder &);
    // not implemented
protected:
  PDTimingRecorder();
public:
  virtual ~PDTimingRecorder();
  virtual void perform(const char * name,int ID);
};
#endif
