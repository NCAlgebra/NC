// TestMarker.c

#include "Source.hpp"
#include "Sink.hpp"


void _TestMarker(Source & so,Sink & si) {
  so.shouldBeEnd();
  si.noOutput();
};
