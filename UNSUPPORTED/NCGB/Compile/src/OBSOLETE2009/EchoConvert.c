// Mark Stankus 1999 (c)
// EchoConvert.c

#include "mathlink.h"

int s_number = 0;

void EchoIt(MLINK stdlink,MLINK ml,bool b) {
  bool inCompound = false;
  int i;
  double d;
  char * s = 0;
  char * t = 0;
  long m,n;
  switch(MLGetType(stdlink)) {
  case MLTKINT;
     MLGetInteger(stdlink,&i);
     MLPutInteger(ml,i);
     break;
  case MLTKSYMB;
     MLGetSymbol(stdlink,&s);
     t = new char[strlen(s)+4];
     strcpy(t,s);
     strcat(t,"MXS");
     MLPutSymbol(ml,t);
     delete [] t;
     MLDisownSymbol(stdlink,s);
     break;
  case MLTKSTR;
     MLGetString(stdlink,&s);
     MLPutString(ml,s);
     MLDisownString(stdlink,s);
     break;
  case MLTKINT;
     MLGetInteger(stdlink,&i);
     MLPutInteger(ml,i);
     break;
  case MLTKFUNC;
     MLGetFunction(stdlink,&s,m);
     strcpy(t,s);
     strcat(t,"MXS");
     if(strcmp(s,"CompoundExpression")==0 && b) {
       inCompound = true;
       MLPutFunction(ml,t,2*m);
     } else {
       MLPutFunction(ml,t,m);
     };
     delete [] t;
     for(long n=1;n<=m;++n) {
       if(inCompound) {
         MLPutFunction(ml,"Print",4L); 
         MLPutString(ml,"Function:");
         MLPutString(ml,s);
         MLPutString(ml," ");
         MLPutInteger(ml,s_number);
         ++s_number;
       };
       EchoIt(stdlink,ml,b);
     };
     inCompound = false;
     break;
  default:
     DBG();
     break;
  };
};

int _EchoConvert(MLINK mlp) {
  long errno = 0L;
  MLINK ml = MLLoopbackOpen(stdenv,&errno);
  int n;
  MLGetInteger(stdlink,n);
  bool b = n!=0; 
  EchoIt(stdlink,ml,b);
  return 0;
};
