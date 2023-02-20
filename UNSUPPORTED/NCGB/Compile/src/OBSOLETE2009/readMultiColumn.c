// Mark Stankus 1999 (c)

#include "GraphVertex.hpp"
#include "ColoredGraph.hpp"
#include "TriColor.hpp"
#include <assert.h>
#include "Choice.hpp"
#ifdef HAS_INCLUDE_NO_DOTS
#include <fstream>
#include <string>
#include <list>
#else
#include <fstream.h>
#include <string.h>
#include <list.h>
#endif

void readMultiColumns(ifstream & ifs,list<list<string> > & S) {
  list<string> aLine;
  string word;
  bool inWord = false;
  char c;
  while(!ifs.eof()) {
    ifs.get(c); 
    if(c==' ' || c=='\r') {
      if(inWord) {
        aLine.push_back(word);
        word = "";
        inWord = false;
      };
    } else if(c=='\n') {
      if(!(word=="")) {
        aLine.push_back(word);
        word = "";
      };
      if(!aLine.empty()) {
        S.push_back(aLine);
        aLine.erase(aLine.begin(),aLine.end());
      };
      inWord = false;
    } else if(inWord) {
      word += c;
    } else {
      inWord = true;
      word = c;
    };
  }; 
  assert(word=="");
};
