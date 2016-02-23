// Mark Stankus 1999 (c)
// GBHistoryHTML.hpp

#ifndef INCLUDED_ GBHISTORYHTML_H
#define INCLUDED_ GBHISTORYHTML_H

class GBHistoryHTML {
  const FactControl & d_fc;
  const int d_n;
public:
  GBHistoryHTML(const FactControl & fc,int n) : d_fc(fc), d_n(n) {};
  void GetGraphChildren(vector<GBHistoryHTML*> & x);
  HTML * HTMLGraphNode();
};
#endif
