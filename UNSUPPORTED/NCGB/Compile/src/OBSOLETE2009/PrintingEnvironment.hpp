// Mark Stankus 1999 (c)
// Printing Enviroment.h

#ifndef INCLUDED_PRINTINGENVIRONMENT_H
#define INCLUDED_PRINTINGENVIRONMENT_H

class PrintingEnvironment {
public:
  const char * newparagraph() { return "\n\n";};
  const char * nextline() { return "\n";};
};
#endif
