// marker.h

#ifndef INCLUDED_MARKER_H
#define INCLUDED_MARKER_H

class Source;
class Sink;
#include "simpleString.hpp"

class marker {
public:
  marker();
  marker(const marker & mark);
  void operator=(const marker &);
  ~marker();
  void get(Source & ioh);
  void getNamed(const char * const,Source & ioh);
  void put(Sink & ioh) const;
  const char * name() const { return d_name.chars();};
  void name(const char * const);
  bool nameis(const char * const) const;
  static marker s_last_marker;
   int num() const { return d_number;};
   void num(int n) { d_number = n;};
private:
  int d_number;
  simpleString d_name;
};
#endif
