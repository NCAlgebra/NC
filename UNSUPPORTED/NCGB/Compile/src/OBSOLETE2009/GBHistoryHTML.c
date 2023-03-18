// Mark Stankus 1999 (c) 
// GBHistoryHTML.c 

#include "GBHistoryHTML.hpp"

class GBHistoryHTML {
  const FactControl & d_fc;
  const int d_n;
public:
void GBHistoryHTML::GetGraphChildren(vector<GBHistoryHTML*> & x) {
};

HTML * HTMLGraphNode() {
  HTMLCollection * result = new HTMLCollection;
  StringAccumulator s;
  MyOstream os(acc);
  int m = d_n;
  if(d_n<0) {
    os << "<font color=\"red\">CleanUpBasis</font>\n";
    m = -m;
  } else if(d_n==0) {
    os << "<font color=\"red\">Given</font>\n";
  };
  os << "History Number:<a href=\"" << m << ".html\">" << m << "</a>\n";
};
