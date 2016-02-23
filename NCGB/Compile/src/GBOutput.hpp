// GBOutput.h

#ifndef INCLUDED_GBOUTPUT_H
#define INCLUDED_GBOUTPUT_H

class FactControl;
class Sink;
class symbolGB;
class stringGB;

void GBOutput(int,Sink &);
void GBOutput(long,Sink &);
void GBOutputTrueFalse(bool,Sink &);
inline void GBOutput(bool b,Sink & sink) { GBOutputTrueFalse(b,sink);};
void GBOutputSymbol(const char * const ,Sink &);
void GBOutputSymbol(const symbolGB &,Sink &);
void GBOutputString(const char * const ,Sink &);
void GBOutputString(const stringGB &,Sink &);
void GBOutputNull(Sink &);
void GBOutputAborted(Sink&);
#endif
