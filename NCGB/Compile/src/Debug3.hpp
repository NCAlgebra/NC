// Debug3.h 

#ifndef INCLUDED_DEBUG3_H 
#define INCLUDED_DEBUG3_H

#include "OfstreamProxy.hpp"

struct Debug3 {
  static OfstreamProxy s_ErrorFile;
  static OfstreamProxy s_TimingFile;
  static OfstreamProxy s_InefficiencyFile;
  static OfstreamProxy s_NeedToWriteCodeFile;
};
#endif
