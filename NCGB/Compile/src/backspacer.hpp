// backspacer.h

#ifndef INCLUDED_BACKSPACER_H
#define INCLUDED_BACKSPACER_H

#include "load_flags.hpp"

#ifdef PDLOAD

class MyOstream;

class backspacer {
private:
  backspacer(const backspacer&);
    // not implemented
  void operator=(const backspacer&);
    // not implemented
public:
   backspacer(MyOstream & os,int n,int direction) : 
       _n(n), _direction(direction), _os(os) {
       _obackspace = 0;
       if(_direction==0) {int m=0; m = 1/m;};
       updateBspace();
   };
   backspacer(MyOstream & os,const char * const);
   ~backspacer(){};
   void updateBspace();
   void show();
   void clear();
private:
   int _n;
   int _nbackspace;
   int _obackspace;
   int _direction;
   int _nextupdate;
   MyOstream & _os;
   void status(MyOstream & OS);
};
#endif
#endif
