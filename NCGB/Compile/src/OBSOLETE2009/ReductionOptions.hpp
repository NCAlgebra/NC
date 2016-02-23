//   ReductionOptions.h

#ifndef INCLUDED_REDUCTIONOPTIONS_H
#define INCLUDED_REDUCTIONOPTIONS_H

class ReductionOptions {
  ReductionOptions(const ReductionOptions &);
    // not implemented
  void operator=(const ReductionOptions &);
    // not implemented
public:
  ReductionOptions();
  ~ReductionOptions();
  bool LookAtIterationCount;
  int highIterationCount;
};

inline ReductionOptions::ReductionOptions(){};

inline ReductionOptions::~ReductionOptions(){};
#endif
