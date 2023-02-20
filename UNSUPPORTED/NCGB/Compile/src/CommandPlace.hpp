// (c) Mark Stankus 1999
// CommandPlace.h

#ifndef INCLUDED_COMMANDPLACE_H
#define INCLUDED_COMMANDPLACE_H

struct CommandPlace {
  CommandPlace(int which,int data,int numargs,const char * s) :
         d_which_list(which), d_data(data), d_numargs(numargs), d_s(s) {};
  const int d_which_list;
  const int d_data;
  const int d_numargs;
  const char * const d_s;
  static void s_setCommandPlace(const char * s);
  static CommandPlace * s_CommandPlace;
};
#endif
