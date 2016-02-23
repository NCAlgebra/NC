// (c) Mark Stankus 1999
// Command.h

#ifndef INCLUDED_COMMAND_H
#define INCLUDED_COMMAND_H

class Source;
class Sink;

struct AddingCommand {
  AddingCommand(const char * ,int n,void (*)(Source &,Sink &),const char * filename = 0);
};

void execute_command(const char *,Source &,Sink &);

#endif
