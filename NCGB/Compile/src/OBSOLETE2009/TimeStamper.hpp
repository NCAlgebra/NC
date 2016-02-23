// (c) Mark Stankus 1999
// TimeStamper.h

#ifndef INCLUDED_TIMESTAMPER_H
#define INCLUDED_TIMESTAMPER_H

// This is the functional part of a factory for "Tags"

class TimeStamper {
  static vector<pair<unsigned long,char *> > s_time;
  int d_which;
public:
  TimeStamper(const char * s) : d_which(s_time.size()) {
    pair<unsigned long,char *> pr(0,strdup(s));
    s_time.push_back(pr);
  };
  TimeStamper(const TimeStamper & x) : d_which(x.d_which) {};
  int which() const { return d_which;};
  unsigned long time() const { return s_time[d_which];};
  void passtime() { ++s_time[d_which];};
};
#endif
