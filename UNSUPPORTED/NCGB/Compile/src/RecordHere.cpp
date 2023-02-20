// RecordHere.c 

#include "RecordHere.hpp"


char * s_RECORDHERE_File_Where = 0;
int    s_RECORDHERE_Line_Where = 0;

void addToFileStack(char * s,int n) {
  s_RECORDHERE_File_Where = s;
  s_RECORDHERE_Line_Where = n;
};

void getFromFileStack() {
  s_RECORDHERE_File_Where = 0;
  s_RECORDHERE_Line_Where = -999;
};
