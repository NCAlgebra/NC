// Mark Stankus 1999 (c)
// SFSGNode.c

#include "SFSGNode.hpp"
#include "PrintList.hpp"
#include "PrintVector.hpp"

void SFSGNode::printPaths(list<pair<int,int> > V,Monomial m,MyOstream & os) const {
#if 0
  GBStream << "Printing path via node " << d_number 
           << " with " << d_number_of_parents << " parents.\n";
#endif
  if(d_number<0 || d_number>200) errorc(__LINE__);
  m *= d_v;
  pair<int,int> pr(d_number,numberOfParents());
  V.push_back(pr);
  typedef vector<SFSGNode *>::const_iterator VCI;
  VCI  w = d_forward.begin(), e = d_forward.end();
  if(w==e) {
    // Are at a leaf
#ifdef DEBUG_SFSGNODE
    list<pair<int,int> >::const_iterator mxsw = V.begin(), mxse = V.end(); 
    while(mxsw!=mxse) {
      os << "Node " << (*mxsw).first << " with " << (*mxsw).second 
         << "parents\n";
      ++mxsw;
    };
#endif
    GBStream << m;
#if 1
    if(d_rules) {
      typedef CRULES::iterator VVI;
      VVI ww = d_rules->begin(), ee = d_rules->end();
      while(ww!=ee) {
        (*ww)->print(GBStream);
         ++ww;
      };
    };
#endif
    GBStream << '\n';
  } else {
    while(w!=e) {
      (*w)->printPaths(V,m,os);
      ++w;
    };
  };
};
void SFSGNode::printPaths(MyOstream & os) const {
#if 1
  Monomial m;
  list<pair<int,int> > V;
  printPaths(V,m,os);
#else 
  os << "d_m:" << data() << " number:" << d_number << '\n';
#endif
};

void SFSGNode::print(MyOstream & os,PrintStyle s) const {
  printPaths(os);
  if(0/*s==HTMLFULL*/) {
    print(os,HTML);
    typedef vector<SFSGNode*>::const_iterator VI;
    VI w = d_forward.begin(), e = d_forward.end();
    while(w!=e) {
      (*w)->print(os,HTMLFULL);
      ++w;
    };
  } else if(s==HTML || s ==HTMLFULL) {
    os << "<table border=\"4\">\n";
    os << "<tr><td>\n";
    os << "<font color = \"yellow\">Node number:" << d_number << "</font>\n";
    os << "<font color=\"red\">Variable: " << data() << "</font>\n";
    os << "<font color=\"blue\">Number of parents: " 
       << numberOfParents() << "</font>\n";
    if(!!d_rules) {
      if(d_rules->empty()) errorc(__LINE__);
      os << "<font color=\"blue\">";
      CRULES::const_iterator ww = d_rules->begin(), ee = d_rules->end();
      while(ww!=ee) {
        (*ww)->print(os,HTML);
        ++ww;
      };
      os << "</font>\n";
    };
    os << "</td><td>\n";
    vector<SFSGNode *>::const_iterator w = d_forward.begin(), e = d_forward.end();
    int i = 1;
    os << "<table border=\"8\">\n";
    while(w!=e) {
      os << "<tr><td>\n";
      (*w)->print(os,HTMLFULL);
      os << "</td></tr>\n";
      ++w;++i;
    };
    os << "</table>\n";
    os << "</table>\n";
  } else {
    GBStream << "Node #" << d_number << " " << data() << '\n';
  };
};

void SFSGNode::errorh(int n) { DBGH(n); };

void SFSGNode::errorc(int n) { DBGC(n); };

bool SFSGNode::hasChild(const Variable & v,SFSGNode * & ptr) const {
  GBStream << "Is there a child of " << number() << " with variable label "
           << v << '\n';
  ptr = 0;
  typedef vector<SFSGNode*>::const_iterator VI;
  bool result = false;
  VI w = d_forward.begin(), e = d_forward.end();
  while(w!=e) {
    if((*w)->data()==v) {
      result = true;
      ptr = *w;
      break;
    };
    ++w;
  };
  if(result) {
    GBStream << "There is a child with variable label " << v << '\n';
  } else {
    GBStream << "There is NOT a child with variable label " << v << '\n';
  };
  return result;
};


